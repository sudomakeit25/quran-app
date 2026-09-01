import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../home/home_providers.dart';
import '../settings/prayer_settings.dart';
import 'location_override.dart';
import 'place_search.dart';

class PrayerScreen extends ConsumerStatefulWidget {
  const PrayerScreen({super.key});

  @override
  ConsumerState<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends ConsumerState<PrayerScreen> {
  DateTime _date = DateTime.now();

  bool get _isToday {
    final now = DateTime.now();
    return _date.year == now.year &&
        _date.month == now.month &&
        _date.day == now.day;
  }

  void _shiftDate(int days) {
    setState(() => _date = _date.add(Duration(days: days)));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: _date,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _changeLocation() async {
    final place = await showModalBottomSheet<Place>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _PlaceSearchSheet(),
    );
    if (place == null) return;
    ref.read(locationOverrideProvider.notifier).setPlace(place);
    ref.invalidate(resolvedLocationProvider);
    ref.invalidate(prayerInfoProvider);
  }

  Future<void> _useMyLocation() async {
    ref.read(locationOverrideProvider.notifier).clear();
    ref.invalidate(resolvedLocationProvider);
    ref.invalidate(prayerInfoProvider);
    await requestUserLocation(ref);
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(resolvedLocationProvider);
    final settings = ref.watch(prayerSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: locationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (location) {
          final params = settings.method.getParameters();
          params.madhab = settings.madhab;
          final times = PrayerTimes(
            location.coords,
            DateComponents.from(_date),
            params,
          );
          final fmt = DateFormat.jm();
          final entries = <(String, DateTime)>[
            ('Fajr', times.fajr.toLocal()),
            ('Sunrise', times.sunrise.toLocal()),
            ('Dhuhr', times.dhuhr.toLocal()),
            ('Asr', times.asr.toLocal()),
            ('Maghrib', times.maghrib.toLocal()),
            ('Isha', times.isha.toLocal()),
          ];
          final currentPrayer = _isToday ? times.currentPrayer() : Prayer.none;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _LocationCard(
                location: location,
                onChange: _changeLocation,
                onUseMyLocation: _useMyLocation,
              ),
              _DateBar(
                date: _date,
                isToday: _isToday,
                onPrevious: () => _shiftDate(-1),
                onNext: () => _shiftDate(1),
                onPick: _pickDate,
                onToday: () => setState(() => _date = DateTime.now()),
              ),
              const Divider(height: 1),
              for (final (name, t) in entries)
                ListTile(
                  leading: _iconFor(name),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight: _isCurrent(name, currentPrayer)
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    fmt.format(t),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _isCurrent(name, currentPrayer)
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  bool _isCurrent(String name, Prayer current) {
    switch (current) {
      case Prayer.fajr:
        return name == 'Fajr';
      case Prayer.sunrise:
        return name == 'Sunrise';
      case Prayer.dhuhr:
        return name == 'Dhuhr';
      case Prayer.asr:
        return name == 'Asr';
      case Prayer.maghrib:
        return name == 'Maghrib';
      case Prayer.isha:
        return name == 'Isha';
      case Prayer.none:
        return false;
    }
  }

  Icon _iconFor(String name) {
    switch (name) {
      case 'Fajr':
        return const Icon(Icons.brightness_3, color: Color(0xFF1E40AF));
      case 'Sunrise':
        return const Icon(Icons.wb_sunny, color: Color(0xFFF59E0B));
      case 'Dhuhr':
        return const Icon(Icons.wb_sunny_outlined, color: Color(0xFFEAB308));
      case 'Asr':
        return const Icon(Icons.light_mode, color: Color(0xFFF97316));
      case 'Maghrib':
        return const Icon(Icons.nightlight_round, color: Color(0xFFA855F7));
      case 'Isha':
        return const Icon(Icons.bedtime, color: Color(0xFF1F2937));
      default:
        return const Icon(Icons.access_time);
    }
  }
}

class _LocationCard extends StatelessWidget {
  final ResolvedLocation location;
  final VoidCallback onChange;
  final VoidCallback onUseMyLocation;

  const _LocationCard({
    required this.location,
    required this.onChange,
    required this.onUseMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                location.isManual ? Icons.flight_takeoff : Icons.my_location,
                size: 18,
                color: scheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(onPressed: onChange, child: const Text('Change')),
            ],
          ),
          if (location.isManual || location.isFallback)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onUseMyLocation,
                icon: const Icon(Icons.my_location, size: 16),
                label: const Text('Use my location'),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateBar extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onPick;
  final VoidCallback onToday;

  const _DateBar({
    required this.date,
    required this.isToday,
    required this.onPrevious,
    required this.onNext,
    required this.onPick,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous day',
          ),
          Expanded(
            child: TextButton(
              onPressed: onPick,
              child: Text(
                isToday ? 'Today' : DateFormat.yMMMEd().format(date),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (!isToday)
            TextButton(onPressed: onToday, child: const Text('Today')),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next day',
          ),
        ],
      ),
    );
  }
}

class _PlaceSearchSheet extends StatefulWidget {
  const _PlaceSearchSheet();

  @override
  State<_PlaceSearchSheet> createState() => _PlaceSearchSheetState();
}

class _PlaceSearchSheetState extends State<_PlaceSearchSheet> {
  final _controller = TextEditingController();
  List<Place> _results = const [];
  bool _loading = false;
  String? _error;
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.length < 2) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await searchPlaces(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
        _searched = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _searched = true;
        _error = 'Could not search right now. Check your connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prayer times for another place',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Search a town or city to calculate times for it, useful when '
                'travelling or planning ahead.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  labelText: 'Town or city',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _search,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              if (!_loading && _error == null && _searched && _results.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No places matched that search.'),
                ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: _results.length,
                  itemBuilder: (context, i) {
                    final place = _results[i];
                    return ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: Text(shortPlaceName(place.name)),
                      subtitle: Text(
                        place.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.of(context).pop(place),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
