import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'reflect_data.dart';

/// A verse the user kept, with what they wrote at the time.
///
/// The mood is stored alongside it, so months later the journal shows not just
/// which ayah was saved but the state they were in when it landed.
class SavedReflection {
  final String moodId;
  final int surah;
  final int startAyah;
  final int endAyah;
  final String note;
  final DateTime savedAt;

  const SavedReflection({
    required this.moodId,
    required this.surah,
    required this.startAyah,
    required this.endAyah,
    required this.note,
    required this.savedAt,
  });

  String get key => '$moodId|$surah:$startAyah-$endAyah';

  SavedReflection withNote(String newNote) => SavedReflection(
        moodId: moodId,
        surah: surah,
        startAyah: startAyah,
        endAyah: endAyah,
        note: newNote,
        savedAt: savedAt,
      );

  Map<String, dynamic> toJson() => {
        'mood': moodId,
        'surah': surah,
        'start': startAyah,
        'end': endAyah,
        'note': note,
        'at': savedAt.millisecondsSinceEpoch,
      };

  static SavedReflection? fromJson(Map<String, dynamic> json) {
    final mood = json['mood'];
    final surah = json['surah'];
    final start = json['start'];
    final end = json['end'];
    final note = json['note'];
    final at = json['at'];
    if (mood is! String || surah is! num || start is! num) return null;
    if (end is! num || at is! num) return null;
    return SavedReflection(
      moodId: mood,
      surah: surah.toInt(),
      startAyah: start.toInt(),
      endAyah: end.toInt(),
      note: note is String ? note : '',
      savedAt: DateTime.fromMillisecondsSinceEpoch(at.toInt()),
    );
  }
}

String reflectionKey(String moodId, ReflectVerse verse) =>
    '$moodId|${verse.surah}:${verse.startAyah}-${verse.endAyah}';

class ReflectJournalNotifier extends StateNotifier<List<SavedReflection>> {
  final Box _box;
  static const _key = 'reflect_journal';

  ReflectJournalNotifier(this._box) : super(_load(_box));

  static List<SavedReflection> _load(Box box) {
    final raw = box.get(_key);
    if (raw is! String || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((e) => SavedReflection.fromJson(e.cast<String, dynamic>()))
          .whereType<SavedReflection>()
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    } catch (_) {
      return const [];
    }
  }

  void _persist() {
    _box.put(_key, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  bool isSaved(String moodId, ReflectVerse verse) {
    final key = reflectionKey(moodId, verse);
    return state.any((e) => e.key == key);
  }

  SavedReflection? find(String moodId, ReflectVerse verse) {
    final key = reflectionKey(moodId, verse);
    for (final e in state) {
      if (e.key == key) return e;
    }
    return null;
  }

  /// Saves the verse, or updates the note if it is already in the journal.
  void save(String moodId, ReflectVerse verse, String note) {
    final key = reflectionKey(moodId, verse);
    final existing = state.indexWhere((e) => e.key == key);
    if (existing >= 0) {
      final updated = [...state];
      updated[existing] = state[existing].withNote(note);
      state = updated;
    } else {
      state = [
        SavedReflection(
          moodId: moodId,
          surah: verse.surah,
          startAyah: verse.startAyah,
          endAyah: verse.endAyah,
          note: note,
          savedAt: DateTime.now(),
        ),
        ...state,
      ];
    }
    _persist();
  }

  void remove(String moodId, ReflectVerse verse) {
    final key = reflectionKey(moodId, verse);
    state = state.where((e) => e.key != key).toList();
    _persist();
  }
}

final reflectJournalProvider =
    StateNotifierProvider<ReflectJournalNotifier, List<SavedReflection>>((ref) {
  return ReflectJournalNotifier(Hive.box('bookmarks'));
});
