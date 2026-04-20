import '../database/database.dart';
import '../seed/json_seeder.dart';
import '../seed/surahs_seed.dart';

class QuranRepository {
  final AppDatabase _db;
  QuranRepository(this._db);

  // Total ayah count in the Quran across all 114 surahs. Used to detect
  // installs that were seeded from the old (Al-Fatihah-only) sample data.
  static const _expectedAyahCount = 6236;

  Future<void> ensureSeeded() async {
    final existingCount = await _db.ayahCount();
    if (existingCount >= _expectedAyahCount - 10) return;
    // Either empty or incomplete seed — wipe and re-seed from bundled JSON.
    if (existingCount > 0) await _db.clearAll();
    final loaded = await QuranJsonSeeder.load();
    await _db.seed(
      surahsSeed: surahsSeed,
      ayahsSeed: loaded.ayahs,
      translationsSeed: loaded.translations,
    );
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

  Future<List<SearchHit>> search(String query) async {
    final translationHits = await _db.searchTranslations(query);
    final arabicHits = await _db.searchArabic(query);
    final results = <String, SearchHit>{};
    for (final t in translationHits) {
      final key = '${t.surahNumber}:${t.ayahNumber}';
      results[key] = SearchHit(
        surahNumber: t.surahNumber,
        ayahNumber: t.ayahNumber,
        translationSnippet: t.body,
      );
    }
    for (final a in arabicHits) {
      final key = '${a.surahNumber}:${a.ayahNumber}';
      final existing = results[key];
      results[key] = SearchHit(
        surahNumber: a.surahNumber,
        ayahNumber: a.ayahNumber,
        translationSnippet: existing?.translationSnippet,
        arabicSnippet: a.textArabic,
      );
    }
    return results.values.toList()
      ..sort((a, b) {
        final c = a.surahNumber.compareTo(b.surahNumber);
        return c != 0 ? c : a.ayahNumber.compareTo(b.ayahNumber);
      });
  }
}

class SearchHit {
  final int surahNumber;
  final int ayahNumber;
  final String? translationSnippet;
  final String? arabicSnippet;
  const SearchHit({
    required this.surahNumber,
    required this.ayahNumber,
    this.translationSnippet,
    this.arabicSnippet,
  });
}
