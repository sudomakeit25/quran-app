import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await init();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final result = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Schedule today's 5 prayer notifications based on the given PrayerTimes.
  /// Pre-adhan reminder scheduled if [preReminderMinutes] > 0.
  Future<void> scheduleAdhanForToday(
    PrayerTimes times, {
    int preReminderMinutes = 0,
    Set<Prayer> enabledPrayers = const {
      Prayer.fajr,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha,
    },
  }) async {
    await init();
    await _plugin.cancelAll();

    final entries = <(int id, Prayer p, DateTime at, String title, String body)>[
      (101, Prayer.fajr, times.fajr.toLocal(), 'Fajr', 'It is time for Fajr prayer'),
      (102, Prayer.dhuhr, times.dhuhr.toLocal(), 'Dhuhr', 'It is time for Dhuhr prayer'),
      (103, Prayer.asr, times.asr.toLocal(), 'Asr', 'It is time for Asr prayer'),
      (104, Prayer.maghrib, times.maghrib.toLocal(), 'Maghrib', 'It is time for Maghrib prayer'),
      (105, Prayer.isha, times.isha.toLocal(), 'Isha', 'It is time for Isha prayer'),
    ];

    for (final e in entries) {
      if (!enabledPrayers.contains(e.$2)) continue;
      if (e.$3.isAfter(DateTime.now())) {
        await _scheduleAt(e.$1, e.$4, e.$5, e.$3, channelId: 'adhan');
        if (preReminderMinutes > 0) {
          final preTime = e.$3.subtract(Duration(minutes: preReminderMinutes));
          if (preTime.isAfter(DateTime.now())) {
            await _scheduleAt(
              e.$1 + 1000,
              '${e.$4} soon',
              '${e.$4} in $preReminderMinutes minutes',
              preTime,
              channelId: 'adhan-pre',
            );
          }
        }
      }
    }
  }

  /// Schedule a daily-recurring ayah reminder at [hour]:[minute].
  Future<void> scheduleDailyAyah({
    required int hour,
    required int minute,
    required String body,
  }) async {
    await init();
    await _plugin.cancel(200);
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      200,
      'Ayah of the Day',
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily-ayah',
          'Daily Ayah',
          channelDescription: 'A daily verse from the Quran',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyAyah() async {
    await init();
    await _plugin.cancel(200);
  }

  /// Schedule a daily streak-protection nudge at [hour]:[minute] local.
  /// Cancel + reschedule when goal is met that day.
  Future<void> scheduleStreakReminder({
    required int hour,
    required int minute,
  }) async {
    await init();
    await _plugin.cancel(201);
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, hour, minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      201,
      "Don't lose your Quran streak",
      'Open the app to read today\'s ayahs and keep your streak going.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak-reminder',
          'Streak Reminders',
          channelDescription: 'Reminds you to read before midnight',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelStreakReminder() async {
    await init();
    await _plugin.cancel(201);
  }

  Future<void> _scheduleAt(
    int id,
    String title,
    String body,
    DateTime when, {
    required String channelId,
  }) async {
    final local = tz.TZDateTime.from(when, tz.local);
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      local,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId == 'adhan' ? 'Adhan' : 'Prayer Reminders',
          channelDescription:
              channelId == 'adhan' ? 'Prayer time notifications' : 'Pre-adhan reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
