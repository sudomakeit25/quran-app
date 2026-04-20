import 'package:flutter/material.dart';

import 'names_data.dart';

class NamesScreen extends StatelessWidget {
  const NamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('99 Names of Allah')),
      body: ListView.separated(
        itemCount: asmaUlHusna.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final n = asmaUlHusna[i];
          return ListTile(
            leading: CircleAvatar(
              radius: 18,
              child: Text('${n.number}',
                  style: const TextStyle(fontSize: 12)),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.transliteration,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(n.meaning,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  n.arabic,
                  style: const TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 24,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
