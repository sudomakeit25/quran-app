import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../journey/journey_provider.dart';

class JourneyCard extends ConsumerWidget {
  const JourneyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(journeyProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/quran'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(
              stats.readToday
                  ? Icons.local_fire_department
                  : Icons.auto_stories,
              size: 48,
              color: stats.readToday
                  ? const Color(0xFFEF4444)
                  : const Color(0xFFF59E0B),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Quran Journey',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stats.streak == 0 && !stats.readToday
                        ? 'Start Your Streak  ·  ${stats.ayahsToday}/${stats.dailyGoalAyahs} ayahs today'
                        : '${stats.streak} day streak ${stats.readToday ? "🔥" : ""}  ·  ${stats.ayahsToday}/${stats.dailyGoalAyahs} ayahs today',
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: stats.progress,
                      minHeight: 6,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        stats.goalMet
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                  if (!stats.readToday && stats.streak > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Read ${stats.dailyGoalAyahs - stats.ayahsToday} more ayah(s) to keep your streak',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.orange),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
