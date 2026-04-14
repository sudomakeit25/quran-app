import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Topic {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String? route;
  const _Topic(this.icon, this.color, this.title, this.description, [this.route]);
}

const _topics = <_Topic>[
  _Topic(Icons.menu_book, Color(0xFFF59E0B), 'Quran Reading',
      'Read the Quran with Arabic and translation.', '/quran'),
  _Topic(Icons.record_voice_over, Color(0xFFEAB308), 'Tajweed',
      'Rules of recitation: Idgham, Ikhfa, Qalqalah, and more.', '/tajweed'),
  _Topic(Icons.psychology, Color(0xFF8B5CF6), 'Tafsir',
      'Interpretation of the Quran by classical scholars.'),
  _Topic(Icons.history_edu, Color(0xFF14B8A6), 'Hadith',
      'Sayings and actions of Prophet Muhammad ﷺ.'),
  _Topic(Icons.balance, Color(0xFF10B981), 'Fiqh',
      'Islamic jurisprudence and rulings.'),
  _Topic(Icons.timeline, Color(0xFF3B82F6), 'Seerah',
      'Biography of Prophet Muhammad ﷺ.'),
  _Topic(Icons.school, Color(0xFFEF4444), 'Aqeedah',
      'Foundations of Islamic creed and belief.'),
];

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran Academy')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final t = _topics[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: t.color,
                child: Icon(t.icon, color: Colors.white),
              ),
              title: Text(t.title),
              subtitle: Text(t.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: t.route != null
                  ? () => context.push(t.route!)
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${t.title} content coming soon')),
                      ),
            ),
          );
        },
      ),
    );
  }
}
