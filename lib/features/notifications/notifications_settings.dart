import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

import '../settings/prayer_settings.dart';
import 'notification_service.dart';

class NotificationPrefs {
  final bool adhanEnabled;
  final int preReminderMinutes;
  final bool dailyAyahEnabled;
  final int dailyAyahHour;
  final int dailyAyahMinute;
  final bool streakReminderEnabled;
  final int streakReminderHour;
  final int streakReminderMinute;
  const NotificationPrefs({
    required this.adhanEnabled,
    required this.preReminderMinutes,
    required this.dailyAyahEnabled,
    required this.dailyAyahHour,
    required this.dailyAyahMinute,
    required this.streakReminderEnabled,
    required this.streakReminderHour,
    required this.streakReminderMinute,
  });

  NotificationPrefs copyWith({
    bool? adhanEnabled,
    int? preReminderMinutes,
    bool? dailyAyahEnabled,
    int? dailyAyahHour,
    int? dailyAyahMinute,
    bool? streakReminderEnabled,
    int? streakReminderHour,
    int? streakReminderMinute,
  }) =>
      NotificationPrefs(
        adhanEnabled: adhanEnabled ?? this.adhanEnabled,
        preReminderMinutes: preReminderMinutes ?? this.preReminderMinutes,
        dailyAyahEnabled: dailyAyahEnabled ?? this.dailyAyahEnabled,
        dailyAyahHour: dailyAyahHour ?? this.dailyAyahHour,
        dailyAyahMinute: dailyAyahMinute ?? this.dailyAyahMinute,
        streakReminderEnabled:
            streakReminderEnabled ?? this.streakReminderEnabled,
        streakReminderHour: streakReminderHour ?? this.streakReminderHour,
        streakReminderMinute: streakReminderMinute ?? this.streakReminderMinute,
      );
}

class NotificationPrefsNotifier extends StateNotifier<NotificationPrefs> {
  final Box _box;
  NotificationPrefsNotifier(this._box) : super(_load(_box));

  static NotificationPrefs _load(Box box) => NotificationPrefs(
        adhanEnabled: box.get('adhan_enabled', defaultValue: false) as bool,
        preReminderMinutes:
            box.get('adhan_pre_minutes', defaultValue: 0) as int,
        dailyAyahEnabled:
            box.get('daily_ayah_enabled', defaultValue: false) as bool,
        dailyAyahHour: box.get('daily_ayah_hour', defaultValue: 9) as int,
        dailyAyahMinute: box.get('daily_ayah_minute', defaultValue: 0) as int,
        streakReminderEnabled:
            box.get('streak_reminder_enabled', defaultValue: false) as bool,
        streakReminderHour:
            box.get('streak_reminder_hour', defaultValue: 20) as int,
        streakReminderMinute:
            box.get('streak_reminder_minute', defaultValue: 0) as int,
      );

  void _save() {
    _box.put('adhan_enabled', state.adhanEnabled);
    _box.put('adhan_pre_minutes', state.preReminderMinutes);
    _box.put('daily_ayah_enabled', state.dailyAyahEnabled);
    _box.put('daily_ayah_hour', state.dailyAyahHour);
    _box.put('daily_ayah_minute', state.dailyAyahMinute);
    _box.put('streak_reminder_enabled', state.streakReminderEnabled);
    _box.put('streak_reminder_hour', state.streakReminderHour);
    _box.put('streak_reminder_minute', state.streakReminderMinute);
  }

  void setAdhanEnabled(bool v) {
    state = state.copyWith(adhanEnabled: v);
    _save();
  }

  void setPreMinutes(int v) {
    state = state.copyWith(preReminderMinutes: v);
    _save();
  }

  void setDailyAyahEnabled(bool v) {
    state = state.copyWith(dailyAyahEnabled: v);
    _save();
  }

  void setDailyAyahTime(int h, int m) {
    state = state.copyWith(dailyAyahHour: h, dailyAyahMinute: m);
    _save();
  }

  void setStreakReminderEnabled(bool v) {
    state = state.copyWith(streakReminderEnabled: v);
    _save();
  }

  void setStreakReminderTime(int h, int m) {
    state =
        state.copyWith(streakReminderHour: h, streakReminderMinute: m);
    _save();
  }
}

final notificationPrefsProvider =
    StateNotifierProvider<NotificationPrefsNotifier, NotificationPrefs>((ref) {
  return NotificationPrefsNotifier(Hive.box('settings'));
});

Future<void> applyNotifications(WidgetRef ref) async {
  final prefs = ref.read(notificationPrefsProvider);
  final svc = NotificationService.instance;
  await svc.init();

  if (!prefs.adhanEnabled && !prefs.dailyAyahEnabled) {
    await svc.cancelAll();
    return;
  }

  await svc.requestPermissions();

  if (prefs.adhanEnabled) {
    final settings = ref.read(prayerSettingsProvider);
    Coordinates coords;
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );
      coords = Coordinates(pos.latitude, pos.longitude);
    } catch (_) {
      coords = Coordinates(21.4225, 39.8262);
    }
    final params = settings.method.getParameters();
    params.madhab = settings.madhab;
    final times = PrayerTimes.today(coords, params);
    await svc.scheduleAdhanForToday(
      times,
      preReminderMinutes: prefs.preReminderMinutes,
    );
  }

  if (prefs.dailyAyahEnabled) {
    await svc.scheduleDailyAyah(
      hour: prefs.dailyAyahHour,
      minute: prefs.dailyAyahMinute,
      body:
          'Open the app to read today\'s ayah and reflection.',
    );
  } else {
    await svc.cancelDailyAyah();
  }

  if (prefs.streakReminderEnabled) {
    await svc.scheduleStreakReminder(
      hour: prefs.streakReminderHour,
      minute: prefs.streakReminderMinute,
    );
  } else {
    await svc.cancelStreakReminder();
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final notifier = ref.read(notificationPrefsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          const _SectionHeader('Adhan'),
          SwitchListTile(
            title: const Text('Prayer time notifications'),
            subtitle: const Text(
                'Notify at each of the 5 daily prayer times based on your location'),
            value: prefs.adhanEnabled,
            onChanged: (v) async {
              notifier.setAdhanEnabled(v);
              await applyNotifications(ref);
            },
          ),
          ListTile(
            title: const Text('Pre-adhan reminder'),
            subtitle: Text(prefs.preReminderMinutes == 0
                ? 'Off'
                : '${prefs.preReminderMinutes} minutes before'),
            enabled: prefs.adhanEnabled,
            onTap: () async {
              final picked = await showDialog<int>(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Pre-adhan reminder'),
                  children: [
                    for (final m in [0, 5, 10, 15, 20, 30])
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, m),
                        child: Text(m == 0 ? 'Off' : '$m minutes before'),
                      ),
                  ],
                ),
              );
              if (picked != null) {
                notifier.setPreMinutes(picked);
                await applyNotifications(ref);
              }
            },
          ),
          const Divider(),
          const _SectionHeader('Daily Ayah'),
          SwitchListTile(
            title: const Text('Daily ayah reminder'),
            subtitle: const Text(
                'A daily push notification encouraging you to read the Quran'),
            value: prefs.dailyAyahEnabled,
            onChanged: (v) async {
              notifier.setDailyAyahEnabled(v);
              await applyNotifications(ref);
            },
          ),
          ListTile(
            title: const Text('Time'),
            subtitle: Text(
                '${prefs.dailyAyahHour.toString().padLeft(2, '0')}:${prefs.dailyAyahMinute.toString().padLeft(2, '0')}'),
            enabled: prefs.dailyAyahEnabled,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: prefs.dailyAyahHour,
                  minute: prefs.dailyAyahMinute,
                ),
              );
              if (picked != null) {
                notifier.setDailyAyahTime(picked.hour, picked.minute);
                await applyNotifications(ref);
              }
            },
          ),
          const Divider(),
          const _SectionHeader('Streak'),
          SwitchListTile(
            title: const Text('Streak reminder'),
            subtitle: const Text(
                'A nudge later in the day if you have not yet met your daily reading goal'),
            value: prefs.streakReminderEnabled,
            onChanged: (v) async {
              notifier.setStreakReminderEnabled(v);
              await applyNotifications(ref);
            },
          ),
          ListTile(
            title: const Text('Reminder time'),
            subtitle: Text(
                '${prefs.streakReminderHour.toString().padLeft(2, '0')}:${prefs.streakReminderMinute.toString().padLeft(2, '0')}'),
            enabled: prefs.streakReminderEnabled,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: prefs.streakReminderHour,
                  minute: prefs.streakReminderMinute,
                ),
              );
              if (picked != null) {
                notifier.setStreakReminderTime(picked.hour, picked.minute);
                await applyNotifications(ref);
              }
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Note: Adhan schedules are refreshed daily when you open the app. '
              'On Android, exact alarms may require enabling permission in system settings.',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
