import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../home/home_providers.dart';

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(prayerInfoProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (info) {
          if (info == null) {
            return const Center(child: Text('Location unavailable'));
          }
          final times = info.times;
          final fmt = DateFormat.jm();
          final entries = <(String, DateTime)>[
            ('Fajr', times.fajr.toLocal()),
            ('Sunrise', times.sunrise.toLocal()),
            ('Dhuhr', times.dhuhr.toLocal()),
            ('Asr', times.asr.toLocal()),
            ('Maghrib', times.maghrib.toLocal()),
            ('Isha', times.isha.toLocal()),
          ];
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final (name, t) in entries)
                ListTile(
                  leading: _iconFor(name),
                  title: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Text(
                    fmt.format(t),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Icon _iconFor(String name) {
    switch (name) {
      case 'Fajr':
        return const Icon(Icons.brightness_3, color: Color(0xFF1E40AF));
      case 'Sunrise':
        return const Icon(Icons.wb_sunny, color: Color(0xFFF59E0B));
      case 'Dhuhr':
        return const Icon(Icons.wb_sunny_outlined, color: Color(0xFFEAB308));
      case 'Asr':
        return const Icon(Icons.light_mode, color: Color(0xFFF97316));
      case 'Maghrib':
        return const Icon(Icons.nightlight_round, color: Color(0xFFA855F7));
      case 'Isha':
        return const Icon(Icons.bedtime, color: Color(0xFF1F2937));
      default:
        return const Icon(Icons.access_time);
    }
  }
}
