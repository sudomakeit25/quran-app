import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// What the app remembers about one ayah the user has recited.
class AyahStats {
  final int surah;
  final int ayah;
  final int attempts;
  final double lastAccuracy;
  final double bestAccuracy;
  final DateTime lastAttemptAt;

  const AyahStats({
    required this.surah,
    required this.ayah,
    required this.attempts,
    required this.lastAccuracy,
    required this.bestAccuracy,
    required this.lastAttemptAt,
  });

  String get key => '$surah:$ayah';

  /// How badly this ayah needs practice. Higher means review sooner.
  ///
  /// Driven mostly by the most recent score, with a smaller pull from how long
  /// it has been since the last attempt, so a shaky ayah surfaces immediately
  /// and a solid one drifts back into the queue over about a month.
  double weakness({DateTime? now}) {
    final since = (now ?? DateTime.now()).difference(lastAttemptAt).inDays;
    final staleness = (since.clamp(0, 30)) / 30.0;
    return (1.0 - lastAccuracy) + staleness * 0.35;
  }

  AyahStats recordAttempt(double accuracy, DateTime at) => AyahStats(
        surah: surah,
        ayah: ayah,
        attempts: attempts + 1,
        lastAccuracy: accuracy,
        bestAccuracy: accuracy > bestAccuracy ? accuracy : bestAccuracy,
        lastAttemptAt: at,
      );

  Map<String, dynamic> toJson() => {
        'surah': surah,
        'ayah': ayah,
        'attempts': attempts,
        'last': lastAccuracy,
        'best': bestAccuracy,
        'at': lastAttemptAt.millisecondsSinceEpoch,
      };

  static AyahStats? fromJson(Map<String, dynamic> json) {
    final surah = json['surah'];
    final ayah = json['ayah'];
    final attempts = json['attempts'];
    final last = json['last'];
    final best = json['best'];
    final at = json['at'];
    if (surah is! num || ayah is! num || attempts is! num) return null;
    if (last is! num || best is! num || at is! num) return null;
    return AyahStats(
      surah: surah.toInt(),
      ayah: ayah.toInt(),
      attempts: attempts.toInt(),
      lastAccuracy: last.toDouble(),
      bestAccuracy: best.toDouble(),
      lastAttemptAt: DateTime.fromMillisecondsSinceEpoch(at.toInt()),
    );
  }
}

/// Orders attempted ayahs so the shakiest come first.
List<AyahStats> buildReviewQueue(
  Iterable<AyahStats> stats, {
  DateTime? now,
  double masteredAbove = 0.95,
}) {
  final at = now ?? DateTime.now();
  final queue = stats
      // An ayah recited near-perfectly on the last attempt is not worth
      // re-queueing until it has had time to go stale.
      .where((s) => s.lastAccuracy < masteredAbove || s.weakness(now: at) > 0.3)
      .toList()
    ..sort((a, b) => b.weakness(now: at).compareTo(a.weakness(now: at)));
  return queue;
}

class ReciteHistoryNotifier extends StateNotifier<Map<String, AyahStats>> {
  final Box _box;
  static const _key = 'recite_stats';

  ReciteHistoryNotifier(this._box) : super(_load(_box));

  static Map<String, AyahStats> _load(Box box) {
    final raw = box.get(_key);
    if (raw is! String || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      final out = <String, AyahStats>{};
      decoded.forEach((k, v) {
        if (k is! String || v is! Map) return;
        final stats = AyahStats.fromJson(v.cast<String, dynamic>());
        if (stats != null) out[k] = stats;
      });
      return out;
    } catch (_) {
      return {};
    }
  }

  void _persist() {
    _box.put(
      _key,
      jsonEncode(state.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }

  void record(int surah, int ayah, double accuracy, {DateTime? at}) {
    final when = at ?? DateTime.now();
    final key = '$surah:$ayah';
    final existing = state[key];
    final updated = existing == null
        ? AyahStats(
            surah: surah,
            ayah: ayah,
            attempts: 1,
            lastAccuracy: accuracy,
            bestAccuracy: accuracy,
            lastAttemptAt: when,
          )
        : existing.recordAttempt(accuracy, when);
    state = {...state, key: updated};
    _persist();
  }

  void clear() {
    _box.delete(_key);
    state = {};
  }
}

final reciteHistoryProvider =
    StateNotifierProvider<ReciteHistoryNotifier, Map<String, AyahStats>>((ref) {
  return ReciteHistoryNotifier(Hive.box('bookmarks'));
});

/// The practice queue, weakest ayah first.
final reviewQueueProvider = Provider<List<AyahStats>>((ref) {
  final history = ref.watch(reciteHistoryProvider);
  return buildReviewQueue(history.values);
});
