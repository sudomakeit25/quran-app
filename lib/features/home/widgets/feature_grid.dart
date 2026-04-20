import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeatureItem {
  final IconData icon;
  final Color color;
  final String label;
  final String route;
  const FeatureItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.route,
  });
}

const _features = <FeatureItem>[
  FeatureItem(icon: Icons.menu_book, color: Color(0xFFF59E0B), label: 'Read Quran', route: '/quran'),
  FeatureItem(icon: Icons.explore, color: Color(0xFF10B981), label: 'Qibla Direction', route: '/qibla'),
  FeatureItem(icon: Icons.pan_tool_alt, color: Color(0xFF3B82F6), label: 'Dua', route: '/dua'),
  FeatureItem(icon: Icons.school, color: Color(0xFF8B5CF6), label: 'Quran Academy', route: '/academy'),
  FeatureItem(icon: Icons.flight, color: Color(0xFFEF4444), label: 'Inflight Times', route: '/inflight'),
  FeatureItem(icon: Icons.access_time, color: Color(0xFF6B7280), label: 'Prayer Times', route: '/prayer'),
  FeatureItem(icon: Icons.bubble_chart, color: Color(0xFF14B8A6), label: 'Tasbeeh', route: '/tasbeeh'),
  FeatureItem(icon: Icons.menu_book_outlined, color: Color(0xFFEAB308), label: 'Learn Tajweed', route: '/tajweed'),
  FeatureItem(icon: Icons.live_tv, color: Color(0xFF1F2937), label: 'Makkah Live', route: '/makkah'),
  FeatureItem(icon: Icons.location_city, color: Color(0xFF059669), label: 'Madinah Live', route: '/madinah'),
  FeatureItem(icon: Icons.bookmark, color: Color(0xFFD97706), label: 'Bookmarks', route: '/bookmarks'),
  FeatureItem(icon: Icons.star, color: Color(0xFFBE185D), label: '99 Names', route: '/names'),
  FeatureItem(icon: Icons.calculate, color: Color(0xFF0891B2), label: 'Zakat', route: '/zakat'),
  FeatureItem(icon: Icons.checklist, color: Color(0xFF7C3AED), label: 'Tracker', route: '/tracker'),
  FeatureItem(icon: Icons.brightness_3, color: Color(0xFF9333EA), label: 'Ramadan', route: '/ramadan'),
  FeatureItem(icon: Icons.mosque, color: Color(0xFF166534), label: 'Mosques', route: '/mosques'),
  FeatureItem(icon: Icons.library_books, color: Color(0xFF92400E), label: 'Hadith', route: '/hadith'),
];

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: _features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 4,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, i) => _Tile(item: _features[i]),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final FeatureItem item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push(item.route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
