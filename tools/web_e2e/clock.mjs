// A clock set just before midnight for the journey (WEB_E2E_CLOCK), so that a day-boundary bug fails in the step that
// runs it instead of in the one queue run that starts minutes before 00:00 UTC (PHO-235): the modules are imported
// seconds before midnight, the first browser step runs after it. It sets this process's clock (midnight.mjs, loaded with
// `node --import` before any module of the run) and the browser's (`browserClock`); both then run on in real time.
const DAY = 86_400_000;
const LEAD = 5_000;

/** The instant `spec` names, as epoch milliseconds: "midnight" is 5 s before the next UTC midnight after `now`; an ISO instant is itself; nothing is null. */
export function startTime(spec, now) {
  if (!spec) return null;
  if (spec === 'midnight') return now - (now % DAY) + DAY - LEAD;
  const at = Date.parse(spec);
  if (Number.isNaN(at)) throw new Error(`WEB_E2E_CLOCK is "${spec}": use "midnight" or an ISO time such as 2026-10-27T23:58:00Z`);
  return at;
}

/** Makes `Date.now()` and `new Date()` of this process start at the time `spec` names and run on. */
export function setClock(spec) {
  const RealDate = Date;
  const start = startTime(spec, RealDate.now());
  if (start === null) return;
  const shift = start - RealDate.now();
  globalThis.Date = class extends RealDate {
    constructor(...args) {
      super(...(args.length ? args : [RealDate.now() + shift]));
    }

    static now() {
      return RealDate.now() + shift;
    }
  };
}

/** Gives `context`'s pages the clock of this process; a no-op when none is set. */
export async function browserClock(context) {
  if (process.env.WEB_E2E_CLOCK) await context.clock.install({ time: Date.now() });
}
