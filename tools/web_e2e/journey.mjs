// What a person does with the web app (M2-25), in one real browser against a real photolibd: sets the server up,
// signs in, uploads photos by the file dialog and by dropping them, sees them in the timeline as they are stored, opens
// them in the viewer with the keyboard, plays a video, downloads one photo and all of them, reloads and finds the
// library in the browser's own store, and opens the app with no network. Each step says what it saw or fails the run.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { execFileSync } from 'node:child_process';
import { changed, dayLabel, dismiss, gone, openApp, painted, seen, settled, tap, texts, type, WAIT } from './lib.mjs';

const password = 'correct horse battery';
// A 1 x 1 PNG, which a drop gives the page.
// The dropped file is dated by the moment it is dropped, which can be a day after the run began (a run crosses midnight):
// the scenario reads that day from the file, never from the clock at import.
const dropped = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/q842iQAAAABJRU5ErkJggg==';

/** Runs the journey in `page` (`light`: without downloads, video, reload and offline, for a slow phone); `context` and `files` (the photos on disk) and `video` (a clip, or null) are the user's. */
export async function journey({ page, context, engine, url, token, photos, video, out, step, light = false }) {
  const label = (pattern) => page.getByRole('button', { name: pattern });
  // Playwright's WebKit puts a style element of its own in the page to take a picture, which the policy refuses.
  const shot = (name) => (engine === 'webkit' ? undefined : page.screenshot({ path: join(out, `${name}.png`) }));
  // A playing video keeps the keyboard, so the viewer closes by its button.
  const closeViewer = async () => {
    await label('Close').first().click({ force: true, timeout: 5000 }).catch(() => page.keyboard.press('Escape'));
    await gone(page, /^Close$/);
  };
  const workers = [];
  page.on('worker', (worker) => workers.push(worker.url()));
  const errors = [];
  page.on('console', (message) => {
    if (message.type() === 'error') errors.push(message.text());
    if (process.env.WEB_E2E_VERBOSE) console.log(`  console ${message.type()}: ${message.text().slice(0, 300)}`);
  });
  page.on('pageerror', (error) => errors.push(String(error)));

  if (process.env.WEB_E2E_VERBOSE) {
    await page.addInitScript(() => document.addEventListener('securitypolicyviolation', (e) => console.log('VIOLATION', e.violatedDirective, JSON.stringify(e.sample), e.sourceFile, e.lineNumber, JSON.stringify([...document.querySelectorAll('style')].filter((n) => !n.nonce).map((n) => n.outerHTML.slice(0, 160))), document.activeElement?.outerHTML.slice(0, 160))));
  }
  await step('the app starts and offers the address it was served from', async () => {
    await openApp(page, url);
    await label(/settings/i).first().click();
    await page.getByText('Add a server').first().click();
    await page.getByRole('button', { name: 'Connect' }).click();
    await page.getByText('Set up a new server').first().click();
  });

  await step('the first administrator is created in the browser and signed in', async () => {
    const boxes = page.getByRole('textbox');
    await boxes.nth(5).waitFor({ timeout: WAIT });
    for (const [i, value] of [token, 'ann', 'Ann', 'ann@example.org', password, password].entries()) await type(page, boxes.nth(i), value);
    await label('Create administrator').click();
    await seen(page, /Signed in as ann/, 60_000);
    await shot('signed-in');
    for (let back = 0; back < 3; back++) {
      const button = label('Back');
      if (!(await button.count())) break;
      const before = await texts(page);
      await button.first().click();
      await changed(page, before);
      await settled(page);
    }
  });

  await step('photos picked in the file dialog upload and reach the timeline', async () => {
    const chooser = page.waitForEvent('filechooser', { timeout: 30_000 });
    await label('Upload photos and videos').click();
    await (await chooser).setFiles(photos);
    await seen(page, /Uploaded 2 of 2/);
    await seen(page, /, 2 of 2/);
    assert.ok(workers.some((url) => url.endsWith('/hash_worker.js')), `the files were hashed on the page: ${workers}`);
    await shot('timeline');
  });

  // The timeline's name for the day of the dropped photo, once it is dropped.
  let today;
  await step('a photo dropped on the window uploads too', async () => {
    const modified = await page.evaluate(async (encoded) => {
      const bytes = Uint8Array.from(atob(encoded), (c) => c.charCodeAt(0));
      const data = new DataTransfer();
      // The page's own clock: a File's default is the machine's, which a clock set for the page (WEB_E2E_CLOCK) does not move.
      const file = new File([bytes], `dropped-${Date.now()}.png`, { type: 'image/png', lastModified: Date.now() });
      data.items.add(file);
      for (const type of ['dragover', 'drop']) document.dispatchEvent(new DragEvent(type, { dataTransfer: data, bubbles: true, cancelable: true }));
      return file.lastModified;
    }, dropped);
    today = dayLabel(modified);
    await seen(page, /Uploaded 3 of 3/);
    await seen(page, new RegExp(`${today}, 1 of 1`));
  });

  await step('the viewer opens, turns with the arrow keys and lists the shortcuts', async () => {
    await tap(page, new RegExp(`${today}, 1 of 1`));
    // A phone's viewer has no pager text and its keys are a keyboard's: it shows the photo, which closes with its button.
    if (light) {
      await seen(page, /Close/, 60_000);
      await painted(page);
      await shot('viewer');
      await label('Close').first().click({ force: true });
      await gone(page, /^Close$/);
      return;
    }
    await seen(page, /1 of 3/, 30_000);
    await page.keyboard.press('ArrowRight');
    await seen(page, /2 of 3/);
    await painted(page);
    await shot('viewer');
    await page.keyboard.press('Shift+Slash');
    await seen(page, /Keyboard shortcuts/, 15_000);
    await dismiss(page, /Keyboard shortcuts/);
  });

  if (!light) await step('one photo downloads under its own name, whole', async () => {
    const download = page.waitForEvent('download', { timeout: 60_000 });
    await page.keyboard.press('Control+s');
    const saved = await download;
    const file = join(out, `single-${saved.suggestedFilename()}`);
    await saved.saveAs(file);
    // The newest photo is the first cell: the one dropped, else one of the two picked.
    const original = photos.find((photo) => photo.endsWith(saved.suggestedFilename()));
    const expected = original ? readFileSync(original) : saved.suggestedFilename().startsWith('dropped-') ? Buffer.from(dropped, 'base64') : null;
    assert.ok(expected, `${saved.suggestedFilename()} is none of the photos`);
    assert.deepEqual(readFileSync(file), expected);
  });

  if (!light) await step('several photos download as one zip of their original names', async () => {
    await dismiss(page, /^Close$/);
    await page.keyboard.press('Control+a');
    await seen(page, /Clear selection/);
    const download = page.waitForEvent('download', { timeout: 60_000 });
    await label(/^Download/).first().click({ force: true });
    const saved = await download;
    const file = join(out, `several-${saved.suggestedFilename().replaceAll(' ', '_')}`);
    await saved.saveAs(file);
    const listing = execFileSync('unzip', ['-Z1', file], { encoding: 'utf8', maxBuffer: 1 << 30 }).trim().split('\n').sort();
    const names = [...photos.map((photo) => photo.split('/').at(-1)), listing.find((name) => name.startsWith('dropped-'))].sort();
    assert.deepEqual(listing, names);
    // A selection keeps the timeline it was made in: the next upload shows once it is cleared.
    await label('Clear selection').click({ force: true });
    await gone(page, /Clear selection/);
  });

  if (video && !light) {
    await step('an uploaded video plays, streamed as the server\'s HLS ladder', async () => {
      const ladder = [];
      page.on('request', (request) => {
        if (/\/media\/[^/]+\/hls\//.test(request.url())) ladder.push(new URL(request.url()).pathname);
      });
      const chooser = page.waitForEvent('filechooser', { timeout: 30_000 });
      await label('Upload photos and videos').click();
      await (await chooser).setFiles([video]);
      await seen(page, /Uploaded 4 of 4/);
      await seen(page, /Nov 14, 2023, \d of 3/);
      // The server renders its H.264 proxy after the upload; the viewer asks for it when the video opens: the video is
      // the newest of its day (the dropped photo has a day of its own).
      let played = 0;
      for (let attempt = 0; attempt < 12 && !played; attempt++) {
        // Back on the timeline, whatever an earlier attempt left open, and its first tile of that day is the video.
        for (let close = 0; close < 3; close++) {
          if (await seen(page, /Nov 14, 2023, 1 of 3/, 5000).then(() => true, () => false)) break;
          await closeViewer();
        }
        await tap(page, /Nov 14, 2023, 1 of 3/);
        // The viewer starts the video once the server has rendered the proxy, or offers Play; an attempt in which it does
        // not advance closes the viewer and asks again.
        const play = label(/^Play$/).first();
        const advanced = page
          .waitForFunction(() => Math.max(0, ...[...document.querySelectorAll('video')].map((v) => v.currentTime)) > 0.5 || false, undefined, { timeout: 10_000 })
          .then(() => true, () => false);
        if (await play.waitFor({ state: 'attached', timeout: 2000 }).then(() => true, () => false)) await play.click({ force: true, timeout: 5000 }).catch(() => {});
        if (await advanced) played = await page.evaluate(() => Math.max(0, ...[...document.querySelectorAll('video')].map((v) => v.currentTime)));
        if (process.env.WEB_E2E_VERBOSE) await shot(`attempt-${attempt}`);
        if (process.env.WEB_E2E_VERBOSE) console.log(`  attempt ${attempt}: play button ${await play.count()}, video ${JSON.stringify(await page.evaluate(() => [...document.querySelectorAll('video')].map((v) => [v.currentTime, v.paused, v.readyState, v.error?.code])))}`);
        if (!played) await closeViewer();
      }
      assert.ok(played > 0.5, 'the video did not advance');
      assert.ok(ladder.some((path) => path.endsWith('/master.m3u8')), `no master playlist among ${ladder}`);
      assert.ok(ladder.some((path) => path.split('/').length > 5), `no segment among ${ladder}`);
      await shot('video');
      await closeViewer();
    });
  }

  if (!light) await step('after a reload the library is in the browser\'s store', async () => {
    await page.reload({ waitUntil: 'load' });
    await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 60_000 });
    await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
    await seen(page, /, 1 of \d/, 60_000);
  });

  if (!light) await step('offline, the installed shell opens with the library', async () => {
    // The shell is kept once the worker controls the page and has been told what the page loaded.
    await page.waitForFunction(
      async () => {
        if (!navigator.serviceWorker.controller) return false;
        const kept = await (await caches.open('photolib-shell-1')).keys();
        return kept.some((request) => /\/main\.dart\.(wasm|js)$/.test(request.url));
      },
      undefined,
      { timeout: 60_000 },
    );
    assert.ok((await page.evaluate(() => navigator.serviceWorker.getRegistrations())).length > 0, 'no service worker');
    await context.setOffline(true);
    await page.reload({ waitUntil: 'load', timeout: 60_000 });
    await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 60_000 });
    await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
    await seen(page, /Library/, 30_000);
    await context.setOffline(false);
  });

  await step('the page logged no error and the policy blocked nothing', async () => {
    assert.deepEqual(errors.filter((text) => !/ERR_INTERNET_DISCONNECTED|Failed to load resource/.test(text)), []);
  });
  return texts(page);
}
