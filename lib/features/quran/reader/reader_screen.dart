import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/ui_settings.dart';
import '../../../data/providers.dart';
import '../../audio/ayah_audio_player.dart';
import '../../journey/journey_provider.dart';
import '../../recite/verified_provider.dart';
import '../../tafsir/tafsir_data.dart';
import '../../tafsir/tafsir_sheet.dart';
import '../bookmarks/bookmarks_provider.dart';
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
  bool _didInitialJump = false;

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
    final verified = ref.watch(verifiedProvider);
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
                final isVerified = verified.contains(ref0.key);
                // Tafsir is bundled for a subset of ayahs. Only offer it where
                // there is something to show, rather than opening an empty sheet.
                final hasTafsir =
                    tafsirFor(widget.surahId, ayah.ayahNumber).isNotEmpty;

                return Column(
                  key: key,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: isVerified
                              ? Colors.green.shade600
                              : null,
                          child: Text(
                            '${ayah.ayahNumber}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isVerified ? Colors.white : null,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasTafsir)
                              IconButton(
                                icon: const Icon(Icons.notes_outlined, size: 22),
                                tooltip: 'Tafsir',
                                onPressed: () => showTafsir(
                                    context, widget.surahId, ayah.ayahNumber),
                              ),
                            IconButton(
                              icon: const Icon(Icons.mic_outlined, size: 22),
                              tooltip: 'Ayah Check',
                              onPressed: () => context.push(
                                  '/recite/ayah/${widget.surahId}/${ayah.ayahNumber}'),
                            ),
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
                    Text(
                      ayah.textArabic,
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: ref.watch(uiSettingsProvider).arabicFontSize,
                        height: 2,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    if (ref.watch(uiSettingsProvider).showTransliteration) ...[
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
                    if (translation != null) ...[
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
