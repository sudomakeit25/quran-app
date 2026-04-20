import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'reciters.dart';

class AudioPrefs {
  final String reciterId;
  final int repeatCount;
  const AudioPrefs({required this.reciterId, required this.repeatCount});

  AudioPrefs copyWith({String? reciterId, int? repeatCount}) => AudioPrefs(
        reciterId: reciterId ?? this.reciterId,
        repeatCount: repeatCount ?? this.repeatCount,
      );
}

class AudioPrefsNotifier extends StateNotifier<AudioPrefs> {
  final Box _box;
  AudioPrefsNotifier(this._box) : super(_load(_box));

  static AudioPrefs _load(Box box) => AudioPrefs(
        reciterId: box.get('reciter_id', defaultValue: 'afasy') as String,
        repeatCount: box.get('repeat_count', defaultValue: 1) as int,
      );

  void setReciter(String id) {
    state = state.copyWith(reciterId: id);
    _box.put('reciter_id', id);
  }

  void setRepeatCount(int n) {
    state = state.copyWith(repeatCount: n);
    _box.put('repeat_count', n);
  }

  Reciter get reciter =>
      reciters.firstWhere((r) => r.id == state.reciterId, orElse: () => reciters.first);
}

final audioPrefsProvider =
    StateNotifierProvider<AudioPrefsNotifier, AudioPrefs>((ref) {
  return AudioPrefsNotifier(Hive.box('settings'));
});
