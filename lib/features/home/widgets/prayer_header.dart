import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../widget/widget_updater.dart';
import '../home_providers.dart';

class PrayerHeader extends ConsumerWidget {
  const PrayerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(prayerInfoProvider);
    final tickAsync = ref.watch(tickProvider);
    final now = tickAsync.maybeWhen(data: (t) => t, orElse: () => DateTime.now());

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SakinahColors.indigoNight,
            SakinahColors.indigoDeep,
            SakinahColors.indigoSoft,
          ],
        ),
        border: Border(
          bottom: BorderSide(color: SakinahColors.gold.withValues(alpha: 0.35), width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: SakinahColors.goldSoft),
                  onPressed: () => context.push('/settings'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final ok = await requestUserLocation(ref);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(ok
                            ? 'Location updated, refreshing prayer times…'
                            : 'Location permission denied — using Makkah'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.my_location, color: SakinahColors.goldSoft, size: 18),
                  label: const Text('Use my location',
                      style: TextStyle(color: SakinahColors.goldSoft)),
                ),
              ],
            ),
            infoAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(color: Colors.white70),
              ),
              error: (e, _) => Text(
                'Could not load prayer times',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
              data: (info) {
                if (info == null) {
                  return const Text(
                    'Location permission required',
                    style: TextStyle(color: Colors.white70),
                  );
                }
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => updatePrayerWidget(info));
                return _prayerColumn(context, info, now);
              },
            ),
            const SizedBox(height: 16),
            _dateRow(infoAsync.value, now),
          ],
        ),
      ),
    );
  }

  String _prayerName(Prayer p) {
    switch (p) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.sunrise:
        return 'Sunrise';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
      case Prayer.none:
        return 'Isha';
    }
  }

  Widget _prayerColumn(BuildContext context, TodayPrayerInfo info, DateTime now) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: SakinahColors.gold.withValues(alpha: 0.5), width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _prayerName(info.next).toUpperCase(),
            style: const TextStyle(
              color: SakinahColors.goldSoft,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          DateFormat.jm().format(info.nextTime),
          style: const TextStyle(
            color: SakinahColors.cream,
            fontSize: 60,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _dateRow(TodayPrayerInfo? info, DateTime now) {
    final hijri = HijriCalendar.fromDate(now);
    final hijriDate =
        '${_hijriMonth(hijri.hMonth)} ${hijri.hDay}, ${hijri.hYear} AH';
    final gregorian = DateFormat('MMM d, y').format(now);

    String? endsInLabel;
    if (info != null) {
      final remaining = info.nextTime.difference(now.toLocal());
      if (!remaining.isNegative) {
        final h = remaining.inHours;
        final m = remaining.inMinutes.remainder(60);
        final s = remaining.inSeconds.remainder(60);
        endsInLabel =
            '${_prayerName(info.current)} ends in\n${h}h ${m}m ${s.toString().padLeft(2, '0')}s';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hijriDate,
                style: TextStyle(color: SakinahColors.goldSoft.withValues(alpha: 0.85), fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                gregorian,
                style: const TextStyle(
                  color: SakinahColors.cream,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (endsInLabel != null)
          Text(
            endsInLabel,
            textAlign: TextAlign.right,
            style: TextStyle(color: SakinahColors.cream.withValues(alpha: 0.85), fontSize: 13),
          ),
      ],
    );
  }

  String _hijriMonth(int m) {
    const months = [
      '',
      'Muharram',
      'Safar',
      'Rabi al-Awwal',
      'Rabi al-Thani',
      'Jumada al-Ula',
      'Jumada al-Akhirah',
      'Rajab',
      "Sha'ban",
      'Ramadan',
      'Shawwal',
      "Dhu al-Qi'dah",
      'Dhu al-Hijjah',
    ];
    return months[m];
  }
}
