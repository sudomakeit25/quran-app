import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/ui_settings.dart';
import 'prayer_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(prayerSettingsProvider);
    final notifier = ref.read(prayerSettingsProvider.notifier);
    final ui = ref.watch(uiSettingsProvider);
    final uiNotifier = ref.read(uiSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Prayer'),
          ListTile(
            title: const Text('Calculation method'),
            subtitle: const Text('Determines Fajr and Isha angles'),
            trailing: Text(
              calculationMethodLabels[settings.method] ?? 'Unknown',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.right,
            ),
            onTap: () => _pickMethod(context, settings.method, notifier.setMethod),
          ),
          ListTile(
            title: const Text('Madhab'),
            subtitle: const Text('Affects Asr time calculation'),
            trailing: Text(
              settings.madhab == Madhab.hanafi ? 'Hanafi' : 'Shafi',
            ),
            onTap: () => _pickMadhab(context, settings.madhab, notifier.setMadhab),
          ),
          const Divider(),
          const _SectionHeader('Appearance'),
          ListTile(
            title: const Text('Theme'),
            trailing: Text(_themeLabel(ui.themeMode)),
            onTap: () => _pickTheme(context, ui.themeMode, uiNotifier.setThemeMode),
          ),
          SwitchListTile(
            title: const Text('Show transliteration'),
            subtitle: const Text(
                'Display Roman-letter pronunciation under each ayah (available for Al-Fatihah)'),
            value: ui.showTransliteration,
            onChanged: uiNotifier.setShowTransliteration,
          ),
          ListTile(
            title: const Text('Arabic font size'),
            subtitle: Slider(
              value: ui.arabicFontSize,
              min: 18,
              max: 40,
              divisions: 22,
              label: ui.arabicFontSize.round().toString(),
              onChanged: uiNotifier.setArabicFontSize,
            ),
            trailing: Text(
              ui.arabicFontSize.round().toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          const _SectionHeader('Content'),
          const ListTile(
            title: Text('Translation'),
            subtitle: Text('English translation in the reader'),
            trailing: Text('Saheeh International'),
          ),
          ListTile(
            title: const Text('Reciter'),
            subtitle: const Text('Voice used for Quran recitation'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/reciter'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Adhan, daily ayah reminder'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/notifications'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About & Credits'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about'),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Future<void> _pickTheme(
    BuildContext context,
    ThemeMode current,
    void Function(ThemeMode) onPick,
  ) async {
    final picked = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Theme'),
        children: [
          for (final m in ThemeMode.values)
            RadioListTile<ThemeMode>(
              title: Text(_themeLabel(m)),
              value: m,
              groupValue: current,
              onChanged: (v) => Navigator.pop(ctx, v),
            ),
        ],
      ),
    );
    if (picked != null) onPick(picked);
  }

  Future<void> _pickMethod(
    BuildContext context,
    CalculationMethod current,
    void Function(CalculationMethod) onPick,
  ) async {
    final picked = await showDialog<CalculationMethod>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Calculation method'),
        children: [
          for (final entry in calculationMethodLabels.entries)
            RadioListTile<CalculationMethod>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: current,
              onChanged: (v) => Navigator.pop(ctx, v),
            ),
        ],
      ),
    );
    if (picked != null) onPick(picked);
  }

  Future<void> _pickMadhab(
    BuildContext context,
    Madhab current,
    void Function(Madhab) onPick,
  ) async {
    final picked = await showDialog<Madhab>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Madhab'),
        children: [
          for (final entry in madhabLabels.entries)
            RadioListTile<Madhab>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: current,
              onChanged: (v) => Navigator.pop(ctx, v),
            ),
        ],
      ),
    );
    if (picked != null) onPick(picked);
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
