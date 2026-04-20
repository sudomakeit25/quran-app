import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class JourneyStats {
  final int streak;
  final bool readToday;
  final int ayahsToday;
  final int dailyGoalAyahs;
  const JourneyStats({
    required this.streak,
    required this.readToday,
    required this.ayahsToday,
    required this.dailyGoalAyahs,
  });

  bool get goalMet => ayahsToday >= dailyGoalAyahs;
  double get progress =>
      dailyGoalAyahs == 0 ? 0 : (ayahsToday / dailyGoalAyahs).clamp(0.0, 1.0);
}

String _dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class JourneyNotifier extends StateNotifier<JourneyStats> {
  final Box _box;
  JourneyNotifier(this._box) : super(_compute(_box));

  static const defaultGoal = 5;

  static JourneyStats _compute(Box box) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final dayKey = _dateKey(todayStart);
    final ayahsToday = (box.get('ayahs_$dayKey', defaultValue: 0) as int);
    final goal = box.get('daily_goal', defaultValue: defaultGoal) as int;
    final readToday = ayahsToday >= goal;

    var streak = 0;
    var d = readToday ? todayStart : todayStart.subtract(const Duration(days: 1));
    while (true) {
      final k = _dateKey(d);
      final n = box.get('ayahs_$k', defaultValue: 0) as int;
      if (n >= goal) {
        streak++;
        d = d.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return JourneyStats(
      streak: streak,
      readToday: readToday,
      ayahsToday: ayahsToday,
      dailyGoalAyahs: goal,
    );
  }

  /// Record that the user viewed an ayah today. Increments today's count
  /// and refreshes the stats.
  void recordAyahView(int surah, int ayah) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final dayKey = _dateKey(todayStart);
    final viewedKey = 'viewed_${dayKey}_$surah:$ayah';
    if (_box.get(viewedKey, defaultValue: false) as bool) return;
    _box.put(viewedKey, true);
    final current = (_box.get('ayahs_$dayKey', defaultValue: 0) as int) + 1;
    _box.put('ayahs_$dayKey', current);
    state = _compute(_box);
  }

  void setDailyGoal(int goal) {
    _box.put('daily_goal', goal);
    state = _compute(_box);
  }

  void refresh() {
    state = _compute(_box);
  }
}

final journeyProvider =
    StateNotifierProvider<JourneyNotifier, JourneyStats>((ref) {
  return JourneyNotifier(Hive.box('settings'));
});
