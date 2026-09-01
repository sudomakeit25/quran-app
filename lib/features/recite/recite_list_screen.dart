import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/providers.dart';
import 'recite_history.dart';
import 'verified_provider.dart';

class ReciteListScreen extends ConsumerWidget {
  const ReciteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsProvider);
    final verified = ref.watch(verifiedProvider);
    final queue = ref.watch(reviewQueueProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Ayah Check')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
                Row(
                  children: [
                    const Icon(Icons.mic, color: SakinahColors.goldSoft),
                    const SizedBox(width: 8),
                    const Text(
                      'AYAH CHECK',
                      style: TextStyle(
                        color: SakinahColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const Spacer(),
                    Text('${verified.length} verified',
                        style: const TextStyle(color: SakinahColors.creamText, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Recite an ayah and we check it word by word against the verse',
                  style: TextStyle(color: SakinahColors.cream, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              onTap: () => context.push('/recite/review'),
              leading: CircleAvatar(
                backgroundColor: queue.isEmpty
                    ? Colors.green.withValues(alpha: 0.18)
                    : Colors.amber.withValues(alpha: 0.22),
                child: Icon(
                  queue.isEmpty ? Icons.check : Icons.repeat,
                  color: queue.isEmpty ? Colors.green : Colors.amber.shade800,
                  size: 20,
                ),
              ),
              title: const Text('Practice queue'),
              subtitle: Text(
                queue.isEmpty
                    ? 'Nothing needs review right now'
                    : '${queue.length} ${queue.length == 1 ? 'ayah' : 'ayahs'} to revisit, weakest first',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 4),
          surahsAsync.when(
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
            error: (e, _) => Text('Error: $e'),
            data: (surahs) {
              return Column(
                children: surahs.map((s) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: SakinahColors.indigoDeep,
                        child: Text(
                          '${s.number}',
                          style: const TextStyle(color: SakinahColors.goldSoft, fontWeight: FontWeight.w600),
                        ),
                      ),
                      title: Text(s.nameEnglish),
                      subtitle: Text('${s.nameArabic} · ${s.versesCount} ayahs'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/recite/surah/${s.number}'),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReciteSurahScreen extends ConsumerWidget {
  final int surahId;
  const ReciteSurahScreen({super.key, required this.surahId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(surahDetailProvider(surahId));
    final verified = ref.watch(verifiedProvider);
    return Scaffold(
      appBar: AppBar(
        title: detailAsync.maybeWhen(
          data: (d) => Text(d.surah?.nameEnglish ?? 'Surah'),
          orElse: () => const Text('Surah'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_play),
            tooltip: 'Recite from memory',
            onPressed: () => context.push('/recite/passage/$surahId'),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (detail) {
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: detail.ayahs.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, i) {
              if (i == 0) {
                return Card(
                  color: SakinahColors.indigoDeep,
                  child: ListTile(
                    onTap: () => context.push('/recite/passage/$surahId'),
                    leading: const CircleAvatar(
                      backgroundColor: SakinahColors.indigoSoft,
                      child: Icon(Icons.playlist_play,
                          color: SakinahColors.goldSoft, size: 20),
                    ),
                    title: const Text('Recite from memory',
                        style: TextStyle(color: SakinahColors.cream)),
                    subtitle: const Text(
                      'Recite a run of ayahs in one take and score each one',
                      style: TextStyle(color: SakinahColors.creamText, fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right,
                        color: SakinahColors.goldSoft),
                  ),
                );
              }
              final ayah = detail.ayahs[i - 1];
              final isVerified = verified.contains('$surahId:${ayah.ayahNumber}');
              return Card(
                child: ListTile(
                  onTap: () => context.push('/recite/ayah/$surahId/${ayah.ayahNumber}'),
                  leading: CircleAvatar(
                    backgroundColor: isVerified ? Colors.green.withValues(alpha: 0.2) : SakinahColors.indigoDeep,
                    child: Text(
                      '${ayah.ayahNumber}',
                      style: TextStyle(
                        color: isVerified ? Colors.green : SakinahColors.goldSoft,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: Text(
                    ayah.textArabic,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 18, fontFamily: 'UthmanicHafs'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(detail.translations[ayah.ayahNumber] ?? '',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: isVerified
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.mic_none, color: SakinahColors.goldSoft),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
