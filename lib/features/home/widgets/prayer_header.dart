import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1F2937),
            Color(0xFF374151),
            Color(0xFF4B5563),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
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
                  icon: const Icon(Icons.my_location, color: Colors.white, size: 18),
                  label: const Text('Use my location',
                      style: TextStyle(color: Colors.white)),
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
        Text(
          _prayerName(info.next),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat.jm().format(info.nextTime),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 56,
            fontWeight: FontWeight.bold,
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
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                gregorian,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (endsInLabel != null)
          Text(
            endsInLabel,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white, fontSize: 13),
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
