import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'reflect_data.dart';
import 'reflect_journal.dart';
import 'reflect_providers.dart';

class ReflectJournalScreen extends ConsumerWidget {
  const ReflectJournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(reflectJournalProvider);
    final textsAsync = ref.watch(reflectTextsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your journal')),
      body: textsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (texts) {
          if (entries.isEmpty) {
            return const _EmptyJournal();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) =>
                _JournalCard(entry: entries[i], texts: texts),
          );
        },
      ),
    );
  }
}

class _JournalCard extends ConsumerWidget {
  final SavedReflection entry;
  final ReflectTexts texts;
  const _JournalCard({required this.entry, required this.texts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = moodById(entry.moodId);
    final verse = ReflectVerse(
      surah: entry.surah,
      startAyah: entry.startAyah,
      endAyah: entry.endAyah,
      reflection: '',
    );
    final accent = mood?.color ?? Theme.of(context).colorScheme.primary;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context
            .push('/quran/surah/${entry.surah}?ayah=${entry.startAyah}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (mood != null) ...[
                    Icon(mood.icon, size: 16, color: accent),
                    const SizedBox(width: 6),
                    Text(
                      mood.title,
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      DateFormat.yMMMd().format(entry.savedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline, size: 20),
                    tooltip: 'Remove from journal',
                    onPressed: () => ref
                        .read(reflectJournalProvider.notifier)
                        .remove(entry.moodId, verse),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                texts.label(verse),
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                texts.translationFor(verse),
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              if (entry.note.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(left: BorderSide(color: accent, width: 3)),
                  ),
                  child: Text(
                    entry.note,
                    style: const TextStyle(fontSize: 13, height: 1.45),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyJournal extends StatelessWidget {
  const _EmptyJournal();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Nothing saved yet',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'When an ayah in Reflect lands, save it with a note. Months later '
              'this is where you see what you were carrying and what met you '
              'there.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
