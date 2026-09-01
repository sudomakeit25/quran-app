class WordResult {
  final String expected;
  final String? spoken;
  final MatchQuality quality;
  const WordResult({required this.expected, required this.spoken, required this.quality});
}

enum MatchQuality { exact, close, missing }

class CheckResult {
  final List<WordResult> words;
  final int exact;
  final int close;
  final int missing;

  /// Spoken words that were never matched to an expected word. Transcription
  /// noise produces a few; a large count means the reciter said something other
  /// than this ayah.
  final int extra;

  double get accuracy => words.isEmpty ? 0.0 : (exact + close * 0.5) / words.length;
  int get correctCount => exact + close;

  /// Gate for auto-marking an ayah verified. Coverage alone is not enough:
  /// a reciter who reads the whole surah would cover any single ayah, so the
  /// amount of unmatched speech is bounded too.
  bool get isVerifiable =>
      words.isNotEmpty && accuracy >= 0.85 && extra <= (words.length / 2).ceil();

  const CheckResult({
    required this.words,
    required this.exact,
    required this.close,
    required this.missing,
    this.extra = 0,
  });
}

String normalizeArabic(String input) {
  var s = input;
  const diacritics = ['\u064B', '\u064C', '\u064D', '\u064E', '\u064F', '\u0650', '\u0651', '\u0652', '\u0653', '\u0670'];
  for (final d in diacritics) {
    s = s.replaceAll(d, '');
  }
  s = s.replaceAll('\u0640', '');
  s = s.replaceAll(RegExp('[\u0622\u0623\u0625\u0671]'), '\u0627');
  s = s.replaceAll('\u0629', '\u0647');
  s = s.replaceAll('\u0649', '\u064A');
  s = s.replaceAll('\u0624', '\u0648');
  s = s.replaceAll('\u0626', '\u064A');
  s = s.replaceAll(RegExp(r'[\u060C\u060D\u061B\u061F\u066A-\u066D\u06D4]'), '');
  s = s.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
  s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
  return s;
}

List<String> _words(String s) => normalizeArabic(s).split(' ').where((w) => w.isNotEmpty).toList();

int _levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final prev = List<int>.generate(b.length + 1, (i) => i);
  final curr = List<int>.filled(b.length + 1, 0);
  for (var i = 1; i <= a.length; i++) {
    curr[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      curr[j] = [
        curr[j - 1] + 1,
        prev[j] + 1,
        prev[j - 1] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }
    for (var j = 0; j <= b.length; j++) {
      prev[j] = curr[j];
    }
  }
  return prev[b.length];
}

/// One ayah's slice of a whole-passage recitation.
class PassageAyahResult {
  final int ayahNumber;
  final CheckResult result;
  const PassageAyahResult({required this.ayahNumber, required this.result});
}

/// The result of reciting several ayahs in a single take.
class PassageResult {
  final List<PassageAyahResult> ayahs;
  final int exact;
  final int close;
  final int missing;
  final int extra;

  const PassageResult({
    required this.ayahs,
    required this.exact,
    required this.close,
    required this.missing,
    required this.extra,
  });

  int get totalWords => exact + close + missing;
  double get accuracy =>
      totalWords == 0 ? 0.0 : (exact + close * 0.5) / totalWords;

  /// Ayahs that came out weakest in this take, worst first. Drives the
  /// "what should I practise next" prompt after a passage attempt.
  List<PassageAyahResult> get weakest {
    final sorted = [...ayahs]
      ..sort((a, b) => a.result.accuracy.compareTo(b.result.accuracy));
    return sorted.where((a) => a.result.accuracy < 0.85).toList();
  }
}

class _Alignment {
  final List<WordResult> words;
  final int exact;
  final int close;
  final int missing;
  final int consumedCount;
  const _Alignment({
    required this.words,
    required this.exact,
    required this.close,
    required this.missing,
    required this.consumedCount,
  });
}

/// Order-preserving alignment of spoken words onto expected words.
///
/// An expected word only matches a spoken word that falls between the words
/// already matched around it, and every spoken word is consumed at most once.
/// Recitation is a sequence, so a reordered or partially chanted attempt must
/// not score as correct.
_Alignment _align(List<String> expectedWords, List<String> spokenWords) {
  final n = expectedWords.length;
  final m = spokenWords.length;

  // Longest common subsequence over whole words.
  final dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));
  for (var i = 1; i <= n; i++) {
    for (var j = 1; j <= m; j++) {
      if (expectedWords[i - 1] == spokenWords[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
      }
    }
  }

  // Backtrack the LCS into a positional alignment: expected index -> spoken index.
  final alignment = List<int?>.filled(n, null);
  var i = n, j = m;
  while (i > 0 && j > 0) {
    if (expectedWords[i - 1] == spokenWords[j - 1]) {
      alignment[i - 1] = j - 1;
      i--;
      j--;
    } else if (dp[i - 1][j] >= dp[i][j - 1]) {
      i--;
    } else {
      j--;
    }
  }

  final consumed = <int>{};
  for (final a in alignment) {
    if (a != null) consumed.add(a);
  }

  final results = List<WordResult?>.filled(n, null);
  var exact = 0, close = 0, missing = 0;

  // Second pass, left to right: aligned words are exact; unaligned words look
  // for a near miss only in the gap between their surrounding anchors.
  var cursor = -1;
  for (var k = 0; k < n; k++) {
    final aligned = alignment[k];
    if (aligned != null) {
      results[k] = WordResult(
        expected: expectedWords[k],
        spoken: spokenWords[aligned],
        quality: MatchQuality.exact,
      );
      exact++;
      cursor = aligned;
      continue;
    }

    final word = expectedWords[k];
    var upper = m;
    for (var p = k + 1; p < n; p++) {
      final next = alignment[p];
      if (next != null) {
        upper = next;
        break;
      }
    }

    int? best;
    var bestDist = word.length + 1;
    for (var s = cursor + 1; s < upper; s++) {
      if (consumed.contains(s)) continue;
      final d = _levenshtein(word, spokenWords[s]);
      if (d < bestDist) {
        bestDist = d;
        best = s;
      }
    }

    final bestIdx = best;
    final threshold = (word.length * 0.4).ceil();
    if (bestIdx != null && bestDist <= threshold) {
      consumed.add(bestIdx);
      cursor = bestIdx;
      results[k] = WordResult(
        expected: word,
        spoken: spokenWords[bestIdx],
        quality: MatchQuality.close,
      );
      close++;
    } else {
      results[k] = WordResult(
        expected: word,
        // Surfaced as "you may have said this instead", not counted as a match.
        spoken: bestIdx == null ? null : spokenWords[bestIdx],
        quality: MatchQuality.missing,
      );
      missing++;
    }
  }

  return _Alignment(
    words: results.cast<WordResult>(),
    exact: exact,
    close: close,
    missing: missing,
    consumedCount: consumed.length,
  );
}

/// Word-by-word comparison of a recitation against a single expected ayah.
CheckResult compareAyah(String expected, String spoken) {
  final expectedWords = _words(expected);
  final spokenWords = _words(spoken);
  if (expectedWords.isEmpty) {
    return const CheckResult(words: [], exact: 0, close: 0, missing: 0);
  }

  final a = _align(expectedWords, spokenWords);
  return CheckResult(
    words: a.words,
    exact: a.exact,
    close: a.close,
    missing: a.missing,
    extra: spokenWords.length - a.consumedCount,
  );
}

/// Compares one continuous recitation against a run of ayahs.
///
/// The whole passage is aligned as a single sequence, then sliced back per
/// ayah, so a reciter who drops an ayah in the middle is scored where it
/// actually went wrong rather than having every later ayah shifted out.
PassageResult comparePassage(
  List<({int ayahNumber, String text})> expected,
  String spoken,
) {
  final spokenWords = _words(spoken);

  // Flatten every ayah into one expected sequence, remembering the boundaries.
  final flat = <String>[];
  final spans = <({int ayahNumber, int start, int end})>[];
  for (final ayah in expected) {
    final words = _words(ayah.text);
    final start = flat.length;
    flat.addAll(words);
    spans.add((ayahNumber: ayah.ayahNumber, start: start, end: flat.length));
  }

  if (flat.isEmpty) {
    return const PassageResult(
      ayahs: [],
      exact: 0,
      close: 0,
      missing: 0,
      extra: 0,
    );
  }

  final a = _align(flat, spokenWords);

  final ayahResults = <PassageAyahResult>[];
  for (final span in spans) {
    final words = a.words.sublist(span.start, span.end);
    var exact = 0, close = 0, missing = 0;
    for (final w in words) {
      switch (w.quality) {
        case MatchQuality.exact:
          exact++;
        case MatchQuality.close:
          close++;
        case MatchQuality.missing:
          missing++;
      }
    }
    ayahResults.add(PassageAyahResult(
      ayahNumber: span.ayahNumber,
      result: CheckResult(
        words: words,
        exact: exact,
        close: close,
        missing: missing,
      ),
    ));
  }

  return PassageResult(
    ayahs: ayahResults,
    exact: a.exact,
    close: a.close,
    missing: a.missing,
    extra: spokenWords.length - a.consumedCount,
  );
}
