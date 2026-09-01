"""Counters behind the rate limits.

The interface is a single "increment this key, tell me the new value" call, so
the in-memory and Upstash implementations stay interchangeable and the limit
logic itself is trivially testable.
"""

from __future__ import annotations

import time
from typing import Protocol

import httpx


class Counter(Protocol):
    async def incr(self, key: str, ttl_seconds: int) -> int:
        """Increment `key`, set its TTL on first write, return the new value."""


class InMemoryCounter:
    """Process-local counters.

    Adequate for a single always-on instance. On a free tier that spins down,
    or across multiple instances, counts reset or diverge, so the global spend
    cap should be backed by Upstash in production.
    """

    def __init__(self) -> None:
        self._values: dict[str, tuple[int, float]] = {}

    async def incr(self, key: str, ttl_seconds: int) -> int:
        now = time.monotonic()
        count, expires_at = self._values.get(key, (0, 0.0))
        if expires_at <= now:
            count, expires_at = 0, now + ttl_seconds
        count += 1
        self._values[key] = (count, expires_at)
        return count

    def reset(self) -> None:
        self._values.clear()


class UpstashCounter:
    """Counters in Upstash Redis, shared across instances and restarts."""

    def __init__(self, url: str, token: str, client: httpx.AsyncClient | None = None):
        self._url = url.rstrip("/")
        self._token = token
        self._client = client

    async def incr(self, key: str, ttl_seconds: int) -> int:
        commands = [["INCR", key], ["EXPIRE", key, str(ttl_seconds), "NX"]]
        client = self._client or httpx.AsyncClient(timeout=10)
        try:
            response = await client.post(
                f"{self._url}/pipeline",
                json=commands,
                headers={"Authorization": f"Bearer {self._token}"},
            )
            response.raise_for_status()
            body = response.json()
            return int(body[0]["result"])
        finally:
            if self._client is None:
                await client.aclose()


def hourly_key(device_id: str) -> str:
    return f"tilawa:device:{device_id}:{int(time.time() // 3600)}"


def daily_key() -> str:
    return f"tilawa:global:{int(time.time() // 86400)}"
