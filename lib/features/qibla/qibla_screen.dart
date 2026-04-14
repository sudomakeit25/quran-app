import 'dart:math' as math;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final _bearingProvider = FutureProvider<double?>((ref) async {
  final permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }
  final pos = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.low,
  );
  final coords = Coordinates(pos.latitude, pos.longitude);
  return Qibla(coords).direction;
});

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qiblaAsync = ref.watch(_bearingProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Qibla')),
      body: qiblaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (qibla) {
          if (qibla == null) {
            return const Center(child: Text('Location permission required'));
          }
          return StreamBuilder(
            stream: FlutterCompass.events,
            builder: (context, snapshot) {
              final heading = snapshot.data?.heading;
              if (heading == null) {
                return const Center(child: Text('Compass unavailable'));
              }
              final angle = (qibla - heading) * (math.pi / 180);
              return Center(
                child: Transform.rotate(
                  angle: angle,
                  child: const Icon(Icons.navigation, size: 200),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
