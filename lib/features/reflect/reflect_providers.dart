import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'reflect_data.dart';

/// The Quran text behind every curated Reflect verse, read once from the
/// bundled database so Reflect and the reader never disagree about wording.
class ReflectTexts {
  final Map<String, String> _arabic;
  final Map<String, String> _translation;
  final Map<int, String> surahNames;

  const ReflectTexts({
    required Map<String, String> arabic,
    required Map<String, String> translation,
    required this.surahNames,
  })  : _arabic = arabic,
        _translation = translation;

  static String _key(int surah, int ayah) => '$surah:$ayah';

  /// "Ar-Ra'd 13:28", or "Ash-Sharh 94:5-6" for a range.
  String label(ReflectVerse verse) {
    final name = surahNames[verse.surah] ?? 'Surah ${verse.surah}';
    final range = verse.isRange
        ? '${verse.startAyah}-${verse.endAyah}'
        : '${verse.startAyah}';
    return '$name ${verse.surah}:$range';
  }

  String arabicFor(ReflectVerse verse) => verse.ayahNumbers
      .map((a) => _arabic[_key(verse.surah, a)])
      .whereType<String>()
      .join(' ');

  String translationFor(ReflectVerse verse) => verse.ayahNumbers
      .map((a) => _translation[_key(verse.surah, a)])
      .whereType<String>()
      .join(' ');
}

final reflectTextsProvider = FutureProvider<ReflectTexts>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  await repo.ensureSeeded();

  final refs = allReflectRefs();
  final ayahs = await repo.ayahsByRefs(refs);
  final translations = await repo.translationsByRefs(refs);
  final surahs = await repo.allSurahs();

  return ReflectTexts(
    arabic: {
      for (final a in ayahs)
        ReflectTexts._key(a.surahNumber, a.ayahNumber): a.textArabic,
    },
    translation: {
      for (final t in translations)
        ReflectTexts._key(t.surahNumber, t.ayahNumber): t.body,
    },
    surahNames: {for (final s in surahs) s.number: s.nameEnglish},
  );
});
