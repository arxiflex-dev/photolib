// What the web client's end-to-end run needs (M2-25): a real photolibd on a throwaway PostgreSQL cluster that serves
// the built web app, files to upload, and the way a user reaches a Flutter page, whose widgets the browser sees only as
// the accessibility tree the app turns on.
import { spawn, spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readdirSync, rmSync, writeFileSync } from 'node:fs';
import { createServer } from 'node:net';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { deflateSync } from 'node:zlib';

/** A free loopback port. */
export function freePort() {
  return new Promise((resolve, reject) => {
    const server = createServer();
    server.once('error', reject);
    server.listen(0, '127.0.0.1', () => {
      const { port } = server.address();
      server.close(() => resolve(port));
    });
  });
}

/** The directory of PostgreSQL's programs: `TEST_PG_BIN`, else the newest `/usr/lib/postgresql/<major>/bin`. */
export function postgresBin() {
  if (process.env.TEST_PG_BIN) return process.env.TEST_PG_BIN;
  const found = spawnSync('sh', ['-c', 'command -v pg_ctl'], { encoding: 'utf8', maxBuffer: 1 << 30 }).stdout.trim();
  if (found) return found.replace(/\/pg_ctl$/, '');
  const majors = readdirSync('/usr/lib/postgresql').map(Number).filter(Number.isInteger).sort((a, b) => a - b);
  return `/usr/lib/postgresql/${majors.at(-1)}/bin`;
}

function run(command, args) {
  const result = spawnSync(command, args, { encoding: 'utf8', maxBuffer: 1 << 30 });
  if (result.status !== 0) throw new Error(`${command} ${args.join(' ')}: ${result.stderr}`);
}

/**
 * photolibd, as an operator runs it, on its own PostgreSQL cluster, serving `web` as its web app (`web_root`) at a
 * loopback port, with the roles that render photos and videos; resolves to its address, the one-time setup token it
 * logs and `stop`.
 */
export async function startServer({ photolibd, web, ffmpegDir }) {
  const dir = mkdtempSync(join(tmpdir(), 'photolib-e2e-'));
  const pg = postgresBin();
  run(`${pg}/initdb`, ['-U', 'postgres', '-A', 'trust', '-E', 'UTF8', '--no-sync', '--locale=C', '-D', `${dir}/data`]);
  run(`${pg}/pg_ctl`, ['-w', '-D', `${dir}/data`, '-l', `${dir}/pg.log`, '-o', `-c listen_addresses='' -k ${dir} -c fsync=off`, 'start']);
  mkdirSync(`${dir}/photolibd`);
  const port = await freePort();
  writeFileSync(
    `${dir}/photolib.yaml`,
    [
      'config_version: 1',
      `listen: 127.0.0.1:${port}`,
      'roles: [api, scheduler, worker:cpu, worker:io, worker:transcode]',
      `ffmpeg_dir: ${ffmpegDir}`,
      `web_root: ${web}`,
      'allow_insecure_http: true',
      `data_dir: ${dir}/photolibd`,
      'database:',
      `  url: "postgres://postgres@localhost/postgres?host=${dir}"`,
      '',
    ].join('\n'),
  );
  const child = spawn(photolibd, ['--config', `${dir}/photolib.yaml`], { env: {}, stdio: ['ignore', 'ignore', 'pipe'] });
  let token;
  let log = '';
  const listening = new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error(`photolibd did not start:\n${log}`)), 120_000);
    child.stderr.on('data', (chunk) => {
      log += chunk;
      token ??= /"setup_token":"([0-9a-f]+)"/.exec(log)?.[1];
      if (token && log.includes('"message":"listening"')) (clearTimeout(timer), resolve());
    });
    child.once('exit', (code) => reject(new Error(`photolibd exited with ${code}:\n${log}`)));
  });
  await listening;
  return {
    url: `http://127.0.0.1:${port}/`,
    token,
    /** What photolibd logged as a warning or an error since it started. */
    problems: () => log.split('\n').filter((line) => /"level":"(WARN|ERROR)"/.test(line) && !line.includes('allow_insecure_http')),
    async stop() {
      child.removeAllListeners('exit');
      if (child.exitCode === null && child.signalCode === null) {
        child.kill('SIGTERM');
        await new Promise((done) => child.once('exit', done));
      }
      spawnSync(`${pg}/pg_ctl`, ['-D', `${dir}/data`, '-m', 'immediate', 'stop'], { maxBuffer: 1 << 30 });
      rmSync(dir, { recursive: true, force: true });
    },
  };
}

let crc;
function crc32(bytes) {
  crc ??= Array.from({ length: 256 }, (_, n) => {
    let c = n;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    return c >>> 0;
  });
  let c = 0xffffffff;
  for (const byte of bytes) c = crc[(c ^ byte) & 255] ^ (c >>> 8);
  return (c ^ 0xffffffff) >>> 0;
}

/** A 64 x 48 PNG that differs by `seed`. */
export function png(seed) {
  const [width, height] = [64, 48];
  const rows = [];
  for (let y = 0; y < height; y++) {
    const row = [0];
    for (let x = 0; x < width; x++) row.push((x * 4 + seed * 50) & 255, (y * 5) & 255, (seed * 90) & 255);
    rows.push(Buffer.from(row));
  }
  const chunk = (type, data) => {
    const size = Buffer.alloc(4);
    size.writeUInt32BE(data.length);
    const body = Buffer.concat([Buffer.from(type), data]);
    const sum = Buffer.alloc(4);
    sum.writeUInt32BE(crc32(body));
    return Buffer.concat([size, body, sum]);
  };
  const header = Buffer.alloc(13);
  header.writeUInt32BE(width, 0);
  header.writeUInt32BE(height, 4);
  header[8] = 8;
  header[9] = 2;
  return Buffer.concat([
    Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]),
    chunk('IHDR', header),
    chunk('IDAT', deflateSync(Buffer.concat(rows))),
    chunk('IEND', Buffer.alloc(0)),
  ]);
}

/** A few seconds of H.264 and AAC in `dir`, made with the FFmpeg of `ffmpegDir`; null when it cannot encode them. */
export function clip(dir, ffmpegDir, name) {
  const file = join(dir, name);
  for (const encoder of ['libx264', 'libopenh264']) {
    const made = spawnSync(
      `${ffmpegDir}/ffmpeg`,
      ['-y', '-loglevel', 'error', '-f', 'lavfi', '-i', 'testsrc2=size=640x360:rate=30:duration=4', '-f', 'lavfi', '-i', 'sine=frequency=440:duration=4',
        '-c:v', encoder, '-pix_fmt', 'yuv420p', '-c:a', 'aac', '-shortest', file],
      { encoding: 'utf8', maxBuffer: 1 << 30 },
    );
    if (made.status === 0 && existsSync(file)) return file;
  }
  return null;
}

/** The accessibility tree's text, which is all a browser can read of a Flutter page. */
export function texts(page) {
  return page.evaluate(() =>
    [...document.querySelectorAll('flt-semantics')].map((node) => node.getAttribute('aria-label') || node.textContent || ''),
  );
}

/** The timeline's name for the day of `ms`, in this process's time zone. */
export function dayLabel(ms) {
  return new Date(ms).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

/**
 * Waits until some node of the accessibility tree matches `pattern`; a timeout says what it waited for and lists the
 * page's nodes, which is all anyone has to go on when it happens on a runner.
 */
export async function seen(page, pattern, timeout = 120_000) {
  try {
    return await page.waitForFunction(
      (source) => [...document.querySelectorAll('flt-semantics')].some((node) => new RegExp(source).test(node.getAttribute('aria-label') || node.textContent || '')),
      pattern.source,
      { timeout },
    );
  } catch (error) {
    if (!/Timeout/.test(String(error.message))) throw error;
    const nodes = await texts(page).then((all) => all.filter(Boolean), () => ['(the page could not be read)']);
    throw new Error(
      `${error.message.split('\n')[0]}\n  waiting for a node matching ${pattern}\n  the page shows ${nodes.length} nodes: ${JSON.stringify(nodes.slice(0, 60)).slice(0, 2000)}`,
      { cause: error },
    );
  }
}

/** Types into a text field the way a user does: Flutter reads keystrokes, never a value set on the node. */
export async function type(page, field, text) {
  await field.click();
  await page.waitForTimeout(250);
  await page.keyboard.type(text);
}

/** Turns the accessibility tree on, as a screen reader's user does. */
export async function openApp(page, url) {
  await page.goto(url, { waitUntil: 'load' });
  await page.waitForSelector('flt-semantics-placeholder', { state: 'attached', timeout: 120_000 });
  await page.evaluate(() => document.querySelector('flt-semantics-placeholder').click());
  await page.waitForSelector('flt-semantics', { state: 'attached', timeout: 120_000 });
  await page.waitForTimeout(1500);
}

/** Taps the tile whose label matches `pattern`, wherever the layout puts it. */
export async function tap(page, pattern) {
  const at = await page.evaluate((source) => {
    // The innermost node that says it: a parent's text holds its children's.
    const node = [...document.querySelectorAll('flt-semantics')].filter((n) => new RegExp(source).test(n.getAttribute('aria-label') || n.textContent || '')).at(-1);
    const box = node?.getBoundingClientRect();
    return box && { x: box.x + box.width / 2, y: box.y + box.height / 2 };
  }, pattern.source);
  if (!at) throw new Error(`nothing is labelled ${pattern}`);
  await page.mouse.click(at.x, at.y);
}
