import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/ui_settings.dart';
import '../../../data/providers.dart';
import '../../audio/ayah_audio_player.dart';
import '../../journey/journey_provider.dart';
import '../../tafsir/tafsir_sheet.dart';
import '../bookmarks/bookmarks_provider.dart';
import '../hifz/hifz_provider.dart';
import '../share/ayah_share.dart';
import '../transliteration/transliteration_data.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int surahId;
  final int? jumpToAyah;
  const ReaderScreen({super.key, required this.surahId, this.jumpToAyah});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final _scrollController = ScrollController();
  final _itemKeys = <int, GlobalKey>{};
  final _revealed = <int>{};
  bool _didInitialJump = false;
  bool _hifzMode = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeJump(int ayahNumber) {
    final key = _itemKeys[ayahNumber];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 300),
      alignment: 0.1,
    );
  }

  void _recordLastRead(int ayahNumber) {
    ref.read(lastReadProvider.notifier).update(widget.surahId, ayahNumber);
    ref.read(journeyProvider.notifier).recordAyahView(widget.surahId, ayahNumber);
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(surahDetailProvider(widget.surahId));
    final bookmarks = ref.watch(bookmarksProvider);
    final memorized = ref.watch(memorizedProvider);
    final bookmarked = {
      for (final r in bookmarks)
        if (r.surah == widget.surahId) r.ayah
    };

    return Scaffold(
      appBar: AppBar(
        title: detailAsync.maybeWhen(
          data: (d) =>
              Text(d.surah?.nameEnglish ?? 'Surah ${widget.surahId}'),
          orElse: () => Text('Surah ${widget.surahId}'),
        ),
        actions: [
          IconButton(
            icon: Icon(_hifzMode
                ? Icons.visibility_off
                : Icons.visibility_off_outlined),
            tooltip: _hifzMode ? 'Exit memorization mode' : 'Memorization mode',
            onPressed: () {
              setState(() {
                _hifzMode = !_hifzMode;
                _revealed.clear();
              });
            },
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detail) {
          if (detail.ayahs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Loading ayahs…\n\n'
                  'If this persists, close and reopen the app so the Quran can finish seeding.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!_didInitialJump) {
            _didInitialJump = true;
            final targetAyah = widget.jumpToAyah ??
                ref
                    .read(lastReadProvider.notifier)
                    .ayahForSurah(widget.surahId);
            if (targetAyah > 1) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _maybeJump(targetAyah));
            }
          }

          return NotificationListener<ScrollUpdateNotification>(
            onNotification: (_) {
              final centerY = MediaQuery.of(context).size.height / 2;
              for (final entry in _itemKeys.entries) {
                final ctx = entry.value.currentContext;
                if (ctx == null) continue;
                final box = ctx.findRenderObject() as RenderBox?;
                if (box == null || !box.attached) continue;
                final pos = box.localToGlobal(Offset.zero);
                if (pos.dy <= centerY &&
                    pos.dy + box.size.height >= centerY) {
                  _recordLastRead(entry.key);
                  break;
                }
              }
              return false;
            },
            child: ListView.separated(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: detail.ayahs.length,
              separatorBuilder: (_, __) => const Divider(height: 32),
              itemBuilder: (context, i) {
                final ayah = detail.ayahs[i];
                final translation = detail.translations[ayah.ayahNumber];
                final key =
                    _itemKeys.putIfAbsent(ayah.ayahNumber, () => GlobalKey());
                final isBookmarked = bookmarked.contains(ayah.ayahNumber);
                final ref0 = AyahRef(widget.surahId, ayah.ayahNumber);
                final isMemorized = memorized.contains(ref0.key);
                final isRevealed = _revealed.contains(ayah.ayahNumber);
                final hideArabic = _hifzMode && !isRevealed;

                return Column(
                  key: key,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isMemorized
                                  ? Colors.green.shade600
                                  : null,
                              child: Text(
                                '${ayah.ayahNumber}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isMemorized ? Colors.white : null,
                                ),
                              ),
                            ),
                            if (_hifzMode) ...[
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: Icon(
                                  isMemorized
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 16,
                                  color: isMemorized
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                label: Text(
                                  isMemorized ? 'Memorized' : 'Mark memorized',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onPressed: () => ref
                                    .read(memorizedProvider.notifier)
                                    .toggle(ref0),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_circle_outline,
                                  size: 22),
                              tooltip: 'Play recitation',
                              onPressed: () => showAyahPlayer(
                                context,
                                widget.surahId,
                                ayah.ayahNumber,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, size: 20),
                              tooltip: 'Share ayah',
                              onPressed: () => shareAyahAsImage(
                                context: context,
                                surahNumber: widget.surahId,
                                ayahNumber: ayah.ayahNumber,
                                surahName: detail.surah?.nameEnglish ??
                                    'Surah ${widget.surahId}',
                                arabic: ayah.textArabic,
                                translation: translation,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 22,
                                color: isBookmarked ? Colors.amber[700] : null,
                              ),
                              onPressed: () {
                                ref.read(bookmarksProvider.notifier).toggle(
                                      AyahRef(widget.surahId, ayah.ayahNumber),
                                    );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onLongPress: () =>
                          showTafsir(context, widget.surahId, ayah.ayahNumber),
                      onTap: hideArabic
                          ? () => setState(() =>
                              _revealed.add(ayah.ayahNumber))
                          : null,
                      child: Stack(
                        children: [
                          Text(
                            ayah.textArabic,
                            style: TextStyle(
                              fontFamily: 'UthmanicHafs',
                              fontSize:
                                  ref.watch(uiSettingsProvider).arabicFontSize,
                              height: 2,
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                          ),
                          if (hideArabic)
                            Positioned.fill(
                              child: ClipRect(
                                child: Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withValues(alpha: 0.95),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.visibility,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Tap to reveal',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (ref.watch(uiSettingsProvider).showTransliteration &&
                        !_hifzMode) ...[
                      const SizedBox(height: 8),
                      Builder(builder: (ctx) {
                        final t = transliterationFor(
                            widget.surahId, ayah.ayahNumber);
                        if (t == null) return const SizedBox.shrink();
                        return Text(
                          t,
                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(ctx).colorScheme.primary,
                              ),
                        );
                      }),
                    ],
                    if (translation != null && !_hifzMode) ...[
                      const SizedBox(height: 8),
                      Text(
                        translation,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
