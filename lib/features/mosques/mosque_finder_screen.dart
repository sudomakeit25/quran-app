import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Mosque {
  final String name;
  final double lat;
  final double lng;
  final double distanceKm;
  final double bearing;
  const Mosque({
    required this.name,
    required this.lat,
    required this.lng,
    required this.distanceKm,
    required this.bearing,
  });
}

const _overpassEndpoint = 'https://overpass-api.de/api/interpreter';

Future<List<Mosque>> fetchNearbyMosques({
  required double lat,
  required double lng,
  double radiusMeters = 5000,
  Duration timeout = const Duration(seconds: 20),
}) async {
  // OSM tag for mosques: amenity=place_of_worship + religion=muslim
  final query = '''
[out:json][timeout:25];
(
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$lat,$lng);
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$lat,$lng);
  relation["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$lat,$lng);
);
out center;
''';

  final dio = Dio(BaseOptions(
    connectTimeout: timeout,
    receiveTimeout: timeout,
    sendTimeout: timeout,
  ));
  // Overpass expects form-encoded `data=<query>`; build manually for reliability.
  final formBody = 'data=${Uri.encodeQueryComponent(query)}';
  final resp = await dio.post(
    _overpassEndpoint,
    data: formBody,
    options: Options(
      contentType: 'application/x-www-form-urlencoded',
      responseType: ResponseType.plain,
    ),
  );

  final data = resp.data is String ? jsonDecode(resp.data) : resp.data;
  final elements = (data['elements'] as List).cast<Map<String, dynamic>>();

  final results = <Mosque>[];
  for (final e in elements) {
    final tags = (e['tags'] as Map<String, dynamic>?) ?? const {};
    final name = (tags['name'] ?? tags['name:en'] ?? 'Mosque').toString();
    double? mLat, mLng;
    if (e['lat'] != null && e['lon'] != null) {
      mLat = (e['lat'] as num).toDouble();
      mLng = (e['lon'] as num).toDouble();
    } else if (e['center'] != null) {
      final c = e['center'] as Map<String, dynamic>;
      mLat = (c['lat'] as num).toDouble();
      mLng = (c['lon'] as num).toDouble();
    }
    if (mLat == null || mLng == null) continue;

    final distM = Geolocator.distanceBetween(lat, lng, mLat, mLng);
    final bearing = Geolocator.bearingBetween(lat, lng, mLat, mLng);
    results.add(Mosque(
      name: name,
      lat: mLat,
      lng: mLng,
      distanceKm: distM / 1000,
      bearing: (bearing + 360) % 360,
    ));
  }

  results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  return results;
}

final _mosquesProvider =
    FutureProvider.autoDispose<List<Mosque>>((ref) async {
  final enabled = await Geolocator.isLocationServiceEnabled();
  if (!enabled) throw 'Location services are off. Turn on Location Services in Settings.';

  var perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }
  if (perm == LocationPermission.denied) {
    throw 'Location permission denied. Tap Retry or grant permission in Settings.';
  }
  if (perm == LocationPermission.deniedForever) {
    throw 'Location permission permanently denied. Open Settings → Quran & Prayer → Location to enable.';
  }

  Position pos;
  try {
    final last = await Geolocator.getLastKnownPosition();
    if (last != null) {
      pos = last;
    } else {
      pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 12),
      );
    }
  } on TimeoutException {
    throw 'Could not get your location (GPS timed out). Try again near a window or outdoors.';
  } catch (e) {
    throw 'Could not get your location: $e';
  }

  return fetchNearbyMosques(lat: pos.latitude, lng: pos.longitude);
});

class MosqueFinderScreen extends ConsumerWidget {
  const MosqueFinderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mosquesAsync = ref.watch(_mosquesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Mosques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_mosquesProvider),
          ),
        ],
      ),
      body: mosquesAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Finding nearby mosques…'),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Could not load mosques:\n$e',
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  onPressed: () => ref.invalidate(_mosquesProvider),
                ),
              ],
            ),
          ),
        ),
        data: (mosques) {
          if (mosques.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No mosques found within 5 km.\n'
                  'Data from OpenStreetMap — accuracy varies by region.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: mosques.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final m = mosques[i];
              return ListTile(
                leading: const Icon(Icons.mosque),
                title: Text(m.name),
                subtitle: Text(
                    '${m.distanceKm.toStringAsFixed(2)} km · ${_compass(m.bearing)}'),
                trailing: const Icon(Icons.directions),
                onTap: () => _openInMaps(m.lat, m.lng, m.name),
              );
            },
          );
        },
      ),
    );
  }

  String _compass(double bearing) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final idx = ((bearing + 22.5) % 360 / 45).floor() % 8;
    return dirs[idx];
  }

  Future<void> _openInMaps(double lat, double lng, String label) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// Unused but useful for future sorting by bearing.
// ignore: unused_element
double _angleDiff(double a, double b) {
  final d = (a - b).abs() % 360;
  return d > 180 ? 360 - d : d;
}

// ignore: unused_element
double _radians(double degrees) => degrees * math.pi / 180;
