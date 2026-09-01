# Tilawa transcription proxy

Sits between the app and Deepgram so the API key is never shipped inside the app.

## Why

The key used to be compiled into the Flutter binary. Anyone who unpacked the
IPA could extract it and spend against the account, and rotating it meant
shipping an app update. Now the key lives only in this service's environment.

## What this does not do

It does not authenticate callers. Any shared secret placed in the app would be
exactly as extractable as the key was, so there is none. `X-Device-Id` is an
opaque random value generated per install; it spreads rate limits across
devices, it is not a credential.

Abuse is therefore possible but **bounded and tunable without an app update**:

| Guard | Env var | Default |
|---|---|---|
| Max upload | `MAX_AUDIO_BYTES` | 8 MB |
| Per device, per hour | `PER_DEVICE_HOURLY` | 60 |
| Global, per day (the spend cap) | `GLOBAL_DAILY` | 5000 |

The global cap is the one that actually bounds the bill, since a determined
caller can cycle device ids.

## Deploy to Render

1. Push this repo. `render.yaml` at the repo root defines the service with
   `rootDir: server`.
2. Create the service from the blueprint, then set **`DEEPGRAM_API_KEY`** in
   the dashboard. It is marked `sync: false` so it is never committed.
3. Optional but recommended: set `UPSTASH_REDIS_REST_URL` and
   `UPSTASH_REDIS_REST_TOKEN`. Without them, limits are per process and reset
   on every restart, and Render's free tier restarts often, so the daily cap
   would not really hold.
4. Confirm the hostname Render assigns. If it is not
   `https://tilawa-transcribe.onrender.com`, update the default in
   `lib/core/config/app_config.dart`, or build with
   `--dart-define=TILAWA_API_BASE=https://<actual-host>`.
5. Check it: `curl https://<host>/healthz` should report
   `"deepgram_configured": true`.

## Local development

```bash
cd server
python3 -m venv .venv
./.venv/bin/pip install -r requirements.txt pytest
./.venv/bin/python -m pytest tests -q
DEEPGRAM_API_KEY=... ./.venv/bin/uvicorn tilawa_proxy.main:app --port 8792
```

Point the app at it with
`flutter run --dart-define=TILAWA_API_BASE=http://localhost:8792`.

## API

`POST /v1/transcribe`, raw audio body, `X-Device-Id` header required.
Returns `{"transcript": "..."}`.

Errors are already worded for users, and the client shows the `detail` string
as-is. Upstream failures are deliberately flattened to a generic message so
Deepgram's responses are never echoed to the app.
