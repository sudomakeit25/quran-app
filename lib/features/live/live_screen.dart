import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'web_iframe_stub.dart' if (dart.library.js_interop) 'web_iframe.dart';

class LiveScreen extends StatelessWidget {
  final String title;
  final String embedUrl;
  final String watchUrl;
  final IconData icon;
  final Color accent;

  const LiveScreen({
    super.key,
    required this.title,
    required this.embedUrl,
    required this.watchUrl,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Open in YouTube',
            onPressed: () => launchUrl(Uri.parse(watchUrl)),
          ),
        ],
      ),
      body: kIsWeb
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: WebIframe(url: embedUrl),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: accent,
                      child: Icon(icon, color: Colors.white, size: 60),
                    ),
                    const SizedBox(height: 24),
                    Text(title,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => launchUrl(Uri.parse(watchUrl)),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Watch on YouTube'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
