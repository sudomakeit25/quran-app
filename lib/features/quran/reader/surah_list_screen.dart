import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';

class SurahListScreen extends ConsumerWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Quran')),
      body: surahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (surahs) => ListView.separated(
          itemCount: surahs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final s = surahs[i];
            return ListTile(
              leading: CircleAvatar(child: Text('${s.number}')),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.nameEnglish),
                  Text(
                    s.nameArabic,
                    style: const TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                '${s.nameTranslation} • ${s.versesCount} verses • ${s.revelationPlace}',
              ),
              onTap: () => context.push('/quran/surah/${s.number}'),
            );
          },
        ),
      ),
    );
  }
}
