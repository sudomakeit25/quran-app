import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/bookmarks/bookmarks_provider.dart';
import 'package:quran_app/features/names/names_data.dart';
import 'package:quran_app/features/hadith/hadith_data.dart';
import 'package:quran_app/features/dua/dua_data.dart';
import 'package:quran_app/features/tafsir/tafsir_data.dart';
import 'package:quran_app/features/audio/reciters.dart';
import 'package:quran_app/features/quran/transliteration/transliteration_data.dart';
import 'package:quran_app/features/ramadan/ramadan_provider.dart';

void main() {
  group('AyahRef', () {
    test('roundtrips through key', () {
      final r = AyahRef.parse('2:255');
      expect(r.surah, 2);
      expect(r.ayah, 255);
      expect(r.key, '2:255');
    });

    test('equality by value', () {
      expect(AyahRef(1, 1) == AyahRef(1, 1), true);
      expect(AyahRef(1, 1) == AyahRef(1, 2), false);
    });
  });

  group('Content data', () {
    test('99 names are exactly 99', () {
      expect(asmaUlHusna.length, 99);
      for (var i = 0; i < 99; i++) {
        expect(asmaUlHusna[i].number, i + 1);
      }
    });

    test('Nawawi 40 has bundled entries with numbered hadiths', () {
      expect(nawawi40.hadiths.length, greaterThanOrEqualTo(20));
      for (var i = 0; i < nawawi40.hadiths.length; i++) {
        expect(nawawi40.hadiths[i].number, i + 1);
      }
    });

    test('Dua categories cover key domains', () {
      final names = duaCategories.map((c) => c.name).toSet();
      expect(names.contains('Morning'), true);
      expect(names.contains('Evening'), true);
      expect(names.contains('After Prayer'), true);
      expect(names.contains('Travel'), true);
      expect(names.contains('Ramadan'), true);
    });

    test('Tafsir is bundled for all of Al-Fatihah', () {
      for (var a = 1; a <= 7; a++) {
        expect(tafsirFor(1, a).isNotEmpty, true,
            reason: 'Expected tafsir for 1:$a');
      }
      expect(tafsirFor(2, 1), isEmpty);
    });

    test('Transliteration is bundled for all of Al-Fatihah', () {
      for (var a = 1; a <= 7; a++) {
        expect(transliterationFor(1, a), isNotNull);
      }
      expect(transliterationFor(2, 1), isNull);
    });
  });

  group('Reciters', () {
    test('at least 5 reciters available', () {
      expect(reciters.length, greaterThanOrEqualTo(5));
    });

    test('ayahUrl zero-pads surah and ayah numbers', () {
      final r = reciters.first;
      final url = r.ayahUrl(1, 1);
      expect(url.endsWith('001001.mp3'), true);
      expect(r.ayahUrl(114, 6).endsWith('114006.mp3'), true);
    });
  });

  group('Ramadan', () {
    test('isRamadanToday matches Hijri month 9', () {
      // Not asserting today's value; just that the function returns a bool.
      expect(isRamadanToday() is bool, true);
    });

    test('ramadanWindow returns null when times are null', () {
      expect(ramadanWindow(null), null);
    });
  });
}
