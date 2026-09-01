import 'package:dio/dio.dart';

class Place {
  final String name;
  final double lat;
  final double lng;
  const Place({required this.name, required this.lat, required this.lng});
}

const _nominatimEndpoint = 'https://nominatim.openstreetmap.org/search';

/// Nominatim's usage policy requires a User-Agent that identifies the app.
const _userAgent = 'Tilawa/1.0 (com.nayeem.quran)';

/// Looks up a town or city by name so prayer times can be calculated for
/// somewhere other than the device's current position (travel, planning ahead).
Future<List<Place>> searchPlaces(
  String query, {
  Duration timeout = const Duration(seconds: 15),
}) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) return const [];

  final dio = Dio(BaseOptions(
    connectTimeout: timeout,
    receiveTimeout: timeout,
    headers: const {'User-Agent': _userAgent},
  ));

  final resp = await dio.get(
    _nominatimEndpoint,
    queryParameters: {
      'q': trimmed,
      'format': 'json',
      'limit': 8,
      'addressdetails': 0,
    },
  );

  final data = resp.data;
  if (data is! List) return const [];

  final places = <Place>[];
  for (final row in data) {
    if (row is! Map) continue;
    final lat = double.tryParse('${row['lat']}');
    final lng = double.tryParse('${row['lon']}');
    final name = row['display_name'] as String?;
    if (lat == null || lng == null || name == null || name.isEmpty) continue;
    places.add(Place(name: name, lat: lat, lng: lng));
  }
  return places;
}

/// Trims Nominatim's long comma-separated display name down to something that
/// fits a list tile: the locality plus the country.
String shortPlaceName(String displayName) {
  final parts = displayName.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return displayName;
  if (parts.length == 1) return parts.first;
  return '${parts.first}, ${parts.last}';
}
