import '../database/database.dart';
import '../seed/json_seeder.dart';
import '../seed/surahs_seed.dart';

class QuranRepository {
  final AppDatabase _db;
  QuranRepository(this._db);

  Future<void> ensureSeeded() async {
    if (await _db.isEmpty()) {
      final loaded = await QuranJsonSeeder.load();
      await _db.seed(
        surahsSeed: surahsSeed,
        ayahsSeed: loaded.ayahs,
        translationsSeed: loaded.translations,
      );
    }
  }

  Future<List<Surah>> allSurahs() => _db.allSurahs();

  Future<Surah?> surahByNumber(int n) => _db.surahByNumber(n);

  Future<List<Ayah>> ayahsForSurah(int n) => _db.ayahsForSurah(n);

  Future<Map<int, String>> translationsForSurah(
    int n, {
    String language = 'en',
  }) async {
    final rows = await _db.translationsFor(n, language: language);
    return {for (final r in rows) r.ayahNumber: r.body};
  }
}
