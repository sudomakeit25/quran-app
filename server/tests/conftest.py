import pytest

from tilawa_proxy import main
from tilawa_proxy.config import config
from tilawa_proxy.limits import InMemoryCounter


class FakeResponse:
    def __init__(self, status_code=200, payload=None):
        self.status_code = status_code
        self._payload = payload if payload is not None else {}

    def json(self):
        return self._payload


class FakeClient:
    """Stands in for httpx.AsyncClient so no test touches the network."""

    def __init__(self, response=None, error=None):
        self.response = response or FakeResponse()
        self.error = error
        self.calls = []

    def __call__(self, *args, **kwargs):
        return self

    async def __aenter__(self):
        return self

    async def __aexit__(self, *args):
        return False

    async def post(self, url, content=None, headers=None, **kwargs):
        self.calls.append({"url": url, "content": content, "headers": headers})
        if self.error:
            raise self.error
        return self.response


@pytest.fixture(autouse=True)
def clean_state(monkeypatch):
    """Every test starts with a configured server and empty counters."""
    monkeypatch.setattr(config, "deepgram_api_key", "test-key")
    monkeypatch.setattr(config, "max_audio_bytes", 1024)
    monkeypatch.setattr(config, "per_device_hourly", 3)
    monkeypatch.setattr(config, "global_daily", 5)
    monkeypatch.setattr(main, "counter", InMemoryCounter())
    yield


@pytest.fixture
def client():
    from fastapi.testclient import TestClient

    return TestClient(main.app)


@pytest.fixture
def fake_upstream(monkeypatch):
    def install(response=None, error=None):
        fake = FakeClient(response=response, error=error)
        monkeypatch.setattr(main.httpx, "AsyncClient", fake)
        return fake

    return install
