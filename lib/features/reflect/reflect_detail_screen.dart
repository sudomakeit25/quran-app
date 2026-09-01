import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'reflect_data.dart';
import 'reflect_journal.dart';
import 'reflect_providers.dart';

class ReflectDetailScreen extends ConsumerWidget {
  final String moodId;
  const ReflectDetailScreen({super.key, required this.moodId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = moodById(moodId) ?? reflectMoods.first;
    final textsAsync = ref.watch(reflectTextsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(mood.title),
        backgroundColor: mood.color.withValues(alpha: 0.08),
      ),
      body: textsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (texts) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: mood.verses.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            if (i == 0) return _MoodHeader(mood: mood);
            final verse = mood.verses[i - 1];
            return _VerseCard(mood: mood, verse: verse, texts: texts);
          },
        ),
      ),
    );
  }
}

class _MoodHeader extends StatelessWidget {
  final ReflectMood mood;
  const _MoodHeader({required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mood.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: mood.color,
            radius: 22,
            child: Icon(mood.icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mood.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(mood.description, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseCard extends ConsumerWidget {
  final ReflectMood mood;
  final ReflectVerse verse;
  final ReflectTexts texts;

  const _VerseCard({
    required this.mood,
    required this.verse,
    required this.texts,
  });

  Future<void> _saveToJournal(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(reflectJournalProvider.notifier);
    final existing = notifier.find(mood.id, verse);
    final note = await showDialog<String>(
      context: context,
      builder: (_) => _NoteDialog(
        label: texts.label(verse),
        initial: existing?.note ?? '',
      ),
    );
    if (note == null) return;
    notifier.save(mood.id, verse, note.trim());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to your journal')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the list keeps the save icon in step with the journal.
    ref.watch(reflectJournalProvider);
    final saved = ref.read(reflectJournalProvider.notifier).isSaved(mood.id, verse);
    final translation = texts.translationFor(verse);
    final arabic = texts.arabicFor(verse);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context
            .push('/quran/surah/${verse.surah}?ayah=${verse.startAyah}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: mood.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      texts.label(verse),
                      style: TextStyle(
                        color: mood.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      size: 20,
                      color: saved ? mood.color : null,
                    ),
                    tooltip: saved ? 'Edit your note' : 'Save with a note',
                    onPressed: () => _saveToJournal(context, ref),
                  ),
                ],
              ),
              if (arabic.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  arabic,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 20,
                    height: 2,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                translation,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: mood.color, width: 3)),
                ),
                child: Text(
                  verse.reflection,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteDialog extends StatefulWidget {
  final String label;
  final String initial;
  const _NoteDialog({required this.label, required this.initial});

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.label),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anything you want to remember about today. Optional.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 4,
            minLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Your note',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
