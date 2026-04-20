import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/academy/academy_screen.dart';
import '../../features/dua/dua_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/inflight/inflight_screen.dart';
import '../../features/live/live_screen.dart';
import '../../features/audio/reciter_picker_screen.dart';
import '../../features/hadith/hadith_screen.dart';
import '../../features/mosques/mosque_finder_screen.dart';
import '../../features/names/names_screen.dart';
import '../../features/ramadan/ramadan_screen.dart';
import '../../features/notifications/notifications_settings.dart';
import '../../features/tracker/tracker_screen.dart';
import '../../features/zakat/zakat_screen.dart';
import '../../features/prayer/prayer_screen.dart';
import '../../features/qibla/qibla_screen.dart';
import '../../features/quran/bookmarks/bookmarks_screen.dart';
import '../../features/quran/reader/reader_screen.dart';
import '../../features/quran/reader/surah_list_screen.dart';
import '../../features/quran/search/search_screen.dart';
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
        builder: (c, s) {
          final ayahParam = s.uri.queryParameters['ayah'];
          return ReaderScreen(
            surahId: int.parse(s.pathParameters['id']!),
            jumpToAyah: ayahParam == null ? null : int.tryParse(ayahParam),
          );
        },
      ),
      GoRoute(path: '/bookmarks', builder: (c, s) => const BookmarksScreen()),
      GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
      GoRoute(path: '/names', builder: (c, s) => const NamesScreen()),
      GoRoute(path: '/zakat', builder: (c, s) => const ZakatScreen()),
      GoRoute(path: '/tracker', builder: (c, s) => const TrackerScreen()),
      GoRoute(path: '/notifications', builder: (c, s) => const NotificationsScreen()),
      GoRoute(path: '/reciter', builder: (c, s) => const ReciterPickerScreen()),
      GoRoute(path: '/ramadan', builder: (c, s) => const RamadanScreen()),
      GoRoute(path: '/mosques', builder: (c, s) => const MosqueFinderScreen()),
      GoRoute(path: '/hadith', builder: (c, s) => const HadithScreen()),
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
          // Search YouTube filtered to currently-live results.
          // sp=EgJAAQ%3D%3D filters by "Live now".
          embedUrl: 'https://www.youtube.com/results?search_query=makkah+live+haram&sp=EgJAAQ%3D%3D',
          watchUrl: 'https://www.youtube.com/results?search_query=makkah+live+haram&sp=EgJAAQ%3D%3D',
          icon: Icons.location_city,
          accent: Color(0xFF1F2937),
        ),
      ),
      GoRoute(
        path: '/madinah',
        builder: (c, s) => const LiveScreen(
          title: 'Madinah Live',
          embedUrl: 'https://www.youtube.com/results?search_query=madinah+live+nabawi&sp=EgJAAQ%3D%3D',
          watchUrl: 'https://www.youtube.com/results?search_query=madinah+live+nabawi&sp=EgJAAQ%3D%3D',
          icon: Icons.mosque,
          accent: Color(0xFF059669),
        ),
      ),
    ],
  );
});
