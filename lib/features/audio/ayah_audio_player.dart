import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_settings.dart';
import 'reciters.dart';

/// Small bottom-sheet-style mini player for playing an ayah recitation.
class AyahMiniPlayer extends ConsumerStatefulWidget {
  final int surah;
  final int ayah;
  const AyahMiniPlayer({super.key, required this.surah, required this.ayah});

  @override
  ConsumerState<AyahMiniPlayer> createState() => _AyahMiniPlayerState();
}

class _AyahMiniPlayerState extends ConsumerState<AyahMiniPlayer> {
  final _player = AudioPlayer();
  int _played = 0;
  int _repeatTarget = 1;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repeatTarget = ref.read(audioPrefsProvider).repeatCount;
    _start();

    _player.playerStateStream.listen((s) async {
      if (s.processingState == ProcessingState.completed) {
        _played++;
        if (_played < _repeatTarget) {
          await _player.seek(Duration.zero);
          await _player.play();
        }
      }
    });
  }

  Future<void> _start() async {
    final prefs = ref.read(audioPrefsProvider.notifier);
    final reciter = prefs.reciter;
    try {
      await _player.setUrl(reciter.ayahUrl(widget.surah, widget.ayah));
      setState(() => _loading = false);
      await _player.play();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Could not load audio. Check your connection.';
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(audioPrefsProvider);
    final reciter = ref.read(audioPrefsProvider.notifier).reciter;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Surah ${widget.surah}, Ayah ${widget.ayah}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Reciter: ${reciter.name}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: _loading ? null : () => _player.seek(Duration.zero),
              ),
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (c, s) {
                  final playing = s.data?.playing ?? false;
                  return IconButton(
                    iconSize: 48,
                    icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                    onPressed: _loading
                        ? null
                        : () {
                            if (playing) {
                              _player.pause();
                            } else {
                              _player.play();
                            }
                          },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Repeat:'),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: prefs.repeatCount.toDouble(),
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: prefs.repeatCount == 1
                      ? 'Once'
                      : '${prefs.repeatCount}x',
                  onChanged: (v) {
                    ref
                        .read(audioPrefsProvider.notifier)
                        .setRepeatCount(v.round());
                    _repeatTarget = v.round();
                  },
                ),
              ),
              Text(prefs.repeatCount == 1 ? '1x' : '${prefs.repeatCount}x'),
            ],
          ),
          if (_played > 0)
            Text('Played: $_played / $_repeatTarget',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

void showAyahPlayer(BuildContext context, int surah, int ayah) {
  showModalBottomSheet(
    context: context,
    builder: (_) => AyahMiniPlayer(surah: surah, ayah: ayah),
  );
}
