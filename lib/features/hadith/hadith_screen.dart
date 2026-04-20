import 'package:flutter/material.dart';

import 'hadith_data.dart';

class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final collection = nawawi40;
    return Scaffold(
      appBar: AppBar(title: Text(collection.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              collection.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: collection.hadiths.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final h = collection.hadiths[i];
                return ExpansionTile(
                  leading: CircleAvatar(child: Text('${h.number}')),
                  title: Text('Hadith ${h.number}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(h.narrator),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            h.arabic,
                            style: const TextStyle(
                              fontFamily: 'UthmanicHafs',
                              fontSize: 22,
                              height: 1.9,
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 12),
                          Text(h.translation,
                              style: const TextStyle(height: 1.5)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
