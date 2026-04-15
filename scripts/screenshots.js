#!/usr/bin/env node
// Automated screenshot capture for Google Play Store listing.
//
// Prerequisites:
//   1. Flutter web server running:  flutter run -d web-server --web-port=8080
//   2. Playwright installed:        npm install playwright
//   3. Playwright chromium:         npx playwright install chromium
//
// Run:    node scripts/screenshots.js
// Output: scripts/screenshots/*.png (Pixel 7 dimensions, 1080x2400)

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const URL = process.env.URL || 'http://localhost:8080';
const OUT = path.join(__dirname, 'screenshots');
const VIEWPORT = { width: 1080, height: 2400 };

// Each navigation happens in-app (via hash change) so we don't re-trigger the
// Flutter splash screen. Only the first navigation is a full page load.
const routes = [
  { name: '01_home', hash: '/', delay: 4000 },
  { name: '02_surahs', hash: '/quran', delay: 2000 },
  { name: '03_reader_fatihah', hash: '/quran/surah/1', delay: 3000 },
  { name: '04_prayer_times', hash: '/prayer', delay: 6000 },
  { name: '05_qibla', hash: '/qibla', delay: 5000 },
  { name: '06_tasbeeh', hash: '/tasbeeh', delay: 1500 },
  { name: '07_dua', hash: '/dua', delay: 1500 },
  { name: '08_tajweed', hash: '/tajweed', delay: 1500 },
];

async function main() {
  if (!fs.existsSync(OUT)) fs.mkdirSync(OUT, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: VIEWPORT,
    deviceScaleFactor: 1,
    permissions: ['geolocation'],
    geolocation: { latitude: 42.2372, longitude: -70.9814 },
    locale: 'en-US',
  });
  const page = await context.newPage();

  // Initial load — wait long enough for Flutter to boot, splash to pass,
  // database to seed, and the home screen to render.
  console.log('→ initial load...');
  await page.goto(URL, { waitUntil: 'domcontentloaded', timeout: 60000 });
  console.log('  waiting 15s for Flutter initialization + DB seed...');
  await page.waitForTimeout(15000);
  // Remove the web splash screen overlay (flutter_native_splash doesn't auto-remove on web)
  await page.evaluate(() => {
    if (typeof removeSplashFromWeb === 'function') removeSplashFromWeb();
    document.getElementById('splash')?.remove();
    document.getElementById('splash-branding')?.remove();
  });
  await page.waitForTimeout(500);

  for (const r of routes) {
    console.log(`→ ${r.name}  (#${r.hash})`);
    // In-app hash-based navigation (go_router) — no full page reload, no splash
    await page.evaluate((h) => {
      window.location.hash = h;
    }, r.hash);
    await page.waitForTimeout(r.delay);
    const file = path.join(OUT, `${r.name}.png`);
    await page.screenshot({ path: file, fullPage: false });
    console.log(`  saved ${path.basename(file)}`);
  }

  await browser.close();
  console.log(`\nDone. Screenshots in ${OUT}/`);
}

main().catch(e => {
  console.error(e);
  process.exit(1);
});
