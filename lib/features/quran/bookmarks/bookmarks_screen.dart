import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';
import 'bookmarks_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider);
    final surahsAsync = ref.watch(surahsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarks.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No bookmarks yet.\n\nTap the bookmark icon next to any ayah in the reader to save it here.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : surahsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (surahs) {
                final nameByNumber = {
                  for (final s in surahs) s.number: s.nameEnglish,
                };
                return ListView.separated(
                  itemCount: bookmarks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = bookmarks[i];
                    final name =
                        nameByNumber[r.surah] ?? 'Surah ${r.surah}';
                    return Dismissible(
                      key: ValueKey(r.key),
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) =>
                          ref.read(bookmarksProvider.notifier).remove(r),
                      child: ListTile(
                        leading: const Icon(Icons.bookmark),
                        title: Text('$name, Ayah ${r.ayah}'),
                        subtitle: Text('Surah ${r.surah}:${r.ayah}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push('/quran/surah/${r.surah}?ayah=${r.ayah}'),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
