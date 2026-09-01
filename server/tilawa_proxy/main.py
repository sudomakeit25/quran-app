"""Transcription proxy for Tilawa's Ayah Check.

Why this exists: the Deepgram key used to be compiled into the app, where
anyone could pull it out of the IPA and spend against it, and rotating it meant
shipping an app update. The key now lives only here.

What this does not do: authenticate the caller. Any secret shipped in the app
would be just as extractable as the key was, so there is none. The device id is
an opaque identifier used to spread limits across installs, not a credential.
Abuse is therefore possible but bounded by the caps below, and those caps are
tunable from the Render dashboard without touching the app.
"""

from __future__ import annotations

import logging

import httpx
from fastapi import FastAPI, Header, HTTPException, Request
from fastapi.responses import JSONResponse

from .config import config
from .limits import (
    Counter,
    InMemoryCounter,
    UpstashCounter,
    daily_key,
    hourly_key,
)

logger = logging.getLogger("tilawa_proxy")

app = FastAPI(title="Tilawa transcription proxy", version="1.0.0")


def _build_counter() -> Counter:
    if config.durable_limits:
        return UpstashCounter(config.upstash_url, config.upstash_token)
    logger.warning(
        "Upstash not configured; rate limits are per-process and reset on restart"
    )
    return InMemoryCounter()


counter: Counter = _build_counter()


@app.get("/healthz")
async def healthz() -> dict:
    """Liveness plus a view of how the instance is configured.

    Deliberately reports whether the key is present, never the key itself.
    """
    return {
        "ok": True,
        "deepgram_configured": config.configured,
        "durable_limits": config.durable_limits,
        "limits": {
            "per_device_hourly": config.per_device_hourly,
            "global_daily": config.global_daily,
            "max_audio_bytes": config.max_audio_bytes,
        },
    }


@app.post("/v1/transcribe")
async def transcribe(
    request: Request,
    x_device_id: str = Header(default=""),
    content_type: str = Header(default="audio/*"),
) -> JSONResponse:
    if not config.configured:
        raise HTTPException(
            status_code=503,
            detail="Transcription is not configured on this server.",
        )

    device_id = x_device_id.strip()
    # Long enough to be a UUID, short enough that nobody is smuggling data in it.
    if not 8 <= len(device_id) <= 128:
        raise HTTPException(status_code=400, detail="Missing or invalid X-Device-Id.")

    audio = await request.body()
    if not audio:
        raise HTTPException(status_code=400, detail="Empty request body.")
    if len(audio) > config.max_audio_bytes:
        raise HTTPException(
            status_code=413,
            detail="Recording too large. Record a single ayah at a time.",
        )

    device_count = await counter.incr(hourly_key(device_id), 3600)
    if device_count > config.per_device_hourly:
        raise HTTPException(
            status_code=429,
            detail="Too many checks from this device. Try again later.",
        )

    # The global cap is the actual spend guard: it bounds the bill even if a
    # single actor cycles through device ids.
    global_count = await counter.incr(daily_key(), 86400)
    if global_count > config.global_daily:
        logger.error("Global daily transcription cap reached (%s)", config.global_daily)
        raise HTTPException(
            status_code=429,
            detail="Recitation checking is busy right now. Please try again later.",
        )

    try:
        async with httpx.AsyncClient(
            timeout=config.upstream_timeout_seconds
        ) as client:
            upstream = await client.post(
                config.deepgram_url,
                content=audio,
                headers={
                    "Authorization": f"Token {config.deepgram_api_key}",
                    "Content-Type": content_type or "audio/*",
                },
            )
    except httpx.TimeoutException:
        raise HTTPException(status_code=504, detail="Transcription timed out.")
    except httpx.HTTPError:
        logger.exception("Upstream request failed")
        raise HTTPException(status_code=502, detail="Transcription service error.")

    if upstream.status_code != 200:
        # Never surface the upstream body: it can echo request details, and its
        # auth failures are an operator problem, not something a user can fix.
        logger.error("Deepgram returned %s", upstream.status_code)
        status = 502 if upstream.status_code >= 500 else 502
        raise HTTPException(status_code=status, detail="Transcription service error.")

    return JSONResponse({"transcript": _extract_transcript(upstream.json())})


def _extract_transcript(payload: object) -> str:
    """Pulls the first alternative's transcript out of a Deepgram response."""
    if not isinstance(payload, dict):
        return ""
    results = payload.get("results")
    if not isinstance(results, dict):
        return ""
    channels = results.get("channels")
    if not isinstance(channels, list) or not channels:
        return ""
    first = channels[0]
    if not isinstance(first, dict):
        return ""
    alternatives = first.get("alternatives")
    if not isinstance(alternatives, list) or not alternatives:
        return ""
    alternative = alternatives[0]
    if not isinstance(alternative, dict):
        return ""
    transcript = alternative.get("transcript")
    return transcript if isinstance(transcript, str) else ""
