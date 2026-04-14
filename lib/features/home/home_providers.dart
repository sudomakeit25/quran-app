import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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
  final coords = await _resolveCoords();
  final params = CalculationMethod.muslim_world_league.getParameters();
  params.madhab = Madhab.shafi;
  final times = PrayerTimes.today(coords, params);
  final current = times.currentPrayer();
  final next = times.nextPrayer();
  var nextTime = times.timeForPrayer(next) ??
      times.timeForPrayer(Prayer.fajr) ??
      DateTime.now().add(const Duration(hours: 1));
  // adhan returns UTC DateTimes; convert to local for display
  nextTime = nextTime.toLocal();
  // ignore: avoid_print
  print('Coords: ${coords.latitude},${coords.longitude} | now=${DateTime.now()} '
      '| fajr=${times.fajr.toLocal()} dhuhr=${times.dhuhr.toLocal()} '
      'asr=${times.asr.toLocal()} maghrib=${times.maghrib.toLocal()} '
      'isha=${times.isha.toLocal()} | current=$current next=$next nextTime=$nextTime');
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
