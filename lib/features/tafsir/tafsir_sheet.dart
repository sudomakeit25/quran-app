import 'package:flutter/material.dart';

import 'tafsir_data.dart';

void showTafsir(BuildContext context, int surah, int ayah) {
  final entries = tafsirFor(surah, ayah);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(16),
        child: entries.isEmpty
            ? _emptyState(context, surah, ayah)
            : ListView(
                controller: controller,
                children: [
                  Text(
                    'Tafsir  ·  $surah:$ayah',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  for (final e in entries) ...[
                    Text(
                      e.source,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(e.text, style: const TextStyle(height: 1.5)),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
      ),
    ),
  );
}

Widget _emptyState(BuildContext context, int surah, int ayah) {
  return ListView(
    children: [
      Text('Tafsir  ·  $surah:$ayah',
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      const Text(
        'No tafsir bundled for this ayah yet.\n\n'
        'Tafsir is currently available for Al-Fatihah (Surah 1). '
        'To view tafsir for other ayahs, connect to the internet and '
        'reference tanzil.net or quran.com.',
      ),
    ],
  );
}
