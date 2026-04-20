import 'package:adhan/adhan.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PrayerSettings {
  final CalculationMethod method;
  final Madhab madhab;
  const PrayerSettings({required this.method, required this.madhab});

  PrayerSettings copyWith({CalculationMethod? method, Madhab? madhab}) =>
      PrayerSettings(
        method: method ?? this.method,
        madhab: madhab ?? this.madhab,
      );
}

const calculationMethodLabels = <CalculationMethod, String>{
  CalculationMethod.muslim_world_league: 'Muslim World League',
  CalculationMethod.egyptian: 'Egyptian General Authority',
  CalculationMethod.karachi: 'University of Islamic Sciences, Karachi',
  CalculationMethod.umm_al_qura: 'Umm al-Qura, Makkah',
  CalculationMethod.dubai: 'Dubai',
  CalculationMethod.qatar: 'Qatar',
  CalculationMethod.kuwait: 'Kuwait',
  CalculationMethod.moon_sighting_committee: 'Moon Sighting Committee',
  CalculationMethod.singapore: 'Singapore',
  CalculationMethod.turkey: 'Diyanet, Turkey',
  CalculationMethod.tehran: 'Tehran',
  CalculationMethod.north_america: 'ISNA, North America',
  CalculationMethod.other: 'Other',
};

const madhabLabels = <Madhab, String>{
  Madhab.shafi: 'Shafi (and Maliki, Hanbali, Jafari)',
  Madhab.hanafi: 'Hanafi',
};

String _methodKey(CalculationMethod m) => m.toString().split('.').last;
CalculationMethod _methodFromKey(String key) =>
    CalculationMethod.values.firstWhere(
      (m) => _methodKey(m) == key,
      orElse: () => CalculationMethod.muslim_world_league,
    );

/// Region-aware default for first-time users.
/// Falls back to Muslim World League if the device locale has no country.
String _defaultMethodKeyForRegion() {
  try {
    final country =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    switch (country) {
      case 'US':
      case 'CA':
        return 'north_america'; // ISNA
      case 'SA':
        return 'umm_al_qura';
      case 'AE':
        return 'dubai';
      case 'QA':
        return 'qatar';
      case 'KW':
        return 'kuwait';
      case 'EG':
        return 'egyptian';
      case 'PK':
      case 'IN':
      case 'BD':
        return 'karachi';
      case 'SG':
      case 'MY':
      case 'ID':
        return 'singapore';
      case 'TR':
        return 'turkey';
      case 'IR':
        return 'tehran';
    }
  } catch (_) {}
  return 'muslim_world_league';
}

class PrayerSettingsNotifier extends StateNotifier<PrayerSettings> {
  final Box _box;
  PrayerSettingsNotifier(this._box) : super(_load(_box));

  static PrayerSettings _load(Box box) {
    final methodKey = box.get(
      'calc_method',
      defaultValue: _defaultMethodKeyForRegion(),
    ) as String;
    final madhabKey = box.get('madhab', defaultValue: 'shafi') as String;
    return PrayerSettings(
      method: _methodFromKey(methodKey),
      madhab: madhabKey == 'hanafi' ? Madhab.hanafi : Madhab.shafi,
    );
  }

  void setMethod(CalculationMethod m) {
    _box.put('calc_method', _methodKey(m));
    state = state.copyWith(method: m);
  }

  void setMadhab(Madhab m) {
    _box.put('madhab', m == Madhab.hanafi ? 'hanafi' : 'shafi');
    state = state.copyWith(madhab: m);
  }
}

final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsNotifier, PrayerSettings>((ref) {
  return PrayerSettingsNotifier(Hive.box('settings'));
});
