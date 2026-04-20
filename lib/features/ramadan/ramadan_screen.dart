import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../home/home_providers.dart';
import 'ramadan_provider.dart';

class RamadanScreen extends ConsumerWidget {
  const RamadanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hijri = HijriCalendar.now();
    final prayerInfoAsync = ref.watch(prayerInfoProvider);
    final tracker = ref.watch(ramadanTrackerProvider);
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final trackerN = ref.read(ramadanTrackerProvider.notifier);
    final fasted = trackerN.fastedOn(todayStart);
    final taraweeh = trackerN.taraweehOn(todayStart);
    final isRamadan = isRamadanToday();
    final countdown = ref.watch(ramadanCountdownProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ramadan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 8),
                      Text(
                        '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRamadan
                        ? 'Ramadan Mubarak! It is currently the blessed month.'
                        : 'Not currently Ramadan. Tracker still available for reference.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (countdown != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(countdown.label,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(countdown.until),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          prayerInfoAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (info) {
              if (info == null) return const SizedBox.shrink();
              final win = ramadanWindow(info.times);
              if (win == null) return const SizedBox.shrink();
              final fmt = DateFormat.jm();
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_3),
                      title: const Text('Suhoor ends'),
                      trailing: Text(fmt.format(win.suhoorEnd),
                          style: const TextStyle(fontSize: 18)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.restaurant),
                      title: const Text('Iftar'),
                      trailing: Text(fmt.format(win.iftar),
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Today',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  CheckboxListTile(
                    title: const Text('Fasted today'),
                    value: fasted,
                    onChanged: (_) => trackerN.toggleFasted(todayStart),
                  ),
                  CheckboxListTile(
                    title: const Text('Prayed Taraweeh'),
                    value: taraweeh,
                    onChanged: (_) => trackerN.toggleTaraweeh(todayStart),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Days fasted',
                  value: '${trackerN.fastedCount}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  icon: Icons.mosque,
                  label: 'Taraweeh',
                  value: '${trackerN.taraweehCount}',
                ),
              ),
            ],
          ),
          // suppress unused warning for `tracker`
          SizedBox.shrink(child: Text('${tracker.length}', style: const TextStyle(fontSize: 0))),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return '—';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m';
    }
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
