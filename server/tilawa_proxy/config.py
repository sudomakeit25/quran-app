"""Runtime configuration, all overridable by environment variables on Render."""

import os


def _int_env(name: str, default: int) -> int:
    raw = os.environ.get(name)
    if not raw:
        return default
    try:
        return int(raw)
    except ValueError:
        return default


class Config:
    """Settings read once at import time.

    Every limit is tunable without shipping an app update, which is the whole
    point of putting a server in front of Deepgram.
    """

    def __init__(self) -> None:
        self.deepgram_api_key = os.environ.get("DEEPGRAM_API_KEY", "")
        self.deepgram_url = os.environ.get(
            "DEEPGRAM_URL",
            "https://api.deepgram.com/v1/listen"
            "?model=whisper-large&language=ar&smart_format=true",
        )
        # A recited ayah is seconds long. Anything much larger is not a
        # recitation, so reject it before paying to transcribe it.
        self.max_audio_bytes = _int_env("MAX_AUDIO_BYTES", 8 * 1024 * 1024)
        self.per_device_hourly = _int_env("PER_DEVICE_HOURLY", 60)
        self.global_daily = _int_env("GLOBAL_DAILY", 5000)
        self.upstream_timeout_seconds = _int_env("UPSTREAM_TIMEOUT_SECONDS", 120)

        # Optional Upstash Redis. Without it, limits are per-process and reset
        # whenever the instance restarts, which on Render's free tier is often.
        self.upstash_url = os.environ.get("UPSTASH_REDIS_REST_URL", "")
        self.upstash_token = os.environ.get("UPSTASH_REDIS_REST_TOKEN", "")

    @property
    def configured(self) -> bool:
        return bool(self.deepgram_api_key)

    @property
    def durable_limits(self) -> bool:
        return bool(self.upstash_url and self.upstash_token)


config = Config()
