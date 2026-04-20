import 'package:drift/drift.dart';

import 'database_native.dart' if (dart.library.js_interop) 'database_web.dart';

part 'database.g.dart';

@DataClassName('Surah')
class Surahs extends Table {
  IntColumn get number => integer()();
  TextColumn get nameArabic => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get nameTranslation => text()();
  TextColumn get revelationPlace => text()(); // 'meccan' or 'medinan'
  IntColumn get versesCount => integer()();

  @override
  Set<Column> get primaryKey => {number};
}

@DataClassName('Ayah')
class Ayahs extends Table {
  IntColumn get surahNumber => integer().references(Surahs, #number)();
  IntColumn get ayahNumber => integer()();
  TextColumn get textArabic => text()();
  IntColumn get juz => integer().withDefault(const Constant(1))();
  IntColumn get page => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {surahNumber, ayahNumber};
}

class AyahTranslations extends Table {
  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get language => text()();
  TextColumn get translator => text()();
  TextColumn get body => text()();

  @override
  Set<Column> get primaryKey => {surahNumber, ayahNumber, language, translator};
}

@DriftDatabase(tables: [Surahs, Ayahs, AyahTranslations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Surah>> allSurahs() => select(surahs).get();

  Future<Surah?> surahByNumber(int n) =>
      (select(surahs)..where((t) => t.number.equals(n))).getSingleOrNull();

  Future<List<Ayah>> ayahsForSurah(int surahNumber) =>
      (select(ayahs)..where((t) => t.surahNumber.equals(surahNumber))
            ..orderBy([(t) => OrderingTerm(expression: t.ayahNumber)]))
          .get();

  Future<List<AyahTranslation>> translationsFor(
    int surahNumber, {
    String language = 'en',
  }) =>
      (select(ayahTranslations)
            ..where((t) =>
                t.surahNumber.equals(surahNumber) & t.language.equals(language))
            ..orderBy([(t) => OrderingTerm(expression: t.ayahNumber)]))
          .get();

  Future<List<AyahTranslation>> searchTranslations(
    String query, {
    String language = 'en',
    int limit = 200,
  }) async {
    if (query.trim().isEmpty) return const [];
    final q = '%${query.toLowerCase().trim()}%';
    return (select(ayahTranslations)
          ..where((t) =>
              t.language.equals(language) &
              t.body.lower().like(q))
          ..orderBy([
            (t) => OrderingTerm(expression: t.surahNumber),
            (t) => OrderingTerm(expression: t.ayahNumber),
          ])
          ..limit(limit))
        .get();
  }

  Future<List<Ayah>> searchArabic(String query, {int limit = 200}) async {
    if (query.trim().isEmpty) return const [];
    final q = '%${query.trim()}%';
    return (select(ayahs)
          ..where((t) => t.textArabic.like(q))
          ..orderBy([
            (t) => OrderingTerm(expression: t.surahNumber),
            (t) => OrderingTerm(expression: t.ayahNumber),
          ])
          ..limit(limit))
        .get();
  }

  Future<bool> isEmpty() async {
    final count = await (selectOnly(surahs)..addColumns([surahs.number.count()]))
        .map((row) => row.read(surahs.number.count()) ?? 0)
        .getSingle();
    return count == 0;
  }

  Future<int> ayahCount() async {
    return (selectOnly(ayahs)..addColumns([ayahs.ayahNumber.count()]))
        .map((row) => row.read(ayahs.ayahNumber.count()) ?? 0)
        .getSingle();
  }

  Future<void> clearAll() async {
    await batch((b) {
      b.deleteWhere(ayahTranslations, (_) => const Constant(true));
      b.deleteWhere(ayahs, (_) => const Constant(true));
      b.deleteWhere(surahs, (_) => const Constant(true));
    });
  }

  Future<void> seed({
    required List<SurahSeed> surahsSeed,
    required List<AyahSeed> ayahsSeed,
    required List<TranslationSeed> translationsSeed,
  }) async {
    await batch((b) {
      b.insertAll(
        surahs,
        surahsSeed.map((s) => SurahsCompanion.insert(
              number: Value(s.number),
              nameArabic: s.nameArabic,
              nameEnglish: s.nameEnglish,
              nameTranslation: s.nameTranslation,
              revelationPlace: s.revelationPlace,
              versesCount: s.versesCount,
            )),
      );
      b.insertAll(
        ayahs,
        ayahsSeed.map((a) => AyahsCompanion.insert(
              surahNumber: a.surahNumber,
              ayahNumber: a.ayahNumber,
              textArabic: a.textArabic,
            )),
      );
      b.insertAll(
        ayahTranslations,
        translationsSeed.map((t) => AyahTranslationsCompanion.insert(
              surahNumber: t.surahNumber,
              ayahNumber: t.ayahNumber,
              language: t.language,
              translator: t.translator,
              body: t.body,
            )),
      );
    });
  }
}

class SurahSeed {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTranslation;
  final String revelationPlace;
  final int versesCount;
  const SurahSeed({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTranslation,
    required this.revelationPlace,
    required this.versesCount,
  });
}

class AyahSeed {
  final int surahNumber;
  final int ayahNumber;
  final String textArabic;
  const AyahSeed({
    required this.surahNumber,
    required this.ayahNumber,
    required this.textArabic,
  });
}

class TranslationSeed {
  final int surahNumber;
  final int ayahNumber;
  final String language;
  final String translator;
  final String body;
  const TranslationSeed({
    required this.surahNumber,
    required this.ayahNumber,
    required this.language,
    required this.translator,
    required this.body,
  });
}
