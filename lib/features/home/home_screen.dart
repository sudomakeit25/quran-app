import 'package:flutter/material.dart';

import 'widgets/feature_grid.dart';
import 'widgets/journey_card.dart';
import 'widgets/prayer_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          PrayerHeader(),
          SizedBox(height: 16),
          FeatureGrid(),
          SizedBox(height: 24),
          JourneyCard(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
