import 'package:flutter/material.dart';

import 'dua_data.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: duaCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dua'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [for (final c in duaCategories) Tab(text: c.name)],
          ),
        ),
        body: TabBarView(
          children: [for (final c in duaCategories) _DuaList(category: c)],
        ),
      ),
    );
  }
}

class _DuaList extends StatelessWidget {
  final DuaCategory category;
  const _DuaList({required this.category});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: category.duas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final d = category.duas[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(d.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Text(
                  d.arabic,
                  style: const TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 22,
                      height: 1.8),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                Text(d.transliteration,
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                const SizedBox(height: 8),
                Text(d.translation),
                if (d.source != null) ...[
                  const SizedBox(height: 8),
                  Text('Source: ${d.source}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
