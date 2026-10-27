import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { startTime } from '../clock.mjs';

const preload = fileURLToPath(new URL('../midnight.mjs', import.meta.url));
const midnight = Date.UTC(2026, 9, 28);

test('"midnight" starts the clock 5 s before the next UTC midnight, whenever the run begins', () => {
  assert.equal(startTime('midnight', Date.UTC(2026, 9, 27, 3, 15)), midnight - 5_000);
  assert.equal(startTime('midnight', Date.UTC(2026, 9, 27, 23, 59, 59)), midnight - 5_000);
  assert.equal(startTime('midnight', midnight), midnight + 86_400_000 - 5_000);
});

test('a time of day or an ISO instant sets the clock to it, and nothing sets the real clock', () => {
  assert.equal(startTime('2026-10-27T23:58:00Z', 0), Date.UTC(2026, 9, 27, 23, 58));
  assert.equal(startTime(undefined, 0), null);
  assert.equal(startTime('', 0), null);
  assert.throws(() => startTime('tomorrow', 0), /WEB_E2E_CLOCK/);
});

// A fresh process, as the gate runs it: the preload comes before any module of the run is evaluated.
const inProcess = (source, env) => execFileSync(process.execPath, ['--import', preload, '--input-type=module', '-e', source], {
  encoding: 'utf8',
  env: { ...process.env, ...env },
}).trim();

test('under the preload the process sees the clock set and it keeps running; Date still builds other dates', () => {
  const out = inProcess(
    `const a = Date.now(); await new Promise((r) => setTimeout(r, 60)); const b = Date.now();
     console.log(JSON.stringify([a, b, new Date().getTime() >= b, new Date(0).getTime(), new Date('2026-01-02T00:00:00Z').getTime(), new Date() instanceof Date]));`,
    { WEB_E2E_CLOCK: '2026-10-27T23:59:40Z' },
  );
  const [a, b, later, zero, iso, isDate] = JSON.parse(out);
  const start = Date.UTC(2026, 9, 27, 23, 59, 40);
  assert.ok(a >= start && a < start + 5_000, `the clock starts at the time set, not at ${new Date(a).toISOString()}`);
  assert.ok(b - a >= 50, 'it advances in real time');
  assert.ok(later);
  assert.equal(zero, 0);
  assert.equal(iso, Date.UTC(2026, 0, 2));
  assert.ok(isDate);
});

test('without WEB_E2E_CLOCK the preload leaves the clock alone', () => {
  const out = inProcess('console.log(Date.now())', { WEB_E2E_CLOCK: '' });
  assert.ok(Math.abs(Number(out) - Date.now()) < 10_000);
});

test('a module that reads the clock when it is imported sees the day before the run crosses midnight', () => {
  const out = inProcess(
    `const day = new Date().toISOString().slice(0, 10); await new Promise((r) => setTimeout(r, 1500));
     console.log(day, new Date().toISOString().slice(0, 10));`,
    { WEB_E2E_CLOCK: new Date(Date.now() - (Date.now() % 86_400_000) + 86_400_000 - 1000).toISOString() },
  );
  const [imported, dropped] = out.split(' ');
  assert.notEqual(imported, dropped, 'a run that starts one second before midnight must see two days');
});
