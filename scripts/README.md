# Screenshot automation

Captures Play Store–sized screenshots of the running Flutter web app.

## One-time setup

```bash
cd scripts
npm install
npx playwright install chromium
```

## Usage

Open two terminals.

**Terminal 1** — start the Flutter web server:

```bash
cd ~/quran-app
flutter run -d web-server --web-port=8080
# leave running
```

**Terminal 2** — run the screenshot script:

```bash
cd ~/quran-app/scripts
node screenshots.js
```

Output: `scripts/screenshots/*.png` at 1080×2400 (Pixel 7 portrait), ready to upload to Google Play Console.

## Customize

- `URL=http://localhost:8080 node screenshots.js` — point to a different server
- Edit `VIEWPORT` in `screenshots.js` for different device sizes
- Edit the `routes` array to add/remove screens
- Change `geolocation` to set a specific mock location for the prayer times screens
