import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/recite/arabic_compare.dart';

void main() {
  group('normalizeArabic', () {
    test('strips fathah, dammah, kasrah, shaddah, sukun', () {
      expect(normalizeArabic('بِسْمِ ٱللَّهِ'), 'بسم الله');
    });

    test('normalizes alif variants to plain alif', () {
      expect(normalizeArabic('إِسْلَام'), 'اسلام');
      expect(normalizeArabic('آمن'), 'امن');
      expect(normalizeArabic('أحمد'), 'احمد');
    });

    test('normalizes ta marbuta to ha', () {
      expect(normalizeArabic('صلاة'), 'صلاه');
    });

    test('normalizes ya variants', () {
      expect(normalizeArabic('على'), 'علي');
    });

    test('strips tatweel', () {
      expect(normalizeArabic('اللـــه'), 'الله');
    });

    test('collapses whitespace', () {
      expect(normalizeArabic('بسم    الله'), 'بسم الله');
    });

    test('strips punctuation', () {
      expect(normalizeArabic('الحمد، لله.'), 'الحمد لله');
    });
  });

  group('compareAyah', () {
    test('perfect match = 100% accuracy, all exact', () {
      final r = compareAyah('بِسْمِ ٱللَّهِ', 'بسم الله');
      expect(r.accuracy, 1.0);
      expect(r.exact, 2);
      expect(r.close, 0);
      expect(r.missing, 0);
    });

    test('single wrong word reduces accuracy', () {
      final r = compareAyah(
        'الحمد لله رب العالمين',
        'الحمد لله رب الناس',
      );
      expect(r.exact, 3);
      expect(r.missing + r.close, 1);
    });

    test('missing word = missing quality', () {
      final r = compareAyah(
        'بسم الله الرحمن الرحيم',
        'بسم الله الرحيم',
      );
      expect(r.exact, 3);
      expect(r.missing, 1);
    });

    test('diacritics in expected are normalized before compare', () {
      final r = compareAyah('الرَّحْمَٰنِ الرَّحِيمِ', 'الرحمن الرحيم');
      expect(r.accuracy, 1.0);
    });

    test('typo within Levenshtein threshold = close match', () {
      final r = compareAyah('الرحمن', 'الرحمان');
      expect(r.close + r.exact, 1);
      expect(r.missing, 0);
    });

    test('empty spoken = all missing', () {
      final r = compareAyah('بسم الله', '');
      expect(r.exact, 0);
      expect(r.missing, 2);
      expect(r.accuracy, 0.0);
    });

    test('accuracy calculation weights close at 0.5', () {
      final r = CheckResult(
        words: [],
        exact: 2,
        close: 2,
        missing: 0,
      );
      expect(r.accuracy, 0.0);

      final r2 = compareAyah('الف باء جيم', 'الف باء ميم');
      expect(r2.words.length, 3);
      expect(r2.exact, 2);
    });
  });

  group('compareAyah ordering (regression: scoring ignored word order)', () {
    test('reciting the ayah backwards does not score as correct', () {
      final r = compareAyah(
        'الحمد لله رب العالمين',
        'العالمين رب لله الحمد',
      );
      expect(r.words.length, 4);
      expect(r.accuracy, lessThan(0.5),
          reason: 'reversed recitation must not read as a correct one');
      expect(r.isVerifiable, isFalse);
    });

    test('one spoken word cannot satisfy every repeat of that word', () {
      final r = compareAyah('الله الله الله الله', 'الله');
      expect(r.exact, 1);
      expect(r.missing, 3);
      expect(r.accuracy, 0.25);
      expect(r.isVerifiable, isFalse);
    });

    test('repeated words in a real ayah are matched positionally', () {
      // "له ما في السماوات وما في الأرض" — 'ما' and 'في' each occur twice.
      final r = compareAyah('له ما في السماوات وما في الارض', 'ما في');
      expect(r.exact, 2, reason: 'only the first ما and في are actually recited');
      expect(r.missing, 5);
    });

    test('each spoken word is consumed at most once', () {
      final r = compareAyah('قل هو الله احد', 'الله');
      expect(r.exact, 1);
      expect(r.missing, 3);
    });

    test('correct in-order recitation still scores 100%', () {
      final r = compareAyah(
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        'بسم الله الرحمن الرحيم',
      );
      expect(r.accuracy, 1.0);
      expect(r.exact, 4);
      expect(r.extra, 0);
      expect(r.isVerifiable, isTrue);
    });

    test('a word skipped mid-ayah is missing, the rest stay exact', () {
      final r = compareAyah(
        'الحمد لله رب العالمين',
        'الحمد لله العالمين',
      );
      expect(r.exact, 3);
      expect(r.missing, 1);
      expect(r.words[2].quality, MatchQuality.missing);
    });
  });

  group('extra speech', () {
    test('unmatched spoken words are counted as extra', () {
      final r = compareAyah('بسم الله', 'بسم الله الرحمن الرحيم');
      expect(r.exact, 2);
      expect(r.accuracy, 1.0);
      expect(r.extra, 2);
    });

    test('reciting far beyond the ayah blocks auto-verification', () {
      final r = compareAyah(
        'بسم الله',
        'بسم الله الرحمن الرحيم الحمد لله رب العالمين',
      );
      expect(r.accuracy, 1.0, reason: 'the ayah itself was covered');
      expect(r.isVerifiable, isFalse,
          reason: 'but far more was said than this ayah contains');
    });

    test('a little transcription noise still verifies', () {
      final r = compareAyah('بسم الله الرحمن الرحيم', 'بسم الله الرحمن الرحيم اه');
      expect(r.extra, 1);
      expect(r.isVerifiable, isTrue);
    });
  });

  group('isVerifiable gate', () {
    test('empty result is never verifiable', () {
      final r = compareAyah('', '');
      expect(r.isVerifiable, isFalse);
    });

    test('below the 85% threshold is not verifiable', () {
      final r = compareAyah('الحمد لله رب العالمين', 'الحمد لله');
      expect(r.accuracy, 0.5);
      expect(r.isVerifiable, isFalse);
    });
  });

  group('comparePassage', () {
    // Al-Fatihah 1-3. Note ayah 3 repeats the closing words of ayah 1, which is
    // exactly the case a naive matcher gets wrong.
    const fatihah = <({int ayahNumber, String text})>[
      (ayahNumber: 1, text: 'بسم الله الرحمن الرحيم'),
      (ayahNumber: 2, text: 'الحمد لله رب العالمين'),
      (ayahNumber: 3, text: 'الرحمن الرحيم'),
    ];

    test('a faultless take scores every ayah 100%', () {
      final r = comparePassage(
        fatihah,
        'بسم الله الرحمن الرحيم الحمد لله رب العالمين الرحمن الرحيم',
      );
      expect(r.accuracy, 1.0);
      expect(r.ayahs.length, 3);
      for (final a in r.ayahs) {
        expect(a.result.accuracy, 1.0, reason: 'ayah ${a.ayahNumber}');
      }
      expect(r.extra, 0);
      expect(r.weakest, isEmpty);
    });

    test('an ayah skipped mid-passage is blamed on that ayah alone', () {
      final r = comparePassage(
        fatihah,
        'بسم الله الرحمن الرحيم الرحمن الرحيم',
      );
      final byNumber = {for (final a in r.ayahs) a.ayahNumber: a.result};
      expect(byNumber[1]!.accuracy, 1.0, reason: 'ayah 1 was recited correctly');
      expect(byNumber[2]!.accuracy, 0.0, reason: 'ayah 2 was skipped entirely');
      expect(byNumber[3]!.accuracy, 1.0,
          reason: 'ayah 3 must not be shifted out by the skip above it');
      expect(r.weakest.map((a) => a.ayahNumber), [2]);
    });

    test('ayah boundaries line up with the words in each ayah', () {
      final r = comparePassage(fatihah, '');
      expect(r.ayahs.map((a) => a.result.words.length), [4, 4, 2]);
      expect(r.accuracy, 0.0);
      expect(r.missing, 10);
    });

    test('weakest is ordered worst first', () {
      final r = comparePassage(
        fatihah,
        // ayah 1 perfect, ayah 2 half, ayah 3 dropped
        'بسم الله الرحمن الرحيم الحمد لله',
      );
      final order = r.weakest.map((a) => a.ayahNumber).toList();
      expect(order.first, 3, reason: 'ayah 3 scored lowest');
      expect(order, containsAll([2, 3]));
    });

    test('speech beyond the passage is counted as extra', () {
      final r = comparePassage(
        [(ayahNumber: 1, text: 'بسم الله')],
        'بسم الله الرحمن الرحيم',
      );
      expect(r.accuracy, 1.0);
      expect(r.extra, 2);
    });

    test('an empty passage yields an empty result', () {
      final r = comparePassage(const [], 'بسم الله');
      expect(r.ayahs, isEmpty);
      expect(r.accuracy, 0.0);
      expect(r.totalWords, 0);
    });
  });
}
