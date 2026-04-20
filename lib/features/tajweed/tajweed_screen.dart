import 'package:flutter/material.dart';

class TajweedRule {
  final String name;
  final String arabic;
  final String description;
  final List<String> examples;
  final String category;
  final Color color;
  const TajweedRule({
    required this.name,
    required this.arabic,
    required this.description,
    required this.examples,
    required this.category,
    required this.color,
  });
}

const _nunRules = 'Noon Sakinah & Tanween';
const _meemRules = 'Meem Sakinah';
const _maddRules = 'Madd (Elongation)';
const _misc = 'Other Rules';

const _rules = <TajweedRule>[
  // Noon Sakinah / Tanween
  TajweedRule(
    name: 'Idhar (Clear pronunciation)',
    arabic: 'إِظْهَار',
    description:
        'Pronounce the noon sakinah (نْ) or tanween clearly, without ghunnah, before throat letters: ء ه ع ح غ خ.',
    examples: ['مِنْ هَاد', 'أَنْعَمْتَ', 'يَنْأَوْن'],
    category: _nunRules,
    color: Color(0xFF6B7280),
  ),
  TajweedRule(
    name: 'Idgham (Merging)',
    arabic: 'إِدْغَام',
    description:
        'Merge the noon sakinah or tanween into one of: ي ر م ل و ن. With ghunnah for ي و م ن (Yanmu group), without ghunnah for ل ر.',
    examples: ['مِنْ رَبِّهِمْ', 'مَنْ يَقُول', 'مِنْ وَلِيّ'],
    category: _nunRules,
    color: Color(0xFF059669),
  ),
  TajweedRule(
    name: 'Iqlab (Conversion)',
    arabic: 'إِقْلَاب',
    description:
        'Convert the noon sakinah or tanween into a hidden meem with ghunnah when followed by ب.',
    examples: ['مِنْ بَعْد', 'سَمِيعٌ بَصِير', 'أَنْبِئْهُمْ'],
    category: _nunRules,
    color: Color(0xFFDC2626),
  ),
  TajweedRule(
    name: 'Ikhfa (Concealment)',
    arabic: 'إِخْفَاء',
    description:
        'Pronounce the noon sakinah or tanween between idhar and idgham, with 2-count ghunnah, before the remaining 15 letters.',
    examples: ['أَنْتَ', 'مِنْ قَبْلِ', 'كُنْتُمْ'],
    category: _nunRules,
    color: Color(0xFF2563EB),
  ),
  // Meem Sakinah
  TajweedRule(
    name: 'Ikhfa Shafawi',
    arabic: 'إِخْفَاء شَفَوِي',
    description:
        'Hide meem sakinah with ghunnah when followed by ب (lip-to-lip concealment).',
    examples: ['تَرْمِيهِمْ بِحِجَارَة'],
    category: _meemRules,
    color: Color(0xFF2563EB),
  ),
  TajweedRule(
    name: 'Idgham Shafawi (Mithlayn)',
    arabic: 'إِدْغَام شَفَوِي',
    description:
        'Merge meem sakinah with ghunnah into a following meem (two meems meet).',
    examples: ['لَهُمْ مَا يَشَاءُون'],
    category: _meemRules,
    color: Color(0xFF059669),
  ),
  TajweedRule(
    name: 'Idhar Shafawi',
    arabic: 'إِظْهَار شَفَوِي',
    description:
        'Pronounce meem sakinah clearly before any letter except م and ب, with no ghunnah.',
    examples: ['لَعَلَّكُمْ تُفْلِحُون'],
    category: _meemRules,
    color: Color(0xFF6B7280),
  ),
  // Madd
  TajweedRule(
    name: 'Madd Tabi\'i (Natural)',
    arabic: 'مَدّ طَبِيعِي',
    description:
        'Natural elongation of 2 counts when a madd letter (ا و ي) is not followed by hamzah or sukoon.',
    examples: ['قَال', 'يَقُول', 'قِيل'],
    category: _maddRules,
    color: Color(0xFFEAB308),
  ),
  TajweedRule(
    name: 'Madd Muttasil (Connected)',
    arabic: 'مَدّ مُتَّصِل',
    description:
        'Obligatory 4 or 5 count elongation when a madd letter is followed by a hamzah in the same word.',
    examples: ['جَاءَ', 'السَّمَاء', 'سُوءٌ'],
    category: _maddRules,
    color: Color(0xFFEF4444),
  ),
  TajweedRule(
    name: 'Madd Munfasil (Separated)',
    arabic: 'مَدّ مُنْفَصِل',
    description:
        'Permissible 4 or 5 count elongation when a madd letter at the end of one word is followed by hamzah at the start of the next.',
    examples: ['فِي أَنْفُسِكُمْ', 'بِمَا أُنْزِلَ'],
    category: _maddRules,
    color: Color(0xFFF59E0B),
  ),
  TajweedRule(
    name: 'Madd Lazim (Necessary)',
    arabic: 'مَدّ لَازِم',
    description:
        'Obligatory 6 count elongation when a madd letter is followed by sukoon or a shaddah.',
    examples: ['الْحَاقَّة', 'ءَآلْآن'],
    category: _maddRules,
    color: Color(0xFFDC2626),
  ),
  TajweedRule(
    name: 'Madd Arid Lis-Sukoon',
    arabic: 'مَدّ عَارِض لِلسُّكُون',
    description:
        'When stopping on a word ending in madd followed by the letter whose vowel you drop — elongate 2, 4, or 6 counts.',
    examples: ['الْعَالَمِين', 'الرَّحِيم'],
    category: _maddRules,
    color: Color(0xFFF59E0B),
  ),
  // Misc
  TajweedRule(
    name: 'Qalqalah (Echo)',
    arabic: 'قَلْقَلَة',
    description:
        'A bouncing/echoing sound when the letters ق ط ب ج د are sakinah. Lesser when in the middle of a word, greater when stopping.',
    examples: ['أَحَدٌ', 'يَخْرُجُ', 'الْفَلَقِ'],
    category: _misc,
    color: Color(0xFF7C3AED),
  ),
  TajweedRule(
    name: 'Ghunnah',
    arabic: 'غُنَّة',
    description:
        'A 2-count nasal sound made on م and ن when they have shaddah (مّ، نّ).',
    examples: ['ثُمَّ', 'إِنَّ', 'جَنَّة'],
    category: _misc,
    color: Color(0xFF0891B2),
  ),
  TajweedRule(
    name: 'Lam Shamsiyyah & Qamariyyah',
    arabic: 'اللَّام الشَّمْسِيَّة وَالْقَمَرِيَّة',
    description:
        'Lam of ال is silent (merged) before "sun letters" (ت ث د ذ ر ز س ش ص ض ط ظ ل ن), pronounced before "moon letters" (all others).',
    examples: ['الشَّمْس (sun)', 'الْقَمَر (moon)'],
    category: _misc,
    color: Color(0xFF6366F1),
  ),
];

class TajweedScreen extends StatelessWidget {
  const TajweedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<TajweedRule>>{};
    for (final r in _rules) {
      grouped.putIfAbsent(r.category, () => []).add(r);
    }
    final categories = grouped.keys.toList();

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Learn Tajweed'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [for (final c in categories) Tab(text: c)],
          ),
        ),
        body: TabBarView(
          children: [
            for (final c in categories)
              ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: grouped[c]!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _RuleCard(rule: grouped[c]![i]),
              ),
          ],
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final TajweedRule rule;
  const _RuleCard({required this.rule});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Container(
          width: 12,
          height: 40,
          decoration: BoxDecoration(
            color: rule.color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(rule.name)),
            Text(rule.arabic,
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
                Text(rule.description),
                const SizedBox(height: 12),
                Text('Examples:',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final ex in rule.examples)
                      Chip(
                        backgroundColor: rule.color.withValues(alpha: 0.1),
                        side: BorderSide(color: rule.color),
                        label: Text(ex,
                            style: TextStyle(
                                fontFamily: 'UthmanicHafs',
                                fontSize: 18,
                                color: rule.color)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
