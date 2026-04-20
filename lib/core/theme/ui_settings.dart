import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class UiSettings {
  final ThemeMode themeMode;
  final double arabicFontSize;
  final bool showTransliteration;

  const UiSettings({
    required this.themeMode,
    required this.arabicFontSize,
    required this.showTransliteration,
  });

  UiSettings copyWith({
    ThemeMode? themeMode,
    double? arabicFontSize,
    bool? showTransliteration,
  }) =>
      UiSettings(
        themeMode: themeMode ?? this.themeMode,
        arabicFontSize: arabicFontSize ?? this.arabicFontSize,
        showTransliteration: showTransliteration ?? this.showTransliteration,
      );
}

class UiSettingsNotifier extends StateNotifier<UiSettings> {
  final Box _box;
  UiSettingsNotifier(this._box) : super(_load(_box));

  static UiSettings _load(Box box) {
    final modeName = box.get('theme_mode', defaultValue: 'system') as String;
    final size = (box.get('arabic_font_size', defaultValue: 26.0) as num)
        .toDouble();
    final translit =
        box.get('show_transliteration', defaultValue: false) as bool;
    return UiSettings(
      themeMode: _parseMode(modeName),
      arabicFontSize: size,
      showTransliteration: translit,
    );
  }

  static ThemeMode _parseMode(String name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _modeName(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _box.put('theme_mode', _modeName(mode));
  }

  void setArabicFontSize(double size) {
    state = state.copyWith(arabicFontSize: size);
    _box.put('arabic_font_size', size);
  }

  void setShowTransliteration(bool v) {
    state = state.copyWith(showTransliteration: v);
    _box.put('show_transliteration', v);
  }
}

final uiSettingsProvider =
    StateNotifierProvider<UiSettingsNotifier, UiSettings>((ref) {
  return UiSettingsNotifier(Hive.box('settings'));
});
