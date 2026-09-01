import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../reflect/reflect_data.dart';

class ReflectCard extends StatelessWidget {
  const ReflectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push('/reflect'),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [SakinahColors.indigoDeep, SakinahColors.indigoSoft],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.5), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SakinahColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.5), width: 1),
                ),
                child: const Icon(Icons.self_improvement, color: SakinahColors.goldSoft, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'REFLECT',
                      style: TextStyle(
                        color: SakinahColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'How is your heart today?',
                      style: TextStyle(
                        color: SakinahColors.cream,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: reflectMoods.take(4).map((m) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.4), width: 0.8),
                          ),
                          child: Text(
                            m.title,
                            style: const TextStyle(color: SakinahColors.creamText, fontSize: 10),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: SakinahColors.goldSoft, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
