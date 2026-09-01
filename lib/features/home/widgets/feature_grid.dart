import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeatureItem {
  final IconData icon;
  final String label;
  final String route;
  const FeatureItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class FeatureCategory {
  final String title;
  final IconData icon;
  final List<FeatureItem> items;
  const FeatureCategory({required this.title, required this.icon, required this.items});
}

const _categories = <FeatureCategory>[
  FeatureCategory(
    title: 'Quran',
    icon: Icons.auto_stories_outlined,
    items: [
      FeatureItem(icon: Icons.menu_book_outlined, label: 'Read Quran', route: '/quran'),
      FeatureItem(icon: Icons.mic_outlined, label: 'Ayah Check', route: '/recite'),
      FeatureItem(icon: Icons.bookmark_outline, label: 'Bookmarks', route: '/bookmarks'),
      FeatureItem(icon: Icons.search, label: 'Search', route: '/search'),
    ],
  ),
  FeatureCategory(
    title: 'Prayer',
    icon: Icons.access_time,
    items: [
      FeatureItem(icon: Icons.schedule, label: 'Prayer Times', route: '/prayer'),
      FeatureItem(icon: Icons.explore_outlined, label: 'Qibla', route: '/qibla'),
      FeatureItem(icon: Icons.pan_tool_alt_outlined, label: 'Dua', route: '/dua'),
      FeatureItem(icon: Icons.radio_button_checked, label: 'Tasbeeh', route: '/tasbeeh'),
    ],
  ),
  FeatureCategory(
    title: 'Learn',
    icon: Icons.school_outlined,
    items: [
      FeatureItem(icon: Icons.library_books_outlined, label: 'Hadith', route: '/hadith'),
      FeatureItem(icon: Icons.record_voice_over_outlined, label: 'Tajweed', route: '/tajweed'),
      FeatureItem(icon: Icons.star_outline, label: '99 Names', route: '/names'),
    ],
  ),
  FeatureCategory(
    title: 'Tools',
    icon: Icons.build_outlined,
    items: [
      FeatureItem(icon: Icons.calculate_outlined, label: 'Zakat', route: '/zakat'),
      FeatureItem(icon: Icons.checklist_outlined, label: 'Tracker', route: '/tracker'),
      FeatureItem(icon: Icons.nightlight_outlined, label: 'Ramadan', route: '/ramadan'),
      FeatureItem(icon: Icons.mosque_outlined, label: 'Mosques', route: '/mosques'),
    ],
  ),
];

class FeatureGrid extends StatefulWidget {
  const FeatureGrid({super.key});

  @override
  State<FeatureGrid> createState() => _FeatureGridState();
}

class _FeatureGridState extends State<FeatureGrid> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final category = _categories[_selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'EXPLORE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: scheme.secondary,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = _categories[i];
              final active = i == _selected;
              return GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? scheme.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: active ? scheme.secondary : scheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cat.icon,
                        size: 16,
                        color: active ? scheme.onSecondary : scheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: active ? scheme.onSecondary : scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: category.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, i) => _FeatureTile(item: category.items[i]),
          ),
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final FeatureItem item;
  const _FeatureTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outlineVariant, width: 1),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: scheme.secondary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: scheme.secondary.withValues(alpha: 0.35), width: 1),
              ),
              child: Icon(item.icon, color: scheme.secondary, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
