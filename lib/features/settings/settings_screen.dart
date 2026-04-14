import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Calculation method'),
            subtitle: Text('Determines prayer time formulas'),
            trailing: Text('Muslim World League'),
          ),
          const ListTile(
            title: Text('Madhab'),
            subtitle: Text('Affects Asr time calculation'),
            trailing: Text('Shafi'),
          ),
          const ListTile(
            title: Text('Translation'),
            subtitle: Text('English translation in the reader'),
            trailing: Text('Saheeh International'),
          ),
          const ListTile(
            title: Text('Theme'),
            trailing: Text('System'),
          ),
          const Divider(),
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
}
