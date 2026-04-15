#!/usr/bin/env node
// Automated screenshot capture for Google Play Store listing.
//
// Captures phone, 7-inch tablet, and 10-inch tablet screenshots.
//
// Prerequisites:
//   1. Built web release:           flutter build web --release
//   2. Static server running:       cd build/web && python3 -m http.server 8080
//      (or use:  flutter run -d web-server --web-port=8080  for debug build)
//   3. Playwright installed:        npm install
//   4. Playwright chromium:         npx playwright install chromium
//
// Run:    node screenshots.js
// Output: scripts/screenshots/{phone,tablet7,tablet10}/*.png

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const URL = process.env.URL || 'http://localhost:8080';
const OUT_BASE = path.join(__dirname, 'screenshots');

const devices = [
  { name: 'phone', viewport: { width: 1080, height: 2400 } },     // Pixel 7
  { name: 'tablet7', viewport: { width: 1200, height: 1920 } },   // 7-inch
  { name: 'tablet10', viewport: { width: 1600, height: 2560 } },  // 10-inch
];

const routes = [
  { name: '01_home', hash: '/', delay: 4000 },
  { name: '02_surahs', hash: '/quran', delay: 2000 },
  { name: '03_reader_fatihah', hash: '/quran/surah/1', delay: 3000 },
  { name: '04_prayer_times', hash: '/prayer', delay: 4000 },
  { name: '05_qibla', hash: '/qibla', delay: 4000 },
  { name: '06_tasbeeh', hash: '/tasbeeh', delay: 1500 },
  { name: '07_dua', hash: '/dua', delay: 1500 },
  { name: '08_tajweed', hash: '/tajweed', delay: 1500 },
];

async function captureForDevice(browser, device) {
  const outDir = path.join(OUT_BASE, device.name);
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

  console.log(`\n=== ${device.name.toUpperCase()} (${device.viewport.width}x${device.viewport.height}) ===`);

  const context = await browser.newContext({
    viewport: device.viewport,
    deviceScaleFactor: 1,
    permissions: ['geolocation'],
    geolocation: { latitude: 42.2372, longitude: -70.9814 },
    locale: 'en-US',
  });
  const page = await context.newPage();

  console.log('→ initial load...');
  await page.goto(URL, { waitUntil: 'domcontentloaded', timeout: 60000 });
  await page.waitForTimeout(15000);
  await page.evaluate(() => {
    if (typeof removeSplashFromWeb === 'function') removeSplashFromWeb();
    document.getElementById('splash')?.remove();
    document.getElementById('splash-branding')?.remove();
  });
  await page.waitForTimeout(500);

  for (const r of routes) {
    await page.evaluate((h) => { window.location.hash = h; }, r.hash);
    await page.waitForTimeout(r.delay);
    const file = path.join(outDir, `${r.name}.png`);
    await page.screenshot({ path: file, fullPage: false });
    console.log(`  ${r.name}.png`);
  }

  await context.close();
}

async function main() {
  if (!fs.existsSync(OUT_BASE)) fs.mkdirSync(OUT_BASE, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  for (const d of devices) {
    await captureForDevice(browser, d);
  }
  await browser.close();
  console.log(`\nDone. All screenshots in ${OUT_BASE}/`);
}

main().catch(e => {
  console.error(e);
  process.exit(1);
});
