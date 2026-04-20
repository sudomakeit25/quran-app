import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../home/home_providers.dart';

const _androidWidgetName = 'PrayerWidgetProvider';
const _iosWidgetName = 'PrayerWidget';
const _appGroupId = 'group.com.nayeem.quran';

/// Push current next-prayer info to the home-screen widget (Android + iOS).
/// Safe to call on any platform — no-op on web.
Future<void> updatePrayerWidget(TodayPrayerInfo info) async {
  if (kIsWeb) return;
  final isAndroid = defaultTargetPlatform == TargetPlatform.android;
  final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
  if (!isAndroid && !isIOS) return;

  final timeFmt = DateFormat.jm();
  final countdown = info.nextTime.difference(DateTime.now());
  final nextName = _prayerName(info.next);

  if (isIOS) {
    HomeWidget.setAppGroupId(_appGroupId);
  }

  await HomeWidget.saveWidgetData<String>('next_prayer_name', nextName);
  await HomeWidget.saveWidgetData<String>(
      'next_prayer_time', timeFmt.format(info.nextTime));
  await HomeWidget.saveWidgetData<String>(
      'next_prayer_countdown', 'in ${_formatDuration(countdown)}');

  await HomeWidget.updateWidget(
    androidName: _androidWidgetName,
    qualifiedAndroidName: 'dev.nayeem.quran.$_androidWidgetName',
    iOSName: _iosWidgetName,
  );
}

String _prayerName(dynamic prayer) {
  final s = prayer.toString().toLowerCase();
  if (s.contains('fajr')) return 'Fajr';
  if (s.contains('dhuhr')) return 'Dhuhr';
  if (s.contains('asr')) return 'Asr';
  if (s.contains('maghrib')) return 'Maghrib';
  if (s.contains('isha')) return 'Isha';
  return 'Prayer';
}

String _formatDuration(Duration d) {
  if (d.isNegative) return '—';
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  if (h > 0) return '${h}h ${m}m';
  return '${m}m';
}
