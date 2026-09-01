import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../quran/bookmarks/bookmarks_provider.dart';

class VerifiedNotifier extends StateNotifier<Set<String>> {
  final Box _box;
  VerifiedNotifier(this._box) : super(_load(_box));

  static Set<String> _load(Box box) {
    final raw = box.get('verified_ayahs', defaultValue: const <String>[]) as List;
    return raw.cast<String>().toSet();
  }

  void _persist() {
    _box.put('verified_ayahs', state.toList());
  }

  bool isVerified(AyahRef ref) => state.contains(ref.key);

  void markVerified(AyahRef ref) {
    if (state.contains(ref.key)) return;
    state = {...state, ref.key};
    _persist();
  }

  void unmark(AyahRef ref) {
    if (!state.contains(ref.key)) return;
    state = {...state}..remove(ref.key);
    _persist();
  }
}

final verifiedProvider =
    StateNotifierProvider<VerifiedNotifier, Set<String>>((ref) {
  return VerifiedNotifier(Hive.box('bookmarks'));
});
