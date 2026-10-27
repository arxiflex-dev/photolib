// `node --import ./tools/web_e2e/midnight.mjs tools/web_e2e/run.mjs` with WEB_E2E_CLOCK set (see clock.mjs).
import { setClock } from './clock.mjs';

setClock(process.env.WEB_E2E_CLOCK);
