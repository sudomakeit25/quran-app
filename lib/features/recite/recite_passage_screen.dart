import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/providers.dart';
import '../quran/bookmarks/bookmarks_provider.dart';
import 'arabic_compare.dart';
import 'recitation_exception.dart';
import 'recite_history.dart';
import 'recorder_controller.dart';
import 'verified_provider.dart';

/// Longest run offered by default. Reciting more than this in one take is
/// unwieldy to record and hard to review afterwards.
const _defaultSpan = 15;

enum _PassageState { idle, recording, processing }

class RecitePassageScreen extends ConsumerStatefulWidget {
  final int surahId;
  const RecitePassageScreen({super.key, required this.surahId});

  @override
  ConsumerState<RecitePassageScreen> createState() =>
      _RecitePassageScreenState();
}

class _RecitePassageScreenState extends ConsumerState<RecitePassageScreen> {
  final _recorder = RecitationRecorder();
  _PassageState _state = _PassageState.idle;
  PassageResult? _result;
  String? _error;
  int _from = 1;
  int? _to;
  bool _rangeInitialised = false;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  void _initRange(int versesCount) {
    if (_rangeInitialised) return;
    _rangeInitialised = true;
    _from = 1;
    _to = versesCount <= _defaultSpan ? versesCount : _defaultSpan;
  }

  Future<void> _start() async {
    setState(() {
      _result = null;
      _error = null;
    });
    try {
      if (!await _recorder.hasPermission()) {
        setState(() => _error =
            'Microphone permission denied. iOS Settings → Tilawa → Microphone ON.');
        return;
      }
      await _recorder.start();
      if (!mounted) return;
      setState(() => _state = _PassageState.recording);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not start recording: $e';
        _state = _PassageState.idle;
      });
    }
  }

  Future<void> _stop(List<({int ayahNumber, String text})> expected) async {
    if (_state != _PassageState.recording) return;
    setState(() => _state = _PassageState.processing);
    try {
      final transcript = await _recorder.stopAndTranscribe();
      if (!mounted) return;
      if (transcript.isEmpty) {
        setState(() {
          _state = _PassageState.idle;
          _error = 'No speech detected. Recite a bit louder and try again.';
        });
        return;
      }
      final result = comparePassage(expected, transcript);

      // A take padded with far more speech than the passage contains should not
      // silently verify ayahs, the same guard the single-ayah check applies.
      final withinScope = result.extra <= (result.totalWords / 2).ceil();
      final history = ref.read(reciteHistoryProvider.notifier);
      final verified = ref.read(verifiedProvider.notifier);
      for (final ayah in result.ayahs) {
        history.record(
          widget.surahId,
          ayah.ayahNumber,
          ayah.result.accuracy,
        );
        if (withinScope && ayah.result.accuracy >= 0.85) {
          verified.markVerified(AyahRef(widget.surahId, ayah.ayahNumber));
        }
      }

      setState(() {
        _result = result;
        _state = _PassageState.idle;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _PassageState.idle;
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
        title: const Text('Recite from memory'),
        backgroundColor: SakinahColors.indigoNight,
        foregroundColor: SakinahColors.cream,
      ),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detail) {
          final ayahs = detail.ayahs;
          if (ayahs.isEmpty) {
            return const Center(child: Text('This surah has no ayahs loaded.'));
          }
          _initRange(ayahs.length);
          final to = _to ?? ayahs.length;
          final selected = ayahs
              .where((a) => a.ayahNumber >= _from && a.ayahNumber <= to)
              .map((a) => (ayahNumber: a.ayahNumber, text: a.textArabic))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _IntroCard(
                surahName: detail.surah?.nameEnglish ?? 'Surah',
                ayahCount: selected.length,
              ),
              const SizedBox(height: 16),
              _RangePicker(
                versesCount: ayahs.length,
                from: _from,
                to: to,
                enabled: _state == _PassageState.idle,
                onChanged: (from, newTo) => setState(() {
                  _from = from;
                  _to = newTo;
                }),
              ),
              const SizedBox(height: 20),
              Center(
                child: _RecordButton(
                  state: _state,
                  onStart: _start,
                  onStop: () => _stop(selected),
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
              if (_result != null) ...[
                const SizedBox(height: 20),
                _PassageResultCard(
                  result: _result!,
                  surahId: widget.surahId,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final String surahName;
  final int ayahCount;
  const _IntroCard({required this.surahName, required this.ayahCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SakinahColors.indigoDeep, SakinahColors.indigoSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            surahName.toUpperCase(),
            style: const TextStyle(
              color: SakinahColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Recite $ayahCount ${ayahCount == 1 ? 'ayah' : 'ayahs'} in one go, '
            'without looking. You get a score for every ayah and the words you '
            'stumbled on, so you know exactly what to revisit.',
            style: const TextStyle(
              color: SakinahColors.cream,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _RangePicker extends StatelessWidget {
  final int versesCount;
  final int from;
  final int to;
  final bool enabled;
  final void Function(int from, int to) onChanged;

  const _RangePicker({
    required this.versesCount,
    required this.from,
    required this.to,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Ayahs', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        _NumberDropdown(
          value: from,
          min: 1,
          max: versesCount,
          enabled: enabled,
          onChanged: (v) => onChanged(v, v > to ? v : to),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('to'),
        ),
        _NumberDropdown(
          value: to,
          min: from,
          max: versesCount,
          enabled: enabled,
          onChanged: (v) => onChanged(from, v),
        ),
      ],
    );
  }
}

class _NumberDropdown extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _NumberDropdown({
    required this.value,
    required this.min,
    required this.max,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = [for (var i = min; i <= max; i++) i];
    final safeValue = value.clamp(min, max);
    return DropdownButton<int>(
      value: items.contains(safeValue) ? safeValue : items.first,
      onChanged: enabled ? (v) => v == null ? null : onChanged(v) : null,
      items: [
        for (final i in items)
          DropdownMenuItem(value: i, child: Text('$i')),
      ],
    );
  }
}

class _StateLabel extends StatelessWidget {
  final _PassageState state;
  const _StateLabel({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _PassageState.idle:
        return const Text(
          'Tap to record',
          style: TextStyle(color: SakinahColors.goldSoft, fontSize: 12),
        );
      case _PassageState.recording:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
            ),
            SizedBox(width: 8),
            Text('Recording… tap again when you finish',
                style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        );
      case _PassageState.processing:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: SakinahColors.goldSoft),
            ),
            SizedBox(width: 8),
            Text('Checking your recitation…',
                style: TextStyle(color: SakinahColors.goldSoft, fontSize: 13)),
          ],
        );
    }
  }
}

class _RecordButton extends StatelessWidget {
  final _PassageState state;
  final VoidCallback onStart;
  final VoidCallback onStop;
  const _RecordButton({
    required this.state,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final isRec = state == _PassageState.recording;
    final isProcessing = state == _PassageState.processing;
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
            color.withValues(alpha: 0.05),
          ]),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(isRec ? Icons.stop : Icons.mic, color: color, size: 40),
      ),
    );
  }
}

class _PassageResultCard extends StatelessWidget {
  final PassageResult result;
  final int surahId;
  const _PassageResultCard({required this.result, required this.surahId});

  Color _colorFor(double accuracy) {
    if (accuracy >= 0.85) return Colors.green;
    if (accuracy >= 0.5) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (result.accuracy * 100).round();
    final weakest = result.weakest;
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
              const Text(
                'YOUR TAKE',
                style: TextStyle(
                  color: SakinahColors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
              const Spacer(),
              Text(
                '$pct%',
                style: const TextStyle(
                  color: SakinahColors.cream,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            weakest.isEmpty
                ? 'Every ayah in this run came back solid.'
                : '${weakest.length} ${weakest.length == 1 ? 'ayah needs' : 'ayahs need'} another pass. Tap one to practise it on its own.',
            style: const TextStyle(color: SakinahColors.creamText, fontSize: 13),
          ),
          const SizedBox(height: 16),
          for (final ayah in result.ayahs)
            _AyahRow(
              ayahNumber: ayah.ayahNumber,
              result: ayah.result,
              color: _colorFor(ayah.result.accuracy),
              onTap: () => context.push('/recite/ayah/$surahId/${ayah.ayahNumber}'),
            ),
        ],
      ),
    );
  }
}

class _AyahRow extends StatelessWidget {
  final int ayahNumber;
  final CheckResult result;
  final Color color;
  final VoidCallback onTap;

  const _AyahRow({
    required this.ayahNumber,
    required this.result,
    required this.color,
    required this.onTap,
  });

  Color _wordColor(MatchQuality q) {
    switch (q) {
      case MatchQuality.exact:
        return Colors.green;
      case MatchQuality.close:
        return Colors.amber;
      case MatchQuality.missing:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (result.accuracy * 100).round();
    final stumbles =
        result.words.where((w) => w.quality != MatchQuality.exact).toList();
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 12),
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            '$ayahNumber',
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        title: Text(
          '$pct%',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          stumbles.isEmpty
              ? 'Word perfect'
              : '${stumbles.length} ${stumbles.length == 1 ? 'word' : 'words'} to review',
          style: const TextStyle(color: SakinahColors.creamText, fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.mic_none, color: SakinahColors.goldSoft),
          tooltip: 'Practise this ayah',
          onPressed: onTap,
        ),
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            textDirection: TextDirection.rtl,
            children: result.words.map((w) {
              final c = _wordColor(w.quality);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        ],
      ),
    );
  }
}
