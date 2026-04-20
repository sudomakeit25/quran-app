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

  Future<void> _openInYouTube() async {
    // Try YouTube app first (via its custom scheme), fall back to browser.
    final appUri = Uri.parse(watchUrl.replaceFirst('https://', 'youtube://'));
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
      return;
    }
    await launchUrl(
      Uri.parse(watchUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accent, accent.withValues(alpha: 0.6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 80),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '24/7 live stream from the Holy Mosque',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _openInYouTube,
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Watch on YouTube',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Opens the YouTube app or browser.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
