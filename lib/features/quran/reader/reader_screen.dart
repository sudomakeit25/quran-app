import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';

class ReaderScreen extends ConsumerWidget {
  final int surahId;
  const ReaderScreen({super.key, required this.surahId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(surahDetailProvider(surahId));
    return Scaffold(
      appBar: AppBar(
        title: detailAsync.maybeWhen(
          data: (d) => Text(d.surah?.nameEnglish ?? 'Surah $surahId'),
          orElse: () => Text('Surah $surahId'),
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
                  'No ayah text loaded for this surah yet.\n\n'
                  'Bundled sample only includes Al-Fatihah (Surah 1).\n'
                  'Add full data from tanzil.net to populate the rest.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: detail.ayahs.length,
            separatorBuilder: (_, __) => const Divider(height: 32),
            itemBuilder: (context, i) {
              final ayah = detail.ayahs[i];
              final translation = detail.translations[ayah.ayahNumber];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        child: Text(
                          '${ayah.ayahNumber}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const Icon(Icons.bookmark_border, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ayah.textArabic,
                    style: const TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 26,
                      height: 2,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
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
          );
        },
      ),
    );
  }
}
