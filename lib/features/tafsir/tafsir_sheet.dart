import 'package:flutter/material.dart';

import 'tafsir_data.dart';

/// Opens the tafsir sheet for an ayah.
///
/// Callers must check [tafsirFor] first; the sheet has no empty state because
/// the entry point is only shown for ayahs that have bundled commentary.
void showTafsir(BuildContext context, int surah, int ayah) {
  final entries = tafsirFor(surah, ayah);
  if (entries.isEmpty) return;
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
        child: ListView(
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
