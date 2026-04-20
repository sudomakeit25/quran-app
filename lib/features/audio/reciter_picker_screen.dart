import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_settings.dart';
import 'reciters.dart';

class ReciterPickerScreen extends ConsumerWidget {
  const ReciterPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(audioPrefsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Reciter')),
      body: ListView.separated(
        itemCount: reciters.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final r = reciters[i];
          final selected = r.id == prefs.reciterId;
          return ListTile(
            leading: Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : null),
            title: Text(r.name),
            subtitle: Text(r.language),
            onTap: () => ref.read(audioPrefsProvider.notifier).setReciter(r.id),
          );
        },
      ),
    );
  }
}
