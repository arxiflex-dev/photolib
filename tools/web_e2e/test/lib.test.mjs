import assert from 'node:assert/strict';
import { mkdtempSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { test } from 'node:test';
import { inflateSync } from 'node:zlib';
import { clip, dayLabel, freePort, png, seen } from '../lib.mjs';

test('the photos it uploads are PNGs of 64 x 48 that differ by seed', () => {
  const [a, b] = [png(1), png(2)];
  assert.deepEqual([...a.subarray(0, 8)], [137, 80, 78, 71, 13, 10, 26, 10]);
  assert.equal(a.readUInt32BE(16), 64);
  assert.equal(a.readUInt32BE(20), 48);
  assert.notDeepEqual(a, b);
  // The pixels inflate to one filter byte and 64 RGB triples a row.
  const size = a.readUInt32BE(33);
  assert.equal(inflateSync(a.subarray(41, 41 + size)).length, 48 * (1 + 64 * 3));
});

test('a free port is one nothing listens on', async () => {
  const [a, b] = [await freePort(), await freePort()];
  assert.ok(a > 0 && b > 0);
});

test('without an FFmpeg there is no clip, and the run goes on without a video', () => {
  assert.equal(clip(mkdtempSync(`${tmpdir()}/clip-`), '/nonexistent', 'clip.mp4'), null);
});

test('importing the journey reads no clock: the day of a photo dropped after midnight is not the day the run began', async () => {
  const RealDate = Date;
  let reads = 0;
  globalThis.Date = class extends RealDate {
    constructor(...args) {
      if (args.length === 0) reads++;
      super(...args);
    }
    static now() {
      reads++;
      return RealDate.now();
    }
  };
  try {
    await import('../journey.mjs');
  } finally {
    globalThis.Date = RealDate;
  }
  assert.equal(reads, 0, 'the journey read the clock when it was imported, minutes before its photo is dropped');
});

test('the timeline names a day as the app does, and the next second can be another day', () => {
  const before = new Date(2026, 9, 26, 23, 59, 59).getTime();
  assert.equal(dayLabel(before), 'Oct 26, 2026');
  assert.equal(dayLabel(before + 2000), 'Oct 27, 2026');
});

test('a wait that times out says what it waited for and what the page shows', async () => {
  const page = {
    waitForFunction: async () => {
      throw new Error('page.waitForFunction: Timeout 120000ms exceeded.');
    },
    evaluate: async () => ['Library', 'Uploaded 2 of 3 \u00b7 1 failed', 'Oct 27, 2026, 1 of 1'],
  };
  await assert.rejects(seen(page, /Uploaded 3 of 3/), (error) => {
    assert.match(error.message, /Timeout 120000ms exceeded/);
    assert.match(error.message, /Uploaded 3 of 3/);
    assert.match(error.message, /Uploaded 2 of 3 \u00b7 1 failed/);
    assert.match(error.message, /Oct 27, 2026, 1 of 1/);
    return true;
  });
});

test('a wait that is met returns, and a failure that is no timeout keeps its own message', async () => {
  const met = { waitForFunction: async () => 'handle', evaluate: async () => [] };
  assert.equal(await seen(met, /x/), 'handle');
  const closed = { waitForFunction: async () => Promise.reject(new Error('Target closed')), evaluate: async () => [] };
  await assert.rejects(seen(closed, /x/), /^Error: Target closed$/);
});
