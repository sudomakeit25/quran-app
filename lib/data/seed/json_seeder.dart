import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../database/database.dart';

class QuranJsonSeeder {
  static Future<({List<AyahSeed> ayahs, List<TranslationSeed> translations})>
      load() async {
    final arabicJson = jsonDecode(
      await rootBundle.loadString('assets/quran/quran-uthmani.json'),
    );
    final englishJson = jsonDecode(
      await rootBundle.loadString('assets/quran/quran-en-saheeh.json'),
    );

    final ayahs = <AyahSeed>[];
    final translations = <TranslationSeed>[];

    final arabicSurahs = arabicJson['data']['surahs'] as List;
    for (final s in arabicSurahs) {
      final surahNumber = s['number'] as int;
      for (final a in (s['ayahs'] as List)) {
        ayahs.add(AyahSeed(
          surahNumber: surahNumber,
          ayahNumber: a['numberInSurah'] as int,
          textArabic: (a['text'] as String).trim(),
        ));
      }
    }

    final englishSurahs = englishJson['data']['surahs'] as List;
    for (final s in englishSurahs) {
      final surahNumber = s['number'] as int;
      for (final a in (s['ayahs'] as List)) {
        translations.add(TranslationSeed(
          surahNumber: surahNumber,
          ayahNumber: a['numberInSurah'] as int,
          language: 'en',
          translator: 'Saheeh International',
          body: (a['text'] as String).trim(),
        ));
      }
    }

    return (ayahs: ayahs, translations: translations);
  }
}
