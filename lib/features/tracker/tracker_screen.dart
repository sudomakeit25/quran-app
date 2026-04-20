import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'prayer_tracker_provider.dart';

class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final log = ref.watch(prayerLogProvider(todayStart));
    final qada = ref.watch(qadaProvider);
    final box = Hive.box('settings');
    final streak = computeStreak(box, todayStart);
    final last7 = last7DaysCompletion(box, todayStart);

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Tracker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader(context, 'Today'),
          for (final k in PrayerKind.values)
            CheckboxListTile(
              title: Text(prayerKindNames[k]!),
              value: log[k] ?? false,
              onChanged: (_) =>
                  ref.read(prayerLogProvider(todayStart).notifier).toggle(k),
            ),
          const SizedBox(height: 16),
          _sectionHeader(context, 'Streak'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department,
                      color: streak > 0 ? Colors.orange : Colors.grey,
                      size: 32),
                  const SizedBox(width: 12),
                  Text(
                    '$streak day${streak == 1 ? '' : 's'}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Text('with all 5 prayers'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionHeader(context, 'Last 7 days'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var i = 0; i < 7; i++)
                    _DayBar(
                      label: _weekdayShort(
                          todayStart.subtract(Duration(days: 6 - i))),
                      count: last7[i],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader(context, 'Qada (missed prayers)'),
          Card(
            child: Column(
              children: [
                for (final k in PrayerKind.values)
                  ListTile(
                    title: Text(prayerKindNames[k]!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () =>
                              ref.read(qadaProvider.notifier).decrement(k),
                        ),
                        SizedBox(
                          width: 36,
                          child: Text(
                            '${qada[k] ?? 0}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () =>
                              ref.read(qadaProvider.notifier).increment(k),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Total outstanding'),
                  trailing: Text(
                    '${ref.read(qadaProvider.notifier).total}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayShort(DateTime d) {
    const names = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return names[(d.weekday - 1) % 7];
  }

  Widget _sectionHeader(BuildContext context, String s) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(
          s.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.8,
          ),
        ),
      );
}

class _DayBar extends StatelessWidget {
  final String label;
  final int count;
  const _DayBar({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Container(
          width: 24,
          height: 60,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 24,
            height: 60 * (count / 5),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
        Text('$count/5', style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
