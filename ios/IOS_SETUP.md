# iOS setup checklist

Complete these **once** after installing Xcode. Everything below is one-time setup.

## Prerequisites

- Xcode installed from Mac App Store
- `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- Opened Xcode once, accepted license, let it install extra components
- Signed into Xcode with your Apple ID: Xcode → Settings → Accounts → + → Apple ID
- Your Apple Developer Program membership is active (otherwise you can only run on simulator/your own device, not ship to App Store)

## 1. Open the workspace

From the project root:

```bash
open ios/Runner.xcworkspace
```

Use the **.xcworkspace**, not the .xcodeproj — CocoaPods needs the workspace.

## 2. Set development team on Runner

1. In the left navigator, click **Runner** (project root, blue icon)
2. Select the **Runner** target (under TARGETS)
3. Go to **Signing & Capabilities** tab
4. **Automatically manage signing**: check it
5. **Team**: pick your team from the dropdown
6. **Bundle Identifier**: should already be `dev.nayeem.quran` — if it conflicts with an existing app on your account, change it

## 3. Add the PrayerWidget target

The widget files are already in `ios/PrayerWidget/` but Xcode needs to know about them.

1. **File → New → Target…**
2. Pick **Widget Extension** under iOS → Application Extension
3. Click **Next**
4. Product Name: `PrayerWidget`
5. Team: same team as Runner
6. Language: **Swift**
7. Uncheck "Include Configuration Intent" (we use StaticConfiguration)
8. Click **Finish**
9. When prompted to activate the scheme, click **Activate**

Xcode will create its own PrayerWidget files. **Replace them with the ones already in `ios/PrayerWidget/`**:

- Right-click the generated `PrayerWidget.swift`, Delete → **Move to Trash**
- Right-click the generated `Info.plist` in the PrayerWidget group, Delete → **Move to Trash**
- Drag `ios/PrayerWidget/PrayerWidget.swift` and `ios/PrayerWidget/Info.plist` from Finder into the PrayerWidget group in Xcode's navigator
  - "Copy items if needed": UNCHECK
  - Add to targets: check **PrayerWidget only** (NOT Runner)

## 4. Add App Group capability on BOTH targets

This lets Flutter (Runner) and the widget (PrayerWidget) share the next-prayer data.

For **Runner**:
1. Select Runner target → Signing & Capabilities
2. Click **+ Capability** → **App Groups**
3. Click **+** under App Groups → add `group.com.nayeem.quran`
4. Xcode may ask to sign in / accept — let it

For **PrayerWidget**:
1. Select PrayerWidget target → Signing & Capabilities
2. Click **+ Capability** → **App Groups**
3. Check the same `group.com.nayeem.quran` group

## 5. Entitlements files

Xcode usually creates these automatically when you add App Groups. If not:

- Runner target → Build Settings → search "Code Signing Entitlements" → set to `Runner/Runner.entitlements`
- PrayerWidget target → Build Settings → "Code Signing Entitlements" → `PrayerWidget/PrayerWidget.entitlements`

Both files already exist in the project with the correct contents.

## 6. Verify build

Back in the terminal:

```bash
flutter build ios --release --no-codesign
```

Should succeed. If it fails, most common fixes:
- Run `cd ios && pod install && cd ..` then retry
- In Xcode, clean build folder: Shift+Cmd+K

## 7. Build the archive for App Store

```bash
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

**First:** open `ios/ExportOptions.plist` and replace `REPLACE_WITH_YOUR_TEAM_ID` with your actual 10-character Team ID. Find it at Xcode → Settings → Accounts → (your Apple ID) → Manage Certificates → look at certificate details, or at https://developer.apple.com/account → Membership.

Output: `build/ios/ipa/quran_app.ipa`

## 8. Upload to App Store Connect

Easiest: use **Transporter** (free Mac App Store app). Open it → drag the `.ipa` → Deliver.

Or via Xcode: Window → Organizer → Archives → select the archive → Distribute App.

Once uploaded, it shows up in App Store Connect → TestFlight within ~15 minutes, ready for TestFlight users or submission to the App Store.

## Troubleshooting

- **"No signing certificate found"**: In Xcode → Signing & Capabilities, click "Manage Signing" and let it generate one. Requires Apple Developer Program membership.
- **"Provisioning profile doesn't include … App Group"**: You added the capability but Xcode didn't regenerate the profile. Click the refresh arrow next to the profile name, or toggle automatic signing off/on.
- **Widget doesn't show data on home screen**: Open the Flutter app once to push data into the shared UserDefaults. Then long-press the home screen to add the widget.
- **`pod install` fails**: `cd ios && pod repo update && pod install` — CocoaPods spec repo is stale.
