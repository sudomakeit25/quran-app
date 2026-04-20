import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../settings/prayer_settings.dart';

class TodayPrayerInfo {
  final PrayerTimes times;
  final Prayer current;
  final Prayer next;
  final DateTime nextTime;

  TodayPrayerInfo({
    required this.times,
    required this.current,
    required this.next,
    required this.nextTime,
  });
}

// Default location: Makkah. Used as a fallback if geolocation fails.
final _defaultCoords = Coordinates(21.4225, 39.8262);

Future<Coordinates> _resolveCoords() async {
  try {
    return await _tryGeolocate().timeout(const Duration(seconds: 15));
  } catch (e) {
    // ignore: avoid_print
    print('Geolocation failed/timed out: $e — using default (Makkah)');
    return _defaultCoords;
  }
}

/// Force a fresh geolocation attempt (for manual "Use my location" button).
/// After granting permission, invalidate prayerInfoProvider to refetch.
Future<bool> requestUserLocation(WidgetRef ref) async {
  try {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    ref.invalidate(prayerInfoProvider);
    return true;
  } catch (e) {
    // ignore: avoid_print
    print('requestUserLocation failed: $e');
    return false;
  }
}

Future<Coordinates> _tryGeolocate() async {
  final enabled = await Geolocator.isLocationServiceEnabled();
  if (!enabled) return _defaultCoords;
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return _defaultCoords;
  }
  final pos = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low,
  );
  return Coordinates(pos.latitude, pos.longitude);
}

final prayerInfoProvider = FutureProvider<TodayPrayerInfo?>((ref) async {
  final settings = ref.watch(prayerSettingsProvider);
  final coords = await _resolveCoords();
  final params = settings.method.getParameters();
  params.madhab = settings.madhab;
  final times = PrayerTimes.today(coords, params);
  final current = times.currentPrayer();
  var next = times.nextPrayer();

  DateTime? nextTime;
  if (next != Prayer.none) {
    nextTime = times.timeForPrayer(next);
  }

  // After Isha, nextPrayer() returns Prayer.none. Compute tomorrow's Fajr.
  if (nextTime == null) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowDate = DateComponents(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
    );
    final tomorrowTimes = PrayerTimes(coords, tomorrowDate, params);
    nextTime = tomorrowTimes.fajr;
    next = Prayer.fajr;
  }

  nextTime = nextTime.toLocal();
  return TodayPrayerInfo(
    times: times,
    current: current,
    next: next,
    nextTime: nextTime,
  );
});

final tickProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});
