import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  static const _dhikrs = [
    ('SubhanAllah', 'سُبْحَانَ ٱللَّٰه', 33),
    ('Alhamdulillah', 'ٱلْحَمْدُ لِلَّٰه', 33),
    ('Allahu Akbar', 'ٱللَّٰهُ أَكْبَر', 34),
    ('La ilaha illa Allah', 'لَا إِلَٰهَ إِلَّا ٱللَّٰه', 100),
    ('Astaghfirullah', 'أَسْتَغْفِرُ ٱللَّٰه', 100),
  ];

  late Box _box;
  int _index = 0;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('settings');
    _index = _box.get('tasbeeh_index', defaultValue: 0) as int;
    _count = _box.get('tasbeeh_count_$_index', defaultValue: 0) as int;
  }

  void _increment() {
    HapticFeedback.lightImpact();
    setState(() {
      _count++;
      _box.put('tasbeeh_count_$_index', _count);
    });
    final target = _dhikrs[_index].$3;
    if (_count == target) HapticFeedback.mediumImpact();
  }

  void _reset() {
    setState(() {
      _count = 0;
      _box.put('tasbeeh_count_$_index', 0);
    });
  }

  void _select(int i) {
    setState(() {
      _index = i;
      _box.put('tasbeeh_index', i);
      _count = _box.get('tasbeeh_count_$i', defaultValue: 0) as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    final (name, arabic, target) = _dhikrs[_index];
    final progress = target == 0 ? 0.0 : (_count % target) / target;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbeeh'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reset),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Text(arabic,
              style: const TextStyle(
                  fontFamily: 'UthmanicHafs', fontSize: 36, height: 1.6)),
          const SizedBox(height: 4),
          Text(name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          const Spacer(),
          GestureDetector(
            onTap: _increment,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$_count',
                          style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('Target: $target',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 64,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _dhikrs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == _index;
                return ChoiceChip(
                  label: Text(_dhikrs[i].$1),
                  selected: selected,
                  onSelected: (_) => _select(i),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
