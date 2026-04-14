# Quran App

Flutter app for Quran reading, recitation, translations, prayer times, and qibla.

## Setup

### 1. Install Flutter

```bash
brew install --cask flutter
flutter doctor
```

Follow `flutter doctor` instructions to install Xcode (iOS) and Android Studio (Android) toolchains.

### 2. Install dependencies

```bash
cd ~/quran-app
flutter pub get
```

### 3. Generate Drift database code

```bash
dart run build_runner build --delete-conflicting-outputs
```

This produces `lib/data/database/database.g.dart`. Re-run whenever you change the schema.

### 4. Add data assets (optional for first run)

Download these into `assets/` before first run:

- `assets/fonts/UthmanicHafs.ttf` — KFGQPC Uthmanic Hafs font from https://fonts.qurancomplex.gov.sa/ (without this, Arabic falls back to system font)
- (later) Replace `lib/data/seed/sample_ayahs.dart` with full Quran from https://tanzil.net/download/

The bundled sample includes Al-Fatihah only. All 114 surah names are pre-populated.

### 5. Run

```bash
flutter run                      # auto-pick connected device
flutter run -d "iPhone 15"       # specific iOS simulator
flutter run -d emulator-5554     # specific Android emulator
```

## Project structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/        Material 3 theme
│   ├── router/       go_router with bottom-nav shell
│   └── localization/ (TODO) i18n
├── data/
│   ├── models/       Ayah, Surah, Translation
│   ├── repositories/ QuranRepository, PrayerRepository
│   └── sources/      Local SQLite + remote audio
└── features/
    ├── quran/        Reader, surah list, search, bookmarks
    ├── audio/        Playback service (just_audio + audio_service)
    ├── prayer/       Prayer times list (local calc via adhan)
    ├── qibla/        Compass + bearing to Mecca
    └── settings/     Method, madhab, reciter, theme
```

## Roadmap

### MVP
- [x] Project scaffold
- [ ] Bundle Uthmani SQLite + Drift schema
- [ ] Reader: render Arabic ayahs + 1 translation
- [ ] Audio: 1 reciter, verse-by-verse with highlight
- [ ] Prayer times: notifications with adhan
- [ ] Qibla: compass-based direction
- [ ] Bookmarks + last-read

### V1
- [ ] Multiple translations and reciters
- [ ] Audio download for offline
- [ ] Tafsir
- [ ] Search across Arabic + translations
- [ ] Tasbih counter, daily duas
- [ ] Multi-language UI
