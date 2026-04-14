import 'package:flutter/material.dart';

class TajweedRule {
  final String name;
  final String arabic;
  final String description;
  final List<String> examples;
  const TajweedRule({
    required this.name,
    required this.arabic,
    required this.description,
    required this.examples,
  });
}

const _rules = <TajweedRule>[
  TajweedRule(
    name: 'Idgham (Merging)',
    arabic: 'إِدْغَام',
    description:
        'Merging the noon sakinah or tanween into one of the letters: ي ر م ل و ن.',
    examples: ['مِنْ رَبِّهِمْ', 'مَنْ يَقُول'],
  ),
  TajweedRule(
    name: 'Ikhfa (Concealment)',
    arabic: 'إِخْفَاء',
    description:
        'Pronouncing the noon sakinah or tanween between idhar and idgham, with ghunnah, before 15 letters.',
    examples: ['أَنْتَ', 'مِنْ قَبْلِ'],
  ),
  TajweedRule(
    name: 'Iqlab (Conversion)',
    arabic: 'إِقْلَاب',
    description:
        'Converting the noon sakinah or tanween into a meem when followed by the letter ب.',
    examples: ['مِنْ بَعْد', 'سَمِيعٌ بَصِير'],
  ),
  TajweedRule(
    name: 'Idhar (Clear pronunciation)',
    arabic: 'إِظْهَار',
    description:
        'Clearly pronouncing the noon sakinah or tanween before the throat letters: ء ه ع ح غ خ.',
    examples: ['مِنْ هَاد', 'أَنْعَمْتَ'],
  ),
  TajweedRule(
    name: 'Qalqalah (Echo)',
    arabic: 'قَلْقَلَة',
    description:
        'A bouncing sound when stopping on one of the letters: ق ط ب ج د.',
    examples: ['أَحَدٌ', 'يَخْرُجُ'],
  ),
  TajweedRule(
    name: 'Madd (Elongation)',
    arabic: 'مَدّ',
    description:
        'Elongating a vowel sound for two, four, or six counts depending on context.',
    examples: ['ٱلرَّحْمَٰن', 'يَا أَيُّهَا'],
  ),
];

class TajweedScreen extends StatelessWidget {
  const TajweedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn Tajweed')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _rules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final r = _rules[i];
          return Card(
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.name),
                  Text(r.arabic,
                      style: const TextStyle(
                          fontFamily: 'UthmanicHafs', fontSize: 18)),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(r.description),
                      const SizedBox(height: 12),
                      Text('Examples:',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final ex in r.examples)
                            Chip(
                              label: Text(ex,
                                  style: const TextStyle(
                                      fontFamily: 'UthmanicHafs',
                                      fontSize: 18)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
