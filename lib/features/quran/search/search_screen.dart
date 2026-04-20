import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers.dart';
import '../../../data/repositories/quran_repository.dart';

final _queryProvider = StateProvider<String>((_) => '');

final _resultsProvider =
    FutureProvider.autoDispose<List<SearchHit>>((ref) async {
  final q = ref.watch(_queryProvider);
  if (q.trim().length < 2) return const [];
  final repo = ref.watch(quranRepositoryProvider);
  return repo.search(q);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      ref.read(_queryProvider.notifier).state = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(_resultsProvider);
    final surahsAsync = ref.watch(surahsProvider);
    final query = ref.watch(_queryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search Quran (Arabic or translation)',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(_queryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: query.trim().length < 2
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Type at least 2 characters to search.\n\n'
                  'Searches both Arabic Uthmani text and English translation.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : resultsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (hits) => surahsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (surahs) {
                  final nameByNumber = {
                    for (final s in surahs) s.number: s.nameEnglish
                  };
                  if (hits.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No matches.'),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: hits.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final h = hits[i];
                      final name = nameByNumber[h.surahNumber] ??
                          'Surah ${h.surahNumber}';
                      return ListTile(
                        title: Text('$name ${h.surahNumber}:${h.ayahNumber}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (h.arabicSnippet != null)
                              Text(
                                h.arabicSnippet!,
                                style: const TextStyle(
                                    fontFamily: 'UthmanicHafs',
                                    fontSize: 18),
                                textDirection: TextDirection.rtl,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (h.translationSnippet != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  h.translationSnippet!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        onTap: () => context.push(
                            '/quran/surah/${h.surahNumber}?ayah=${h.ayahNumber}'),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
