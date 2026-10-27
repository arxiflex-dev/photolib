// The web client against a server that already holds photos (PHO-240, tools/e2e/server_client_smoke.sh): a person gets a
// password setup token from the administrator, opens the app photolibd serves, sets the password (which signs in), and
// finds the server's photos in the unified timeline, opens one in the viewer, plays a video, and sees the photos of an
// external folder. Environment: SMOKE_URL, SMOKE_SETUP (the token), SMOKE_BROWSER (chromium, firefox or phone),
// SMOKE_OUT (screenshots), SMOKE_EXPECT (assets the timeline must show), SMOKE_VIDEO_DAYS (the timeline's names for the days of videos to play, e.g. "Nov 14, 2023;Mar 3, 2024", semicolon between days); WEB_E2E's
// CHROME_EXECUTABLE and PLAYWRIGHT_DIR as in tools/web_e2e/run.mjs. Exits 1 on the first failed step.
import assert from 'node:assert/strict';
import { mkdirSync } from 'node:fs';
import { join } from 'node:path';
import { openApp, seen, tap, texts, type } from '../web_e2e/lib.mjs';
import { chromium, devices, firefox, launch } from '../web_e2e/setup.mjs';

const { SMOKE_URL: url, SMOKE_SETUP: setup, SMOKE_BROWSER: name = 'chromium', SMOKE_OUT: out } = process.env;
const expect = Number(process.env.SMOKE_EXPECT ?? 1);
assert.ok(url && setup && out, 'SMOKE_URL, SMOKE_SETUP and SMOKE_OUT are needed');
mkdirSync(out, { recursive: true });

const mobile = name === 'phone';
const browser = await launch(name === 'firefox' ? firefox : chromium, name === 'firefox' ? 'firefox' : 'chromium');
const context = await browser.newContext(
  mobile
    ? { ...devices['Pixel 7'], userAgent: `Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${browser.version()} Safari/537.36` }
    : { viewport: { width: 1280, height: 800 } },
);
const page = await context.newPage();
if (mobile) {
  const cdp = await context.newCDPSession(page);
  await cdp.send('Emulation.setCPUThrottlingRate', { rate: 4 });
  await cdp.send('Network.emulateNetworkConditions', { offline: false, latency: 150, downloadThroughput: (1.6 * 1024 * 1024) / 8, uploadThroughput: (750 * 1024) / 8 });
}
const errors = [];
page.on('pageerror', (error) => errors.push(String(error)));
page.on('console', (message) => message.type() === 'error' && errors.push(message.text()));
const label = (pattern) => page.getByRole('button', { name: pattern });
const shot = (file) => page.screenshot({ path: join(out, `${name}-${file}.png`) });
let failed = false;
const step = async (what, work) => {
  const began = Date.now();
  try {
    await work();
    console.log(`ok: ${name}: ${what} (${((Date.now() - began) / 1000).toFixed(1)} s)`);
  } catch (error) {
    failed = true;
    console.log(`FAIL: ${name}: ${what}: ${String(error.message ?? error).slice(0, 1500)}`);
    await shot('failed').catch(() => {});
    throw error;
  }
};
const tiles = async () => {
  const labels = [...new Set((await texts(page)).filter(Boolean))].flatMap((text) => text.split('\n'));
  return labels.filter((text) => /, \d+ of \d+$/.test(text));
};

try {
  await step('the app opens at the address photolibd serves it from', () => openApp(page, url));
  await step('the person sets the password with the administrator\'s token and is signed in', async () => {
    await label(/settings/i).first().click();
    await page.getByText('Add a server').first().click();
    await page.waitForTimeout(800);
    await label('Connect').click();
    await label('Set a password').click();
    await page.waitForTimeout(800);
    const boxes = page.getByRole('textbox');
    for (const [i, value] of [setup, 'ann', 'correct horse battery', 'correct horse battery'].entries()) await type(page, boxes.nth(i), value);
    await label('Set password').click();
    await seen(page, /Signed in as ann/, 60_000);
    await shot('signed-in');
    for (let back = 0; back < 3; back++) {
      const button = label('Back');
      if (await button.count()) await button.first().click();
      await page.waitForTimeout(1200);
    }
  });
  const groups = new Map();
  const collect = async () => {
    for (const text of await tiles()) {
      const [, day, total] = /^(.*), \d+ of (\d+)$/.exec(text);
      groups.set(day, Number(total));
    }
    return [...groups.values()].reduce((sum, n) => sum + n, 0);
  };
  const escape = (text) => new RegExp(text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
  await step(`the unified timeline shows the server's photos (${expect} expected)`, async () => {
    // Each tile says "<day>, <n> of <photos that day>"; the list shows what is near the screen, so scroll through it.
    const deadline = Date.now() + 180_000;
    let total = 0;
    while (Date.now() < deadline && total < expect) {
      await page.mouse.move(mobile ? 200 : 700, 500);
      for (let at = 0; at < 14; at++) {
        total = await collect();
        if (total >= expect) break;
        await page.mouse.wheel(0, 2500);
        await page.waitForTimeout(700);
      }
      if (total < expect) await page.waitForTimeout(2000);
    }
    await shot('timeline');
    assert.ok(total >= expect, `the timeline shows ${total} photos in ${groups.size} day groups (${[...groups].join('; ')}), expected ${expect}`);
    console.log(`  timeline groups: ${[...groups].map(([day, n]) => `${day}: ${n}`).join('; ')}`);
    await page.mouse.wheel(0, -100000);
    await page.waitForTimeout(1500);
  });
  await step('a photo opens in the viewer', async () => {
    await tap(page, escape([...groups.keys()][0] + ', 1 of'));
    await page.waitForTimeout(mobile ? 6000 : 3000);
    await shot('viewer');
    if (!mobile) await seen(page, /\d+ of \d+/, 30_000);
    await label('Close').first().click({ force: true, timeout: 5000 }).catch(() => page.keyboard.press('Escape'));
    await page.waitForTimeout(1500);
  });
  for (const videoDay of mobile ? [] : (process.env.SMOKE_VIDEO_DAYS ?? '').split(';').filter(Boolean)) {
    await step(`a video (${videoDay}) plays from the server`, async () => {
      let played = 0;
      for (let attempt = 0; attempt < 12 && !played; attempt++) {
        await page.mouse.move(700, 500);
        await page.mouse.wheel(0, -100000);
        await page.waitForTimeout(800);
        // Scroll until the day's first tile is on the screen (its node stays in the tree when it is not).
        for (let at = 0; at < 60; at++) {
          const y = await page.evaluate((source) => {
            const node = [...document.querySelectorAll('flt-semantics')].filter((n) => new RegExp(source).test(n.getAttribute('aria-label') || n.textContent || '')).at(-1);
            return node ? node.getBoundingClientRect().y : null;
          }, escape(`${videoDay}, 1 of`).source);
          if (y !== null && y > 120 && y < 600) break;
          await page.mouse.wheel(0, y === null ? 1500 : Math.max(-2500, Math.min(2500, y - 300)));
          await page.waitForTimeout(600);
        }
        await tap(page, escape(`${videoDay}, 1 of`));
        await page.waitForTimeout(4000);
        if (attempt === 0) await shot(`video-opened-${videoDay.replace(/\W+/g, '-')}`);
        const play = label(/^Play$/).first();
        if (await play.count()) {
          await play.click({ force: true, timeout: 5000 }).catch(() => {});
          await page.waitForTimeout(2500);
          played = await page.evaluate(() => Math.max(0, ...[...document.querySelectorAll('video')].map((v) => v.currentTime)));
        }
        const states = await page.evaluate(() => [...document.querySelectorAll('video')].map((v) => [v.currentTime, v.paused, v.readyState, v.error?.code]));
        console.log(`  ${videoDay}: attempt ${attempt}: play buttons ${await play.count()}, videos ${JSON.stringify(states)}`);
        await shot(played ? `video-${videoDay.replace(/\W+/g, '-')}` : `video-attempt-${attempt}`);
        // A playing video keeps the keyboard: the viewer closes by its button.
        await label('Close').first().click({ force: true, timeout: 5000 }).catch(() => page.keyboard.press('Escape'));
        // The server renders the proxy after the upload: give it a moment before the next try.
        await page.waitForTimeout(played ? 1500 : 4000);
      }
      assert.ok(played > 0.5, 'the video did not advance');
    });
  }
  await step('the page logged no error', async () => {
    assert.deepEqual(errors.filter((text) => !/Failed to load resource/.test(text)), []);
  });
} catch {
  process.exitCode = 1;
} finally {
  await browser.close();
}
if (failed) process.exitCode = 1;
