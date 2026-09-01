import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/recite/recite_history.dart';

AyahStats stats({
  int surah = 1,
  int ayah = 1,
  int attempts = 1,
  required double last,
  double? best,
  required DateTime at,
}) =>
    AyahStats(
      surah: surah,
      ayah: ayah,
      attempts: attempts,
      lastAccuracy: last,
      bestAccuracy: best ?? last,
      lastAttemptAt: at,
    );

void main() {
  final now = DateTime(2026, 8, 31, 12);

  group('AyahStats.weakness', () {
    test('a low score outranks a high one attempted at the same time', () {
      final weak = stats(ayah: 1, last: 0.4, at: now);
      final strong = stats(ayah: 2, last: 0.9, at: now);
      expect(weak.weakness(now: now), greaterThan(strong.weakness(now: now)));
    });

    test('the same score grows weaker as it goes stale', () {
      final fresh = stats(last: 0.8, at: now);
      final old = stats(last: 0.8, at: now.subtract(const Duration(days: 20)));
      expect(old.weakness(now: now), greaterThan(fresh.weakness(now: now)));
    });

    test('staleness saturates after 30 days', () {
      final month = stats(last: 0.8, at: now.subtract(const Duration(days: 30)));
      final year = stats(last: 0.8, at: now.subtract(const Duration(days: 365)));
      expect(year.weakness(now: now), month.weakness(now: now));
    });

    test('a perfect fresh attempt has the lowest possible weakness', () {
      expect(stats(last: 1.0, at: now).weakness(now: now), 0.0);
    });
  });

  group('AyahStats.recordAttempt', () {
    test('best accuracy is kept when a later attempt is worse', () {
      final first = stats(last: 0.9, at: now);
      final second = first.recordAttempt(0.5, now.add(const Duration(days: 1)));
      expect(second.lastAccuracy, 0.5);
      expect(second.bestAccuracy, 0.9);
      expect(second.attempts, 2);
    });

    test('best accuracy rises when a later attempt is better', () {
      final first = stats(last: 0.5, at: now);
      final second = first.recordAttempt(0.95, now);
      expect(second.bestAccuracy, 0.95);
    });
  });

  group('buildReviewQueue', () {
    test('orders weakest first', () {
      final queue = buildReviewQueue([
        stats(ayah: 1, last: 0.9, at: now),
        stats(ayah: 2, last: 0.3, at: now),
        stats(ayah: 3, last: 0.6, at: now),
      ], now: now);
      expect(queue.map((s) => s.ayah), [2, 3, 1]);
    });

    test('a freshly mastered ayah is not queued', () {
      final queue = buildReviewQueue([
        stats(ayah: 1, last: 1.0, at: now),
      ], now: now);
      expect(queue, isEmpty);
    });

    test('a mastered ayah returns to the queue once it goes stale', () {
      final queue = buildReviewQueue([
        stats(ayah: 1, last: 1.0, at: now.subtract(const Duration(days: 29))),
      ], now: now);
      expect(queue.map((s) => s.ayah), [1]);
    });

    test('an empty history yields an empty queue', () {
      expect(buildReviewQueue(const [], now: now), isEmpty);
    });

    test('ayahs from different surahs are ranked together', () {
      final queue = buildReviewQueue([
        stats(surah: 2, ayah: 255, last: 0.5, at: now),
        stats(surah: 112, ayah: 1, last: 0.2, at: now),
      ], now: now);
      expect(queue.first.surah, 112);
    });
  });
}
