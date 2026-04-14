import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/academy/academy_screen.dart';
import '../../features/dua/dua_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/inflight/inflight_screen.dart';
import '../../features/live/live_screen.dart';
import '../../features/prayer/prayer_screen.dart';
import '../../features/qibla/qibla_screen.dart';
import '../../features/quran/reader/reader_screen.dart';
import '../../features/quran/reader/surah_list_screen.dart';
import '../../features/settings/about_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/tajweed/tajweed_screen.dart';
import '../../features/tasbeeh/tasbeeh_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/quran', builder: (c, s) => const SurahListScreen()),
      GoRoute(
        path: '/quran/surah/:id',
        builder: (c, s) => ReaderScreen(surahId: int.parse(s.pathParameters['id']!)),
      ),
      GoRoute(path: '/prayer', builder: (c, s) => const PrayerScreen()),
      GoRoute(path: '/qibla', builder: (c, s) => const QiblaScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      GoRoute(path: '/about', builder: (c, s) => const AboutScreen()),
      GoRoute(path: '/dua', builder: (c, s) => const DuaScreen()),
      GoRoute(path: '/academy', builder: (c, s) => const AcademyScreen()),
      GoRoute(path: '/inflight', builder: (c, s) => const InflightScreen()),
      GoRoute(path: '/tasbeeh', builder: (c, s) => const TasbeehScreen()),
      GoRoute(path: '/tajweed', builder: (c, s) => const TajweedScreen()),
      GoRoute(
        path: '/makkah',
        builder: (c, s) => const LiveScreen(
          title: 'Makkah Live',
          embedUrl:
              'https://www.youtube.com/embed/live_stream?channel=UCxQbYGpbdrh-b2ND-AfIybg',
          watchUrl:
              'https://www.youtube.com/channel/UCxQbYGpbdrh-b2ND-AfIybg/live',
          icon: Icons.location_city,
          accent: Color(0xFF1F2937),
        ),
      ),
      GoRoute(
        path: '/madinah',
        builder: (c, s) => const LiveScreen(
          title: 'Madinah Live',
          embedUrl:
              'https://www.youtube.com/embed/live_stream?channel=UC8gZmkWUTwxMu1nUaJ_jLBA',
          watchUrl:
              'https://www.youtube.com/channel/UC8gZmkWUTwxMu1nUaJ_jLBA/live',
          icon: Icons.mosque,
          accent: Color(0xFF059669),
        ),
      ),
    ],
  );
});
