import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

enum PrayerKind { fajr, dhuhr, asr, maghrib, isha }

const prayerKindNames = {
  PrayerKind.fajr: 'Fajr',
  PrayerKind.dhuhr: 'Dhuhr',
  PrayerKind.asr: 'Asr',
  PrayerKind.maghrib: 'Maghrib',
  PrayerKind.isha: 'Isha',
};

String _dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Daily prayer log — which of the 5 daily prayers were prayed today.
class PrayerLogNotifier extends StateNotifier<Map<PrayerKind, bool>> {
  final Box _box;
  final DateTime _date;
  PrayerLogNotifier(this._box, this._date) : super(_load(_box, _date));

  static Map<PrayerKind, bool> _load(Box box, DateTime date) {
    final key = 'log_${_dateKey(date)}';
    final raw = box.get(key, defaultValue: const <String>[]) as List;
    final set = raw.cast<String>().toSet();
    return {
      for (final k in PrayerKind.values) k: set.contains(k.name),
    };
  }

  void _persist() {
    final names =
        state.entries.where((e) => e.value).map((e) => e.key.name).toList();
    _box.put('log_${_dateKey(_date)}', names);
  }

  void toggle(PrayerKind k) {
    state = {...state, k: !(state[k] ?? false)};
    _persist();
  }

  /// Count how many of the 5 are marked done today.
  int get completedCount => state.values.where((v) => v).length;
}

final prayerLogProvider = StateNotifierProvider.family<PrayerLogNotifier,
    Map<PrayerKind, bool>, DateTime>((ref, date) {
  return PrayerLogNotifier(Hive.box('settings'), date);
});

/// Compute last 7 days completion (0..5 per day) from the settings box.
List<int> last7DaysCompletion(Box box, DateTime today) {
  final out = <int>[];
  for (var i = 6; i >= 0; i--) {
    final d = today.subtract(Duration(days: i));
    final key = 'log_${_dateKey(d)}';
    final raw = box.get(key, defaultValue: const <String>[]) as List;
    out.add(raw.length);
  }
  return out;
}

/// Running streak: consecutive days ending today where all 5 prayers are done.
int computeStreak(Box box, DateTime today) {
  var streak = 0;
  var d = today;
  while (true) {
    final raw = box.get('log_${_dateKey(d)}', defaultValue: const <String>[])
        as List;
    if (raw.length == 5) {
      streak++;
      d = d.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  return streak;
}

/// Qada counter: persistent, per-prayer-type count of missed prayers.
class QadaNotifier extends StateNotifier<Map<PrayerKind, int>> {
  final Box _box;
  QadaNotifier(this._box) : super(_load(_box));

  static Map<PrayerKind, int> _load(Box box) {
    return {
      for (final k in PrayerKind.values)
        k: (box.get('qada_${k.name}', defaultValue: 0) as int),
    };
  }

  void increment(PrayerKind k) {
    state = {...state, k: (state[k] ?? 0) + 1};
    _box.put('qada_${k.name}', state[k]);
  }

  void decrement(PrayerKind k) {
    final next = ((state[k] ?? 0) - 1).clamp(0, 1 << 30);
    state = {...state, k: next};
    _box.put('qada_${k.name}', next);
  }

  int get total => state.values.fold(0, (a, b) => a + b);
}

final qadaProvider =
    StateNotifierProvider<QadaNotifier, Map<PrayerKind, int>>((ref) {
  return QadaNotifier(Hive.box('settings'));
});
