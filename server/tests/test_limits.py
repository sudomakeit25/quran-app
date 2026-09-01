import asyncio

from tilawa_proxy.limits import InMemoryCounter, daily_key, hourly_key


def test_counter_increments_per_key():
    c = InMemoryCounter()
    assert asyncio.run(c.incr("a", 60)) == 1
    assert asyncio.run(c.incr("a", 60)) == 2
    assert asyncio.run(c.incr("b", 60)) == 1


def test_counter_restarts_after_the_window_expires():
    c = InMemoryCounter()
    assert asyncio.run(c.incr("a", 0)) == 1
    # A zero-second window is already expired on the next call.
    assert asyncio.run(c.incr("a", 0)) == 1


def test_reset_clears_everything():
    c = InMemoryCounter()
    asyncio.run(c.incr("a", 60))
    c.reset()
    assert asyncio.run(c.incr("a", 60)) == 1


def test_device_keys_are_namespaced_per_device():
    assert hourly_key("one") != hourly_key("two")
    assert hourly_key("one").startswith("tilawa:device:one:")


def test_global_key_is_shared():
    assert daily_key().startswith("tilawa:global:")
