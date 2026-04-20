import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../bookmarks/bookmarks_provider.dart';

class MemorizedNotifier extends StateNotifier<Set<String>> {
  final Box _box;
  MemorizedNotifier(this._box) : super(_load(_box));

  static Set<String> _load(Box box) {
    final raw = box.get('memorized_list', defaultValue: const <String>[]) as List;
    return raw.cast<String>().toSet();
  }

  void _persist() {
    _box.put('memorized_list', state.toList());
  }

  bool isMemorized(AyahRef ref) => state.contains(ref.key);

  void toggle(AyahRef ref) {
    if (state.contains(ref.key)) {
      state = {...state}..remove(ref.key);
    } else {
      state = {...state, ref.key};
    }
    _persist();
  }
}

final memorizedProvider =
    StateNotifierProvider<MemorizedNotifier, Set<String>>((ref) {
  return MemorizedNotifier(Hive.box('bookmarks'));
});
