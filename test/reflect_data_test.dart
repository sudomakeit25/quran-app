import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/reflect/reflect_data.dart';
import 'package:quran_app/features/reflect/reflect_journal.dart';

/// Ayah counts read from the translation the app actually ships, so a curated
/// reference can never point at an ayah that does not exist.
Map<int, int> loadAyahCounts() {
  final file = File('assets/quran/quran-en-saheeh.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final surahs = (json['data'] as Map<String, dynamic>)['surahs'] as List;
  return {
    for (final s in surahs)
      (s as Map)['number'] as int: (s['ayahs'] as List).length,
  };
}

void main() {
  final ayahCounts = loadAyahCounts();

  test('the bundled translation covers all 114 surahs', () {
    expect(ayahCounts.length, 114);
  });

  group('reflect data integrity', () {
    test('every referenced ayah exists in the bundled Quran', () {
      for (final mood in reflectMoods) {
        for (final verse in mood.verses) {
          final count = ayahCounts[verse.surah];
          expect(count, isNotNull,
              reason: '${mood.id}: surah ${verse.surah} does not exist');
          expect(verse.startAyah, greaterThanOrEqualTo(1),
              reason: '${mood.id}: ${verse.surah}:${verse.startAyah}');
          expect(verse.endAyah, lessThanOrEqualTo(count!),
              reason:
                  '${mood.id}: ${verse.surah}:${verse.endAyah} exceeds the $count ayahs in that surah');
        }
      }
    });

    test('ranges are ordered and stay short enough to read on a card', () {
      for (final mood in reflectMoods) {
        for (final verse in mood.verses) {
          expect(verse.endAyah, greaterThanOrEqualTo(verse.startAyah),
              reason: '${mood.id}: ${verse.surah}:${verse.startAyah}');
          expect(verse.ayahNumbers.length, lessThanOrEqualTo(4),
              reason:
                  '${mood.id}: ${verse.surah}:${verse.startAyah}-${verse.endAyah} is too long for a mood card');
        }
      }
    });

    test('no mood repeats the same verse', () {
      for (final mood in reflectMoods) {
        final seen = <String>{};
        for (final verse in mood.verses) {
          final key = '${verse.surah}:${verse.startAyah}-${verse.endAyah}';
          expect(seen.add(key), isTrue,
              reason: '${mood.id} lists $key more than once');
        }
      }
    });

    test('mood ids are unique and resolvable', () {
      final ids = reflectMoods.map((m) => m.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'duplicate mood id');
      for (final id in ids) {
        expect(moodById(id)?.id, id);
      }
      expect(moodById('not-a-mood'), isNull);
    });

    test('every mood carries enough verses to be worth opening', () {
      expect(reflectMoods.length, greaterThanOrEqualTo(14));
      for (final mood in reflectMoods) {
        expect(mood.verses.length, greaterThanOrEqualTo(5),
            reason: '${mood.id} is too thin');
        expect(mood.title.trim(), isNotEmpty);
        expect(mood.description.trim(), isNotEmpty);
      }
    });

    test('every verse has an original reflection of real substance', () {
      for (final mood in reflectMoods) {
        for (final verse in mood.verses) {
          expect(verse.reflection.trim().length, greaterThan(40),
              reason:
                  '${mood.id}: ${verse.surah}:${verse.startAyah} reflection is too thin');
        }
      }
    });

    test('allReflectRefs expands ranges into individual ayahs', () {
      final refs = allReflectRefs();
      final expected = reflectMoods.fold<int>(
        0,
        (sum, m) =>
            sum + m.verses.fold<int>(0, (s, v) => s + v.ayahNumbers.length),
      );
      expect(refs.length, expected);
      for (final (surah, ayah) in refs) {
        expect(ayah, lessThanOrEqualTo(ayahCounts[surah]!));
      }
    });

    test('no mood id collides with a sibling route under /reflect', () {
      // /reflect/journal is matched before /reflect/:moodId. A mood called
      // "journal" would be unreachable, so keep the names disjoint.
      const reservedSegments = {'journal'};
      for (final mood in reflectMoods) {
        expect(reservedSegments.contains(mood.id), isFalse,
            reason: 'mood id "${mood.id}" collides with a fixed route');
      }
    });

    test('reflection text does not restate the translation', () {
      // The reflection is the original content; if it were just the ayah again
      // it would add nothing over the reader.
      for (final mood in reflectMoods) {
        for (final verse in mood.verses) {
          expect(verse.reflection.trim(), isNot(startsWith('"')),
              reason: '${mood.id}: ${verse.surah}:${verse.startAyah}');
        }
      }
    });
  });

  group('reflect journal keys', () {
    test('a key identifies mood and verse together', () {
      const verse = ReflectVerse(surah: 2, startAyah: 155, endAyah: 156, reflection: 'x');
      expect(reflectionKey('grieving', verse), 'grieving|2:155-156');
    });

    test('the same verse under two moods gets two keys', () {
      const verse = ReflectVerse(surah: 39, startAyah: 53, reflection: 'x');
      expect(
        reflectionKey('anxious', verse),
        isNot(reflectionKey('forgiveness', verse)),
      );
    });

    test('a single ayah key collapses the range', () {
      const verse = ReflectVerse(surah: 50, startAyah: 16, reflection: 'x');
      expect(reflectionKey('lonely', verse), 'lonely|50:16-16');
    });

    test('SavedReflection round trips through json', () {
      final saved = SavedReflection(
        moodId: 'afraid',
        surah: 3,
        startAyah: 173,
        endAyah: 173,
        note: 'before the interview',
        savedAt: DateTime(2026, 8, 31, 9, 30),
      );
      final back = SavedReflection.fromJson(saved.toJson());
      expect(back, isNotNull);
      expect(back!.moodId, 'afraid');
      expect(back.note, 'before the interview');
      expect(back.savedAt, saved.savedAt);
      expect(back.key, saved.key);
    });

    test('malformed stored json is rejected rather than crashing', () {
      expect(SavedReflection.fromJson(const {}), isNull);
      expect(SavedReflection.fromJson(const {'mood': 'x'}), isNull);
      expect(
        SavedReflection.fromJson(
            const {'mood': 'x', 'surah': 'nope', 'start': 1, 'end': 1, 'at': 0}),
        isNull,
      );
    });

    test('a missing note defaults to empty rather than failing', () {
      final back = SavedReflection.fromJson(
          const {'mood': 'x', 'surah': 1, 'start': 1, 'end': 1, 'at': 0});
      expect(back, isNotNull);
      expect(back!.note, '');
    });
  });
}
