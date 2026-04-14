import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

final _prayerTimesProvider = FutureProvider<PrayerTimes?>((ref) async {
  final permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }
  final pos = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low,
  );
  final coords = Coordinates(pos.latitude, pos.longitude);
  final params = CalculationMethod.muslim_world_league.getParameters();
  params.madhab = Madhab.shafi;
  return PrayerTimes.today(coords, params);
});

class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_prayerTimesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (times) {
          if (times == null) {
            return const Center(child: Text('Location permission required'));
          }
          final fmt = DateFormat.jm();
          final entries = <(String, DateTime)>[
            ('Fajr', times.fajr),
            ('Sunrise', times.sunrise),
            ('Dhuhr', times.dhuhr),
            ('Asr', times.asr),
            ('Maghrib', times.maghrib),
            ('Isha', times.isha),
          ];
          return ListView(
            children: [
              for (final (name, t) in entries)
                ListTile(
                  title: Text(name),
                  trailing: Text(fmt.format(t)),
                ),
            ],
          );
        },
      ),
    );
  }
}
