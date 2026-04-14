import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About & Credits')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(context, 'Quran Text & Translation', [
            _bullet('Arabic (Uthmani) text from Tanzil Project, served via the alquran.cloud API.'),
            _bullet('English translation by Saheeh International, used with attribution per their public license.'),
          ]),
          _section(context, 'Fonts', [
            _bullet('Amiri Quran font by Khaled Hosny, licensed under the SIL Open Font License.'),
          ]),
          _section(context, 'Prayer Times', [
            _bullet('Calculated locally using the adhan-dart library by Batoul Apps.'),
            _bullet('Hijri date conversion via the hijri Dart package.'),
          ]),
          _section(context, 'Live Streams', [
            _bullet('Makkah and Madinah live streams hosted by their official Saudi Government channels on YouTube.'),
          ]),
          _section(context, 'Open Source', [
            _bullet('Built with Flutter, Drift, Riverpod, and other open-source libraries. See LICENSES for details.'),
          ]),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => launchUrl(Uri.parse(
                'https://github.com/YOUR_USERNAME/quran-app/blob/main/PRIVACY_POLICY.md')),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            trailing: const Text('0.1.0'),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '© 2026 — Made with ♥',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...items,
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
