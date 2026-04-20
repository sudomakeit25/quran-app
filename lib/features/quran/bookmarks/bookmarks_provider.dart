import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class AyahRef {
  final int surah;
  final int ayah;
  const AyahRef(this.surah, this.ayah);

  String get key => '$surah:$ayah';

  static AyahRef parse(String key) {
    final parts = key.split(':');
    return AyahRef(int.parse(parts[0]), int.parse(parts[1]));
  }

  @override
  bool operator ==(Object other) =>
      other is AyahRef && other.surah == surah && other.ayah == ayah;

  @override
  int get hashCode => Object.hash(surah, ayah);
}

class BookmarksNotifier extends StateNotifier<List<AyahRef>> {
  final Box _box;
  BookmarksNotifier(this._box) : super(_load(_box));

  static List<AyahRef> _load(Box box) {
    final raw = box.get('list', defaultValue: const <String>[]) as List;
    return raw.cast<String>().map(AyahRef.parse).toList();
  }

  void _persist() {
    _box.put('list', state.map((r) => r.key).toList());
  }

  bool contains(AyahRef ref) => state.contains(ref);

  void toggle(AyahRef ref) {
    if (state.contains(ref)) {
      state = state.where((r) => r != ref).toList();
    } else {
      state = [...state, ref];
    }
    _persist();
  }

  void remove(AyahRef ref) {
    state = state.where((r) => r != ref).toList();
    _persist();
  }
}

final bookmarksBoxProvider = Provider<Box>((ref) => Hive.box('bookmarks'));

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<AyahRef>>((ref) {
  return BookmarksNotifier(ref.watch(bookmarksBoxProvider));
});

/// Last-read tracking: remember the most recently opened surah, and within
/// each surah, the last ayah index the user was viewing.
class LastReadNotifier extends StateNotifier<AyahRef?> {
  final Box _box;
  LastReadNotifier(this._box) : super(_load(_box));

  static AyahRef? _load(Box box) {
    final surah = box.get('last_surah') as int?;
    if (surah == null) return null;
    final ayah = box.get('last_ayah_$surah', defaultValue: 1) as int;
    return AyahRef(surah, ayah);
  }

  void update(int surah, int ayah) {
    _box.put('last_surah', surah);
    _box.put('last_ayah_$surah', ayah);
    state = AyahRef(surah, ayah);
  }

  int ayahForSurah(int surah) {
    return _box.get('last_ayah_$surah', defaultValue: 1) as int;
  }
}

final lastReadProvider =
    StateNotifierProvider<LastReadNotifier, AyahRef?>((ref) {
  return LastReadNotifier(ref.watch(bookmarksBoxProvider));
});
