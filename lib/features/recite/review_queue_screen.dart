import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/providers.dart';
import 'recite_history.dart';

class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(reviewQueueProvider);
    final surahsAsync = ref.watch(surahsProvider);
    final history = ref.watch(reciteHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Practice queue')),
      body: surahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (surahs) {
          final names = {for (final s in surahs) s.number: s.nameEnglish};
          if (history.isEmpty) {
            return const _EmptyState(
              icon: Icons.mic_none,
              title: 'Nothing to practise yet',
              body:
                  'Recite an ayah with Ayah Check and it starts tracking how you '
                  'did. The ayahs you stumble on show up here first.',
            );
          }
          if (queue.isEmpty) {
            return const _EmptyState(
              icon: Icons.check_circle_outline,
              title: 'Nothing needs review',
              body:
                  'Every ayah you have recited came back strong. They will return '
                  'here over the coming weeks so the memorisation stays fresh.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: queue.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              if (i == 0) return _QueueHeader(count: queue.length);
              final stats = queue[i - 1];
              return _QueueRow(
                stats: stats,
                surahName: names[stats.surah] ?? 'Surah ${stats.surah}',
              );
            },
          );
        },
      ),
    );
  }
}

class _QueueHeader extends StatelessWidget {
  final int count;
  const _QueueHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$count ${count == 1 ? 'ayah' : 'ayahs'} to revisit, weakest first.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  final AyahStats stats;
  final String surahName;
  const _QueueRow({required this.stats, required this.surahName});

  Color _colorFor(double accuracy) {
    if (accuracy >= 0.85) return Colors.green;
    if (accuracy >= 0.5) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (stats.lastAccuracy * 100).round();
    final color = _colorFor(stats.lastAccuracy);
    return Card(
      child: ListTile(
        onTap: () => context.push('/recite/ayah/${stats.surah}/${stats.ayah}'),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.18),
          child: Text(
            '$pct',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
        title: Text('$surahName  ·  ${stats.ayah}'),
        subtitle: Text(
          '${stats.attempts} ${stats.attempts == 1 ? 'attempt' : 'attempts'}  ·  '
          'best ${(stats.bestAccuracy * 100).round()}%  ·  '
          '${_relativeDay(stats.lastAttemptAt)}',
        ),
        trailing: const Icon(Icons.mic_none, color: SakinahColors.goldSoft),
      ),
    );
  }
}

String _relativeDay(DateTime when) {
  final days = DateTime.now().difference(when).inDays;
  if (days <= 0) return 'today';
  if (days == 1) return 'yesterday';
  if (days < 30) return '$days days ago';
  final months = days ~/ 30;
  return months == 1 ? 'a month ago' : '$months months ago';
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: SakinahColors.goldSoft),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
