import httpx
import pytest

from tests.conftest import FakeResponse
from tilawa_proxy.config import config
from tilawa_proxy.main import _extract_transcript

HEADERS = {"X-Device-Id": "device-abcdef123456"}

DEEPGRAM_OK = {
    "results": {"channels": [{"alternatives": [{"transcript": "بسم الله"}]}]}
}


def test_healthz_reports_configuration_without_leaking_the_key(client):
    body = client.get("/healthz").json()
    assert body["ok"] is True
    assert body["deepgram_configured"] is True
    assert "test-key" not in str(body)


def test_transcribes_and_returns_the_text(client, fake_upstream):
    fake = fake_upstream(FakeResponse(200, DEEPGRAM_OK))
    r = client.post("/v1/transcribe", content=b"audio-bytes", headers=HEADERS)
    assert r.status_code == 200
    assert r.json() == {"transcript": "بسم الله"}
    assert fake.calls[0]["content"] == b"audio-bytes"


def test_the_key_is_attached_server_side_not_by_the_caller(client, fake_upstream):
    fake = fake_upstream(FakeResponse(200, DEEPGRAM_OK))
    client.post("/v1/transcribe", content=b"audio", headers=HEADERS)
    assert fake.calls[0]["headers"]["Authorization"] == "Token test-key"


def test_unconfigured_server_refuses_rather_than_calling_upstream(
    client, monkeypatch
):
    monkeypatch.setattr(config, "deepgram_api_key", "")
    r = client.post("/v1/transcribe", content=b"audio", headers=HEADERS)
    assert r.status_code == 503


@pytest.mark.parametrize("device_id", ["", "short", "x" * 129])
def test_bad_device_id_is_rejected(client, device_id):
    r = client.post(
        "/v1/transcribe", content=b"audio", headers={"X-Device-Id": device_id}
    )
    assert r.status_code == 400


def test_empty_body_is_rejected(client):
    assert client.post("/v1/transcribe", content=b"", headers=HEADERS).status_code == 400


def test_oversized_audio_is_rejected_before_upstream(client, fake_upstream):
    fake = fake_upstream(FakeResponse(200, DEEPGRAM_OK))
    r = client.post("/v1/transcribe", content=b"x" * 2048, headers=HEADERS)
    assert r.status_code == 413
    assert fake.calls == [], "must not pay to transcribe an oversized upload"


def test_per_device_limit_kicks_in(client, fake_upstream):
    fake_upstream(FakeResponse(200, DEEPGRAM_OK))
    for _ in range(config.per_device_hourly):
        assert client.post("/v1/transcribe", content=b"a", headers=HEADERS).status_code == 200
    r = client.post("/v1/transcribe", content=b"a", headers=HEADERS)
    assert r.status_code == 429


def test_a_second_device_is_not_blocked_by_the_first(client, fake_upstream):
    fake_upstream(FakeResponse(200, DEEPGRAM_OK))
    for _ in range(config.per_device_hourly):
        client.post("/v1/transcribe", content=b"a", headers=HEADERS)
    other = {"X-Device-Id": "device-zzzzzz999999"}
    assert client.post("/v1/transcribe", content=b"a", headers=other).status_code == 200


def test_global_cap_bounds_the_bill_across_devices(client, fake_upstream):
    fake_upstream(FakeResponse(200, DEEPGRAM_OK))
    sent = 0
    for i in range(10):
        headers = {"X-Device-Id": f"device-{i:012d}"}
        r = client.post("/v1/transcribe", content=b"a", headers=headers)
        if r.status_code == 429:
            break
        sent += 1
    assert sent == config.global_daily


def test_upstream_auth_failure_is_not_leaked_to_the_user(client, fake_upstream):
    fake_upstream(FakeResponse(401, {"err_msg": "invalid credentials"}))
    r = client.post("/v1/transcribe", content=b"a", headers=HEADERS)
    assert r.status_code == 502
    assert "credential" not in r.text.lower()
    assert "invalid" not in r.text.lower()


def test_upstream_timeout_becomes_504(client, fake_upstream):
    fake_upstream(error=httpx.TimeoutException("slow"))
    r = client.post("/v1/transcribe", content=b"a", headers=HEADERS)
    assert r.status_code == 504


def test_upstream_transport_error_becomes_502(client, fake_upstream):
    fake_upstream(error=httpx.ConnectError("down"))
    r = client.post("/v1/transcribe", content=b"a", headers=HEADERS)
    assert r.status_code == 502


@pytest.mark.parametrize(
    "payload",
    [
        {},
        {"results": {}},
        {"results": {"channels": []}},
        {"results": {"channels": [{}]}},
        {"results": {"channels": [{"alternatives": []}]}},
        {"results": {"channels": [{"alternatives": [{}]}]}},
        "not-a-dict",
        None,
    ],
)
def test_malformed_upstream_payloads_yield_an_empty_transcript(payload):
    assert _extract_transcript(payload) == ""


def test_extracts_the_first_alternative():
    payload = {
        "results": {
            "channels": [{"alternatives": [{"transcript": "one"}, {"transcript": "two"}]}]
        }
    }
    assert _extract_transcript(payload) == "one"
