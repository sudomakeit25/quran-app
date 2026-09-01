import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/providers.dart';
import '../quran/bookmarks/bookmarks_provider.dart';
import 'arabic_compare.dart';
import 'recitation_exception.dart';
import 'recite_history.dart';
import 'recorder_controller.dart';
import 'verified_provider.dart';

class AyahCheckScreen extends ConsumerStatefulWidget {
  final int surahId;
  final int ayahNumber;
  const AyahCheckScreen({super.key, required this.surahId, required this.ayahNumber});

  @override
  ConsumerState<AyahCheckScreen> createState() => _AyahCheckScreenState();
}

enum _RecordingState { idle, recording, processing }

class _AyahCheckScreenState extends ConsumerState<AyahCheckScreen> {
  final _recorder = RecitationRecorder();
  _RecordingState _state = _RecordingState.idle;
  String? _transcript;
  CheckResult? _result;
  String? _error;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      setState(() {
        _transcript = null;
        _result = null;
        _error = null;
      });
      if (!await _recorder.hasPermission()) {
        setState(() => _error = 'Microphone permission denied. iOS Settings → Tilawa → Microphone ON.');
        return;
      }
      await _recorder.start();
      if (!mounted) return;
      setState(() => _state = _RecordingState.recording);
    } catch (e) {
      setState(() {
        _error = 'Could not start recording: $e';
        _state = _RecordingState.idle;
      });
    }
  }

  Future<void> _stop(String expected) async {
    if (_state != _RecordingState.recording) return;
    setState(() => _state = _RecordingState.processing);
    try {
      final transcript = await _recorder.stopAndTranscribe();
      if (!mounted) return;
      if (transcript.isEmpty) {
        setState(() {
          _state = _RecordingState.idle;
          _error = 'No speech detected. Recite a bit louder and try again.';
        });
        return;
      }
      final result = compareAyah(expected, transcript);
      if (!mounted) return;
      setState(() {
        _transcript = transcript;
        _result = result;
        _state = _RecordingState.idle;
      });
      // Every attempt feeds the review queue, not just the passing ones.
      ref.read(reciteHistoryProvider.notifier).record(
            widget.surahId,
            widget.ayahNumber,
            result.accuracy,
          );
      if (result.isVerifiable) {
        final ayahRef = AyahRef(widget.surahId, widget.ayahNumber);
        ref.read(verifiedProvider.notifier).markVerified(ayahRef);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _RecordingState.idle;
        _error = e is RecitationException
            ? e.message
            : 'Could not check your recitation. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncDetail = ref.watch(surahDetailProvider(widget.surahId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayah Check'),
        backgroundColor: SakinahColors.indigoNight,
        foregroundColor: SakinahColors.cream,
      ),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detail) {
          final ayah = detail.ayahs.firstWhere(
            (a) => a.ayahNumber == widget.ayahNumber,
            orElse: () => detail.ayahs.first,
          );
          final translation = detail.translations[ayah.ayahNumber];
          final isVerified = ref.watch(verifiedProvider).contains(
              AyahRef(widget.surahId, widget.ayahNumber).key);
          final stats = ref.watch(reciteHistoryProvider)[
              '${widget.surahId}:${widget.ayahNumber}'];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AyahCard(
                surahName: detail.surah?.nameEnglish ?? 'Surah',
                ayahNumber: widget.ayahNumber,
                arabic: ayah.textArabic,
                translation: translation,
                isVerified: isVerified,
              ),
              if (stats != null) ...[
                const SizedBox(height: 10),
                _HistoryLine(stats: stats),
              ],
              const SizedBox(height: 18),
              const _InstructionCard(),
              const SizedBox(height: 20),
              Center(
                child: _RecordButton(
                  state: _state,
                  onStart: _start,
                  onStop: () => _stop(ayah.textArabic),
                ),
              ),
              const SizedBox(height: 14),
              Center(child: _StateLabel(state: _state)),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                  ),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              ],
              if (_transcript != null) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: SakinahColors.indigoDeep,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('YOU SAID',
                          style: TextStyle(
                              color: SakinahColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2)),
                      const SizedBox(height: 8),
                      Text(
                        _transcript!,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: SakinahColors.cream,
                          fontSize: 16,
                          fontFamily: 'UthmanicHafs',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_result != null) ...[
                const SizedBox(height: 18),
                _ResultCard(result: _result!),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StateLabel extends StatelessWidget {
  final _RecordingState state;
  const _StateLabel({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _RecordingState.idle:
        return const Text(
          'Tap to record',
          style: TextStyle(color: SakinahColors.goldSoft, fontSize: 12),
        );
      case _RecordingState.recording:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.red)),
            SizedBox(width: 8),
            Text('Recording… tap again to stop',
                style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        );
      case _RecordingState.processing:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: SakinahColors.goldSoft)),
            SizedBox(width: 8),
            Text('Checking your recitation…',
                style:
                    TextStyle(color: SakinahColors.goldSoft, fontSize: 13)),
          ],
        );
    }
  }
}

class _AyahCard extends StatelessWidget {
  final String surahName;
  final int ayahNumber;
  final String arabic;
  final String? translation;
  final bool isVerified;
  const _AyahCard({
    required this.surahName,
    required this.ayahNumber,
    required this.arabic,
    required this.translation,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SakinahColors.indigoDeep,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$surahName : $ayahNumber',
                style: const TextStyle(
                    color: SakinahColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2),
              ),
              const Spacer(),
              if (isVerified)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.green.withValues(alpha: 0.6)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 14),
                      SizedBox(width: 4),
                      Text('Verified',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: SakinahColors.cream,
              fontSize: 26,
              fontFamily: 'UthmanicHafs',
              height: 2,
            ),
          ),
          if (translation != null) ...[
            const SizedBox(height: 12),
            Text(
              translation!,
              style: TextStyle(
                  color: SakinahColors.creamText.withValues(alpha: 0.85),
                  fontSize: 13,
                  height: 1.5,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SakinahColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.3)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: SakinahColors.goldSoft, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tap the mic, recite the ayah, tap again to stop. We send the recording to a secure transcription service and compare your words to the verse. Audio is deleted after.',
              style: TextStyle(
                  color: SakinahColors.creamText,
                  fontSize: 12.5,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  final _RecordingState state;
  final VoidCallback onStart;
  final VoidCallback onStop;
  const _RecordButton({
    required this.state,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final isRec = state == _RecordingState.recording;
    final isProcessing = state == _RecordingState.processing;
    final color = isRec ? Colors.red : SakinahColors.gold;
    return GestureDetector(
      onTap: isProcessing ? null : (isRec ? onStop : onStart),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            color.withValues(alpha: 0.4),
            color.withValues(alpha: 0.05)
          ]),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(
          isRec ? Icons.stop : Icons.mic,
          color: color,
          size: 40,
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final CheckResult result;
  const _ResultCard({required this.result});

  Color _colorFor(MatchQuality q) {
    switch (q) {
      case MatchQuality.exact:
        return Colors.green;
      case MatchQuality.close:
        return Colors.amber;
      case MatchQuality.missing:
        return Colors.red;
    }
  }

  String _summary() {
    final pct = (result.accuracy * 100).round();
    if (pct >= 95) return 'Masha\'Allah, excellent recitation';
    if (pct >= 85) return 'Great job, very close to perfect';
    if (pct >= 60) return 'Good attempt, review the highlighted words';
    if (result.exact == 0 && result.close == 0) {
      return 'That did not match this ayah. Check you are on the right verse.';
    }
    return 'Keep practicing, check the word-by-word feedback';
  }

  @override
  Widget build(BuildContext context) {
    final pct = (result.accuracy * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SakinahColors.indigoDeep,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('RESULT',
                  style: TextStyle(
                      color: SakinahColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5)),
              const Spacer(),
              Text('$pct%',
                  style: const TextStyle(
                      color: SakinahColors.cream,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(_summary(),
              style: const TextStyle(
                  color: SakinahColors.creamText, fontSize: 13)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            textDirection: TextDirection.rtl,
            children: result.words.map((w) {
              final c = _colorFor(w.quality);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: c.withValues(alpha: 0.7)),
                ),
                child: Text(
                  w.expected,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: SakinahColors.cream,
                    fontSize: 16,
                    fontFamily: 'UthmanicHafs',
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Stat(label: 'CORRECT', value: result.exact, color: Colors.green),
              const SizedBox(width: 14),
              _Stat(label: 'CLOSE', value: result.close, color: Colors.amber),
              const SizedBox(width: 14),
              _Stat(label: 'MISSED', value: result.missing, color: Colors.red),
              if (result.extra > 0) ...[
                const SizedBox(width: 14),
                _Stat(
                    label: 'EXTRA',
                    value: result.extra,
                    color: SakinahColors.goldSoft),
              ],
            ],
          ),
          if (result.extra > (result.words.length / 2).ceil()) ...[
            const SizedBox(height: 10),
            Text(
              'You recited more than this ayah, so it was not marked verified. '
              'Record just this ayah on its own to verify it.',
              style: TextStyle(
                color: SakinahColors.creamText.withValues(alpha: 0.8),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Stat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value',
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.w700)),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5)),
      ],
    );
  }
}

class _HistoryLine extends StatelessWidget {
  final AyahStats stats;
  const _HistoryLine({required this.stats});

  @override
  Widget build(BuildContext context) {
    final attempts = stats.attempts;
    final best = (stats.bestAccuracy * 100).round();
    final last = (stats.lastAccuracy * 100).round();
    return Row(
      children: [
        const Icon(Icons.history, size: 15, color: SakinahColors.goldSoft),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$attempts ${attempts == 1 ? 'attempt' : 'attempts'}  ·  last $last%  ·  best $best%',
            style: const TextStyle(
              color: SakinahColors.goldSoft,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
