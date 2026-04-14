import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/database.dart';
import 'repositories/quran_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository(ref.watch(databaseProvider));
});

final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  await repo.ensureSeeded();
  return repo.allSurahs();
});

final surahDetailProvider =
    FutureProvider.family<SurahDetail, int>((ref, surahNumber) async {
  final repo = ref.watch(quranRepositoryProvider);
  await repo.ensureSeeded();
  final surah = await repo.surahByNumber(surahNumber);
  final ayahs = await repo.ayahsForSurah(surahNumber);
  final translations = await repo.translationsForSurah(surahNumber);
  return SurahDetail(surah: surah, ayahs: ayahs, translations: translations);
});

class SurahDetail {
  final Surah? surah;
  final List<Ayah> ayahs;
  final Map<int, String> translations;
  const SurahDetail({
    required this.surah,
    required this.ayahs,
    required this.translations,
  });
}
