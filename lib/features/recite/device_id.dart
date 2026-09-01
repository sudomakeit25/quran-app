import 'dart:math';

import 'package:hive/hive.dart';

/// An opaque, per-install identifier sent with transcription requests.
///
/// It is **not** a credential and grants nothing: the proxy uses it only to
/// spread rate limits across installs so one device cannot exhaust the daily
/// budget. It is random, stored locally, never tied to the user, and never
/// leaves the device except as this header.
String deviceId() {
  final box = Hive.box('settings');
  final existing = box.get('device_id');
  if (existing is String && existing.length >= 8) return existing;

  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  final id = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  box.put('device_id', id);
  return id;
}
