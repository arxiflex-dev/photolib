import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { changed, gone, seen, settled, WAIT } from '../lib.mjs';

/** A page whose waits end at once with `outcome` (an Error to throw) and which remembers how they were asked. */
function pageThat(outcome, nodes = []) {
  const asked = [];
  return {
    asked,
    waitForFunction: async (fn, arg, options) => {
      asked.push({ arg, options });
      if (outcome instanceof Error) throw outcome;
      return outcome;
    },
    evaluate: async () => nodes,
  };
}
const timeout = (ms) => new Error(`page.waitForFunction: Timeout ${ms}ms exceeded.`);

test('a wait that is not met gives up in 30 s by default, so a missed condition costs seconds, not minutes', async () => {
  assert.ok(WAIT <= 30_000, `the default wait is ${WAIT} ms`);
  const page = pageThat(timeout(WAIT), ['Library']);
  await assert.rejects(seen(page, /x/));
  assert.equal(page.asked[0].options.timeout, WAIT);
});

test('a step that needs longer says so, per wait', async () => {
  const page = pageThat('handle');
  await seen(page, /x/, 60_000);
  await gone(page, /y/, 45_000);
  assert.deepEqual(page.asked.map((call) => call.options.timeout), [60_000, 45_000]);
});

test('a node that does not go away fails fast with the pattern and the page state', async () => {
  const page = pageThat(timeout(WAIT), ['Close', 'Oct 27, 2026, 1 of 1']);
  await assert.rejects(gone(page, /Close/), (error) => {
    assert.match(error.message, /Timeout 30000ms exceeded/);
    assert.match(error.message, /waiting for no node matching \/Close\//);
    assert.match(error.message, /Oct 27, 2026, 1 of 1/);
    return true;
  });
});

test('a page that does not change after a gesture fails fast with what it still shows', async () => {
  const page = pageThat(timeout(WAIT), ['Settings', 'Back']);
  await assert.rejects(changed(page, ['Settings', 'Back']), (error) => {
    assert.match(error.message, /waiting for the page to change/);
    assert.match(error.message, /Back/);
    return true;
  });
  assert.equal(page.asked[0].arg, JSON.stringify(['Settings', 'Back']), 'it compares with the nodes it was given');
});

test('a page that never settles fails fast, saying how long it had to stand still', async () => {
  const page = pageThat(timeout(WAIT), ['Back']);
  await assert.rejects(settled(page, 20), /waiting for the page to settle \(unchanged for 20 frames\)/);
  assert.equal(page.asked[0].options.polling, 'raf', 'it counts frames, not milliseconds');
  assert.equal(page.asked[0].arg, 20);
});

test('a wait met returns, and a failure that is no timeout keeps its own message', async () => {
  assert.equal(await gone(pageThat('handle'), /x/), 'handle');
  assert.equal(await changed(pageThat('handle'), []), 'handle');
  await assert.rejects(gone(pageThat(new Error('Target closed')), /x/), /^Error: Target closed$/);
});

for (const file of ['journey.mjs', 'lib.mjs', 'run.mjs', 'cold_start.mjs']) {
  test(`${file} sleeps for no fixed time: it waits for what the sleep stood for`, () => {
    const source = readFileSync(fileURLToPath(new URL(`../${file}`, import.meta.url)), 'utf8');
    const sleeps = source.split('\n').flatMap((line, i) => (/waitForTimeout/.test(line) ? [`${file}:${i + 1}: ${line.trim()}`] : []));
    assert.deepEqual(sleeps, []);
  });
}
