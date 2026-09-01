import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../journey/journey_provider.dart';

class JourneyCard extends ConsumerWidget {
  const JourneyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(journeyProvider);
    final goalMet = stats.goalMet;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push('/quran'),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          decoration: BoxDecoration(
            color: SakinahColors.indigoDeep,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.45), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'WIRD',
                    style: TextStyle(
                      color: SakinahColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 36, height: 1, color: SakinahColors.gold.withValues(alpha: 0.4)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: SakinahColors.goldSoft, size: 14),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Your daily Quran portion',
                style: TextStyle(
                  color: SakinahColors.creamText,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _StreakRing(streak: stats.streak, active: stats.readToday),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: SakinahColors.cream),
                            children: [
                              TextSpan(
                                text: '${stats.ayahsToday}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: SakinahColors.cream,
                                  height: 1,
                                ),
                              ),
                              TextSpan(
                                text: ' / ${stats.dailyGoalAyahs}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: SakinahColors.creamText.withValues(alpha: 0.6),
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'AYAHS TODAY',
                          style: TextStyle(
                            color: SakinahColors.goldSoft,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: stats.progress,
                            minHeight: 4,
                            backgroundColor: SakinahColors.indigoSoft.withValues(alpha: 0.5),
                            valueColor: AlwaysStoppedAnimation(
                              goalMet ? SakinahColors.gold : SakinahColors.goldSoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!stats.readToday && stats.streak > 0) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: SakinahColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule, size: 14, color: SakinahColors.goldSoft),
                      const SizedBox(width: 6),
                      Text(
                        'Read ${stats.dailyGoalAyahs - stats.ayahsToday} more to keep your streak',
                        style: const TextStyle(
                          color: SakinahColors.goldSoft,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakRing extends StatelessWidget {
  final int streak;
  final bool active;
  const _StreakRing({required this.streak, required this.active});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  SakinahColors.gold.withValues(alpha: active ? 0.35 : 0.15),
                  SakinahColors.gold.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SakinahColors.indigoNight,
              border: Border.all(
                color: active ? SakinahColors.gold : SakinahColors.gold.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$streak',
                  style: const TextStyle(
                    color: SakinahColors.cream,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'DAYS',
                  style: TextStyle(
                    color: SakinahColors.goldSoft,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
