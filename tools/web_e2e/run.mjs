// The web client's journey (journey.mjs) in headless Chrome and Firefox, then on a throttled phone in Chrome's device
// emulation, against photolibd serving the built app under its policy: `node tools/web_e2e/run.mjs`.
//
// It builds what is not given: the app (`WEB_DIR`: `flutter build web --wasm` with its store, workers and kernel, as
// tools/web_requests.py does), photolibd (`PHOTOLIBD`) and the directory of an FFmpeg that encodes H.264 (`FFMPEG_DIR`,
// by default tools/video/ffmpeg.sh's). `CHROME_EXECUTABLE` picks Chrome; Playwright (tools/playwright.sh) fetches its Firefox on
// first use. `PLAYWRIGHT_DIR` names a Playwright library to use instead of the pinned one.
// `WEB_E2E_ONLY` (chromium, firefox, webkit, phone, comma-separated) runs those alone. Screenshots and downloads go to `WEB_E2E_OUT` (default: a temporary directory, printed). Exit status 1 when a step fails.
import { mkdirSync, mkdtempSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { journey } from './journey.mjs';
import { clip, png, startServer } from './lib.mjs';
import { build, chromium, devices, firefox, launch, webkit } from './setup.mjs';

const failures = [];

/** One browser's journey on a server of its own. */
async function visit(name, type, built, { mobile = false } = {}) {
  const title = mobile ? `${name} on a throttled phone` : name;
  const out = join(process.env.WEB_E2E_OUT ?? mkdtempSync(join(tmpdir(), 'photolib-e2e-out-')), title.replaceAll(' ', '-'));
  mkdirSync(out, { recursive: true });
  const photos = [1, 2].map((seed) => {
    const file = join(out, `up${seed}-${1_700_000_000_000 + seed}.png`);
    writeFileSync(file, png(seed));
    return file;
  });
  const video = mobile ? null : clip(out, built.ffmpegDir, `clip-${1_700_000_001_000}.mp4`);
  if (!mobile && !video) console.log(`note: ${built.ffmpegDir}/ffmpeg encodes no H.264, so the video step is skipped`);
  const server = await startServer(built);
  const browser = await launch(type, name);
  try {
    const context = await browser.newContext(
      // A phone's screen, pixel ratio and touch; not its user agent, whose mobile build of Flutter's accessibility switch
      // wants a screen reader's double tap, which no script makes.
      mobile
        ? { ...devices['Pixel 7'], userAgent: `Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${browser.version()} Safari/537.36` }
        : { viewport: { width: 1280, height: 800 } },
    );
    const page = await context.newPage();
    if (mobile) {
      const cdp = await context.newCDPSession(page);
      await cdp.send('Emulation.setCPUThrottlingRate', { rate: 4 });
      // A slow 4G connection: 1.6 Mbit/s down, 750 kbit/s up, 150 ms round trip.
      await cdp.send('Network.emulateNetworkConditions', { offline: false, latency: 150, downloadThroughput: (1.6 * 1024 * 1024) / 8, uploadThroughput: (750 * 1024) / 8 });
    }
    const started = Date.now();
    const step = async (what, work) => {
      const began = Date.now();
      try {
        await work();
        console.log(`ok: ${title}: ${what} (${((Date.now() - began) / 1000).toFixed(1)} s)`);
      } catch (error) {
        console.log(`FAIL: ${title}: ${what}: ${String(error.message ?? error).slice(0, 3000)}`);
        failures.push(`${title}: ${what}`);
        await page.screenshot({ path: join(out, `failed-${failures.length}.png`) }).catch(() => {});
        for (const line of server.problems().slice(-5)) console.log(`  photolibd: ${line.slice(0, 300)}`);
        throw error;
      }
    };
    await journey({ page, context, engine: name, url: server.url, token: server.token, photos, video, out, step, light: mobile }).catch(() => {});
    console.log(`${title}: ${((Date.now() - started) / 1000).toFixed(0)} s, screenshots and downloads in ${out}`);
  } finally {
    await browser.close();
    await server.stop();
  }
}

const built = build();
// WEB_E2E_ONLY=firefox,phone runs some of them.
const only = process.env.WEB_E2E_ONLY?.split(',');
const wanted = (name) => !only || only.includes(name);
if (wanted('chromium')) await visit('chromium', chromium, built);
if (wanted('firefox')) await visit('firefox', firefox, built);
if (wanted('webkit') && (process.platform === 'darwin' || process.env.WEB_E2E_WEBKIT === '1' || only)) {
  await visit('webkit', webkit, built);
}
if (wanted('phone')) await visit('chromium', chromium, built, { mobile: true });
if (failures.length) {
  console.error(`FAIL: ${failures.join('; ')}`);
  process.exit(1);
}
