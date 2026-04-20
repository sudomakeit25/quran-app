import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive/hive.dart';

import '../home/home_providers.dart';

/// True if today (by Hijri calendar) is in Ramadan (month 9).
bool isRamadanToday([DateTime? now]) {
  final hijri = HijriCalendar.fromDate(now ?? DateTime.now());
  return hijri.hMonth == 9;
}

/// Returns (suhoor_end, iftar) for today in local time, derived from Fajr and Maghrib.
/// Returns null if prayer info is not yet available.
({DateTime suhoorEnd, DateTime iftar})? ramadanWindow(PrayerTimes? times) {
  if (times == null) return null;
  return (
    suhoorEnd: times.fajr.toLocal(),
    iftar: times.maghrib.toLocal(),
  );
}

String _dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Tracks fasted days and taraweeh days in Ramadan.
class RamadanTrackerNotifier extends StateNotifier<Map<String, dynamic>> {
  final Box _box;
  RamadanTrackerNotifier(this._box) : super(_load(_box));

  static Map<String, dynamic> _load(Box box) {
    return {
      'fasted': (box.get('fasted_list', defaultValue: const <String>[]) as List)
          .cast<String>()
          .toSet(),
      'taraweeh':
          (box.get('taraweeh_list', defaultValue: const <String>[]) as List)
              .cast<String>()
              .toSet(),
    };
  }

  void _persist() {
    _box.put('fasted_list', (state['fasted'] as Set<String>).toList());
    _box.put('taraweeh_list', (state['taraweeh'] as Set<String>).toList());
  }

  bool fastedOn(DateTime d) =>
      (state['fasted'] as Set<String>).contains(_dateKey(d));
  bool taraweehOn(DateTime d) =>
      (state['taraweeh'] as Set<String>).contains(_dateKey(d));

  void toggleFasted(DateTime d) {
    final s = Set<String>.from(state['fasted'] as Set<String>);
    final k = _dateKey(d);
    if (s.contains(k)) {
      s.remove(k);
    } else {
      s.add(k);
    }
    state = {...state, 'fasted': s};
    _persist();
  }

  void toggleTaraweeh(DateTime d) {
    final s = Set<String>.from(state['taraweeh'] as Set<String>);
    final k = _dateKey(d);
    if (s.contains(k)) {
      s.remove(k);
    } else {
      s.add(k);
    }
    state = {...state, 'taraweeh': s};
    _persist();
  }

  int get fastedCount => (state['fasted'] as Set<String>).length;
  int get taraweehCount => (state['taraweeh'] as Set<String>).length;
}

final ramadanTrackerProvider = StateNotifierProvider<RamadanTrackerNotifier,
    Map<String, dynamic>>((ref) {
  return RamadanTrackerNotifier(Hive.box('settings'));
});

final isRamadanProvider = Provider<bool>((ref) => isRamadanToday());

/// Countdown to next iftar or suhoor end. Watched during Ramadan.
final ramadanCountdownProvider =
    Provider<({Duration until, String label})?>((ref) {
  final info = ref.watch(prayerInfoProvider).asData?.value;
  if (info == null) return null;
  final window = ramadanWindow(info.times);
  if (window == null) return null;
  final now = DateTime.now();
  if (now.isBefore(window.suhoorEnd)) {
    return (until: window.suhoorEnd.difference(now), label: 'Suhoor ends in');
  }
  if (now.isBefore(window.iftar)) {
    return (until: window.iftar.difference(now), label: 'Iftar in');
  }
  // After iftar — count to next day's suhoor end using same fajr (approximation).
  final tomorrowSuhoor = window.suhoorEnd.add(const Duration(days: 1));
  return (until: tomorrowSuhoor.difference(now), label: 'Suhoor ends in');
});
