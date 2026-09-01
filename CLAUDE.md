# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project identity

**Tilawa** — Quran reader, prayer times, Qibla compass, and recitation feedback.

Branding (display name shown to users) is **Tilawa**, set in:
- `ios/Runner/Info.plist` → `CFBundleDisplayName`
- `android/app/src/main/AndroidManifest.xml` → `android:label`

The internal Flutter package and bundle ID are still `quran_app` / `com.nayeem.quran`.

App Store category: **Reference**. Android Play Store target: same package id.

## Common commands

```bash
# Install/update Flutter deps
flutter pub get

# Static analysis (run before claiming any change is done)
flutter analyze

# Unit tests
flutter test                                  # all
flutter test test/arabic_compare_test.dart    # one file

# Regenerate Drift database code (after schema changes)
dart run build_runner build --delete-conflicting-outputs

# Run on device/simulator
flutter run                                   # auto-pick
flutter run -d "iPhone 17 Pro Max"            # specific iOS sim

# iOS — verify before shipping
plutil -lint ios/Runner/Info.plist
plutil -lint ios/PrayerWidget/Info.plist
flutter build ios --debug --no-codesign --simulator

# Release builds for stores
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
flutter build appbundle --release             # needs ANDROID_HOME if not set

# Local install + launch on simulator (fast feedback loop)
xcrun simctl install booted build/ios/iphonesimulator/Runner.app
xcrun simctl launch booted com.nayeem.quran
```

If `flutter build appbundle` errors with "No Android SDK found", set:
```bash
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export ANDROID_SDK_ROOT=$ANDROID_HOME
```

## Verification protocol (important)

For any change that touches **iOS Info.plist, pbxproj, entitlements, AndroidManifest, or build.gradle**, run a simulator build (`flutter build ios --debug --no-codesign --simulator`) and confirm `xcrun simctl install booted` returns exit 0 before telling the user it's ready. Local Xcode install uses a stricter validator than `flutter build ipa` — broken extensions surface here first.

For Dart-only changes, `flutter analyze` is the floor; for risky logic, also run relevant tests.

## Architecture

**Riverpod + StateNotifier/FutureProvider** for all app state. `lib/data/providers.dart` exposes `surahsProvider`, `surahDetailProvider(int)`, `quranRepositoryProvider`. Hive boxes are opened in `lib/main.dart`: `settings`, `bookmarks`. The `bookmarks` box stores multiple key sets (bookmarks, verified ayahs, journey state) under different keys.

**Drift over SQLite** (`lib/data/database/database.dart`) holds Quran text + translations. The seed flow in `lib/data/repositories/quran_repository.dart` calls `ensureSeeded()` which loads from `assets/quran/quran-uthmani.json` + `assets/quran/quran-en-saheeh.json` if the table is empty (or under-seeded — threshold-based reseed for migrations).

**go_router** in `lib/core/router/app_router.dart` defines all routes. The home screen layout is in `lib/features/home/home_screen.dart` — a vertical ListView of cards (PrayerHeader → DuaOfDayCard → ReflectCard → FeatureGrid → JourneyCard a.k.a. Wird).

**Sakinah theme** (`lib/core/theme/app_theme.dart`) is the single source of design colors: deep indigo + warm gold + cream. Use `SakinahColors.indigoDeep`, `gold`, `goldSoft`, `cream` directly rather than `Theme.of(context)` colors so cards stay on-brand on both light and dark.

**Feature grid is categorized** (`lib/features/home/widgets/feature_grid.dart`) — four pills (Quran/Prayer/Learn/Tools) swap the visible tile set. To add a new feature, add a `FeatureItem` to the right `FeatureCategory` in that file. Keep the tile count honest: a tile that only links to another screen, or that leaves the app, counts against us under App Store guideline 4.3 rather than for us.

**Two distinct iOS targets** in `ios/Runner.xcodeproj/project.pbxproj`:
1. **Runner** — main Flutter app. Versions come from Flutter via `$(FLUTTER_BUILD_NUMBER)`/`$(FLUTTER_BUILD_NAME)` (defined in Generated.xcconfig).
2. **PrayerWidget** — WidgetKit extension. **Versions are hardcoded** because Flutter's xcconfig is not loaded for extensions, and they live in **four places that must all move together** when `pubspec.yaml` changes:
   1. `pubspec.yaml` → `version:` (currently `1.1.0+20`)
   2. `ios/Runner.xcodeproj/project.pbxproj` → `MARKETING_VERSION` in the **3** PrayerWidget configs (Debug/Release/Profile)
   3. the same 3 configs → `CURRENT_PROJECT_VERSION`
   4. `ios/PrayerWidget/Info.plist` → `CFBundleShortVersionString` and `CFBundleVersion`

   The fourth is easy to miss: the widget target sets **both** `GENERATE_INFOPLIST_FILE = YES` and `INFOPLIST_FILE = PrayerWidget/Info.plist`, so the version has two sources. Keep them identical rather than relying on which one wins. Get this wrong and `xcrun simctl install` fails with `IXErrorDomain Code 2 — Invalid placeholder attributes`, and App Store Connect rejects the upload for an app/extension `CFBundleVersion` mismatch.

   *Cleanup worth doing once iOS builds can be verified again:* drop `CFBundleShortVersionString`/`CFBundleVersion` from the widget's Info.plist entirely and let `GENERATE_INFOPLIST_FILE` supply them from the build settings, reducing four places to three. Do not attempt this without a working simulator install check.

   App Group `group.com.nayeem.quran` shares `next_prayer_*` keys via UserDefaults.

## Key feature modules

- **`lib/features/recite/`** — Ayah Check, the app's differentiator. Records audio with the `record` package via `recorder_controller.dart`, posts to the proxy in `server/` via `transcription_service.dart` (no key in the app), normalizes Arabic and word-diffs against expected text (`arabic_compare.dart`, fully unit-tested). API key lives in `lib/secrets.dart` (gitignored).
  - **Matching is order preserving.** `_align()` backtracks an LCS into a positional alignment and consumes each spoken word once. Do not "simplify" this to a `contains` check: that was the original bug, and it scored a backwards recitation and a single chanted word as 100%.
  - `compareAyah` scores one ayah; `comparePassage` scores a run of ayahs from a single take by aligning the whole passage then slicing per ayah, so a dropped ayah is blamed where it happened.
  - Auto-verification goes through `CheckResult.isVerifiable` (≥85% coverage **and** bounded unmatched speech), never a bare accuracy comparison.
  - `recite_history.dart` records every attempt and ranks a practice queue by `AyahStats.weakness` (recent score, plus staleness saturating at 30 days). Surfaced at `/recite/review`.
  - `/recite/passage/:id` is whole-surah recitation from memory with a range picker.
- **`lib/features/reflect/`** — Mood-based ayah discovery, the second differentiator. 14 moods × 5-6 curated verses in `reflect_data.dart`. **Only the reflection is authored there**; Arabic and the English translation come from the bundled database via `reflect_providers.dart`, so Reflect and the reader can never show different wording for the same ayah. Do not re-add hardcoded translations.
  - `reflect_journal.dart` lets a verse be saved with a personal note, keyed by mood **and** verse, so the same ayah saved under two moods stays two entries. Surfaced at `/reflect/journal`.
  - `test/reflect_data_test.dart` validates every reference against `assets/quran/quran-en-saheeh.json`, so a typo'd surah:ayah fails the suite rather than shipping. It also guards the `/reflect/journal` versus `/reflect/:moodId` route ordering.
- **`lib/features/journey/`** — "Wird" daily Quran portion tracker. Stores per-day ayah views in Hive (keys `ayahs_YYYY-MM-DD` and `viewed_YYYY-MM-DD_surah:ayah`), computes streaks. Recorded automatically in `reader_screen.dart` when an ayah scrolls past center.
- **`lib/features/notifications/`** — Adhan alarms + streak reminders via `flutter_local_notifications`. Notification id 201 is the daily streak reminder.
- **`lib/features/widget/widget_updater.dart`** — Pushes next-prayer name/time/countdown into shared UserDefaults so the iOS widget + Android AppWidget can render without launching the app.

## Region-aware defaults

`lib/features/settings/prayer_settings.dart` → `_defaultMethodKeyForRegion()` picks the calculation method based on locale: ISNA for US/CA, umm_al_qura for SA, karachi for PK/IN/BD, etc. Don't hardcode a single default.

## Secrets

**The app ships no API key.** Ayah Check posts recordings to the transcription
proxy in `server/`, which holds the Deepgram credential in its own environment.
See `server/README.md`.

`lib/secrets.dart` is gitignored and is now **unused** by `lib/`; it survives
only as a local copy of the key for reference. Nothing imports it, and a build
scan confirms the key string does not appear in the produced binary. If you add
a secret back into the client, you have reintroduced the original problem: an
extractable key that cannot be rotated without an app update.

The proxy URL in `lib/core/config/app_config.dart` is **not** a secret and is
committed. Override per build with `--dart-define=TILAWA_API_BASE=...`.

## App Store guideline 4.3 (Spam) posture

The app was rejected once as spam. A Quran reader, prayer times, Qibla, tasbeeh, duas, 99 Names, zakat and a mosque finder are table stakes and argue *against* us; the case rests on Ayah Check (automated recitation scoring, the practice queue, whole-passage recitation) and Reflect (original mood-to-ayah editorial). Deliberately removed, do not reintroduce:

- **Academy** — a menu listing screens already on the home grid.
- **Makkah/Madinah Live** — tiles that only `launchUrl`'d to a YouTube search.
- **Inflight** — raw lat/long entry, now folded into Prayer Times as a location override (`lib/features/prayer/location_override.dart` + `place_search.dart`, Nominatim lookup) with a date picker.
- **`placeholder_screen.dart`** — a "coming soon" screen in a shipped binary.

Tafsir is bundled for Al-Fatihah only, so `reader_screen.dart` shows the tafsir button **only** where `tafsirFor()` returns entries. Never restore an empty state that tells users to go to another site.

## App Store / Play Store publishing

- Apple Developer: amworkspace@outlook.com, Team `YRNCX5ACVU`
- Bundle: `com.nayeem.quran` (Runner), `com.nayeem.quran.PrayerWidget`, `com.nayeem.quran.RunnerTests`
- iPhone-only target (`TARGETED_DEVICE_FAMILY = "1"` in pbxproj). iPad screenshots are not required for submission.
- Privacy answer: **No data collected**. Audio for Ayah Check leaves the device for transcription but is not retained — declared in App Privacy.
- Apple Developer account: sudomakeit25 GitHub for the public source repo (`https://github.com/sudomakeit25/quran-app`).

When publishing iOS: use Transporter to upload the IPA from `build/ios/ipa/quran_app.ipa`. The CFBundleVersion mismatch error means PrayerWidget pbxproj wasn't updated to match `pubspec.yaml`.
