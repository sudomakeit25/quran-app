import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InflightScreen extends StatefulWidget {
  const InflightScreen({super.key});

  @override
  State<InflightScreen> createState() => _InflightScreenState();
}

class _InflightScreenState extends State<InflightScreen> {
  final _latCtrl = TextEditingController(text: '21.4225');
  final _lngCtrl = TextEditingController(text: '39.8262');
  DateTime _date = DateTime.now();
  PrayerTimes? _times;

  void _calculate() {
    final lat = double.tryParse(_latCtrl.text);
    final lng = double.tryParse(_lngCtrl.text);
    if (lat == null || lng == null) return;
    final coords = Coordinates(lat, lng);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    setState(() {
      _times = PrayerTimes(coords, DateComponents.from(_date), params);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.jm();
    return Scaffold(
      appBar: AppBar(title: const Text('Inflight Prayer Times')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Get prayer times for any location during travel.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _latCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Latitude', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _lngCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Longitude', border: OutlineInputBorder()),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Theme.of(context).dividerColor)),
            title: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2050),
                initialDate: _date,
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _calculate, child: const Text('Calculate')),
          const SizedBox(height: 24),
          if (_times != null) ...[
            for (final entry in <(String, DateTime)>[
              ('Fajr', _times!.fajr.toLocal()),
              ('Sunrise', _times!.sunrise.toLocal()),
              ('Dhuhr', _times!.dhuhr.toLocal()),
              ('Asr', _times!.asr.toLocal()),
              ('Maghrib', _times!.maghrib.toLocal()),
              ('Isha', _times!.isha.toLocal()),
            ])
              ListTile(
                title: Text(entry.$1),
                trailing: Text(fmt.format(entry.$2),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
          ],
        ],
      ),
    );
  }
}
