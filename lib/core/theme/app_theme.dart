import 'package:flutter/material.dart';

class SakinahColors {
  static const indigoDeep = Color(0xFF1E1B4B);
  static const indigoNight = Color(0xFF0F0E2E);
  static const indigoSoft = Color(0xFF2D2A6E);
  static const gold = Color(0xFFD4AF37);
  static const goldSoft = Color(0xFFF5D98A);
  static const cream = Color(0xFFFAF6E8);
  static const creamText = Color(0xFFF5EFD6);
  static const muted = Color(0xFFB8B5C7);
}

class AppTheme {
  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? SakinahColors.goldSoft : SakinahColors.indigoDeep,
      onPrimary: isDark ? SakinahColors.indigoNight : SakinahColors.cream,
      secondary: SakinahColors.gold,
      onSecondary: SakinahColors.indigoNight,
      tertiary: SakinahColors.indigoSoft,
      onTertiary: SakinahColors.creamText,
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      surface: isDark ? SakinahColors.indigoNight : SakinahColors.cream,
      onSurface: isDark ? SakinahColors.creamText : SakinahColors.indigoDeep,
      surfaceContainerHighest: isDark ? SakinahColors.indigoDeep : const Color(0xFFEDE7D0),
      surfaceContainerHigh: isDark ? SakinahColors.indigoSoft : const Color(0xFFEDE7D0),
      surfaceContainer: isDark ? const Color(0xFF171545) : const Color(0xFFF2EDD9),
      outline: isDark ? SakinahColors.indigoSoft : const Color(0xFFD9D3BE),
      outlineVariant: isDark ? const Color(0xFF3A3780) : const Color(0xFFE3DDC4),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: null,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.secondary,
        textColor: scheme.onSurface,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: scheme.onSurface, letterSpacing: 0.2),
        headlineLarge: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700, letterSpacing: 0.15),
        headlineMedium: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600, letterSpacing: 0.15),
        titleMedium: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: scheme.onSurface, height: 1.5),
        bodyMedium: TextStyle(color: scheme.onSurface, height: 1.45),
        labelLarge: TextStyle(color: scheme.secondary, fontWeight: FontWeight.w600, letterSpacing: 0.8),
      ),
      iconTheme: IconThemeData(color: scheme.secondary),
    );
  }
}
