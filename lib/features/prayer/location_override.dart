import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'place_search.dart';

/// A location the user picked by hand, replacing device geolocation for prayer
/// time calculation. Null means "use my current position".
class ManualLocation {
  final String name;
  final double lat;
  final double lng;
  const ManualLocation({required this.name, required this.lat, required this.lng});

  Map<String, dynamic> toJson() => {'name': name, 'lat': lat, 'lng': lng};

  static ManualLocation? fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final lat = json['lat'];
    final lng = json['lng'];
    if (name is! String || lat is! num || lng is! num) return null;
    return ManualLocation(name: name, lat: lat.toDouble(), lng: lng.toDouble());
  }
}

class LocationOverrideNotifier extends StateNotifier<ManualLocation?> {
  final Box _box;
  static const _key = 'manual_location';

  LocationOverrideNotifier(this._box) : super(_load(_box));

  static ManualLocation? _load(Box box) {
    final raw = box.get(_key);
    if (raw is! String || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return ManualLocation.fromJson(decoded.cast<String, dynamic>());
    } catch (_) {
      return null;
    }
  }

  void setPlace(Place place) {
    final loc = ManualLocation(
      name: shortPlaceName(place.name),
      lat: place.lat,
      lng: place.lng,
    );
    _box.put(_key, jsonEncode(loc.toJson()));
    state = loc;
  }

  void clear() {
    _box.delete(_key);
    state = null;
  }
}

final locationOverrideProvider =
    StateNotifierProvider<LocationOverrideNotifier, ManualLocation?>((ref) {
  return LocationOverrideNotifier(Hive.box('settings'));
});
