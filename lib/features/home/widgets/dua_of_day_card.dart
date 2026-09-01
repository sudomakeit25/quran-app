import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../dua/dua_data.dart';

List<Dua> _allDuas() {
  return [for (final c in duaCategories) ...c.duas];
}

Dua _duaOfTheDay(DateTime now) {
  final all = _allDuas();
  if (all.isEmpty) {
    return const Dua(
      title: '',
      arabic: '',
      transliteration: '',
      translation: '',
    );
  }
  final epochDay = DateTime.utc(now.year, now.month, now.day)
      .difference(DateTime.utc(2020, 1, 1))
      .inDays;
  final index = epochDay.abs() % all.length;
  return all[index];
}

class DuaOfDayCard extends StatelessWidget {
  const DuaOfDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dua = _duaOfTheDay(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push('/dua'),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [SakinahColors.indigoNight, SakinahColors.indigoDeep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: SakinahColors.gold, size: 14),
                  const SizedBox(width: 8),
                  const Text(
                    'DUA OF THE DAY',
                    style: TextStyle(
                      color: SakinahColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: SakinahColors.goldSoft, size: 13),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                dua.title,
                style: const TextStyle(
                  color: SakinahColors.cream,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: SakinahColors.indigoNight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dua.arabic,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: SakinahColors.cream,
                        fontSize: 19,
                        fontFamily: 'UthmanicHafs',
                        height: 1.9,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                dua.translation,
                style: TextStyle(
                  color: SakinahColors.creamText.withValues(alpha: 0.9),
                  fontSize: 13,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (dua.source != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(width: 20, height: 1, color: SakinahColors.gold.withValues(alpha: 0.4)),
                    const SizedBox(width: 8),
                    Text(
                      dua.source!,
                      style: const TextStyle(
                        color: SakinahColors.goldSoft,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
