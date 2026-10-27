# ADR-0400 — Date format setting: the order of dates, whatever the language

* **Status**: Accepted — 2026-10-23. The owner asked for it (answer 2 of the questions of ADR-0314).
* **Requirements**: I18N-04. **Design**: i18n and accessibility §2; extends [ADR-0314](0314-language-setting.md).

## Context

ADR-0314 let the language be chosen apart from the device's, but dates still followed the language: `Formats` could
borrow another locale's pattern (`dateLocale`), which also brings that locale's month names (`en_GB` in a German app
shows "May"). The owner wants the order of dates to be its own choice.

## Decision

* **Settings › Date format** lists *Language default* and three orders, each with a sample date (24 Dec 2025) drawn
  in the language shown: day-month-year (`d MMM y`), month-day-year (`MMM d, y`) and year-month-day (`y MMM d`).
* Month names are always the app language's (`DateFormat(pattern, AppLocalizations.localeName)`), never another
  locale's. *Language default* is the language's own `yMMMd`, as before.
* The choice is `Settings.dateFormat` (`DateOrder`, ADR-0057's sealed `settings` object), stored by name; a value this
  build does not know reads as *Language default*.
* It feeds `Formats` at every call site that shows a date (`Formats.of(context)`, from a `DateOrderScope` above the
  routes), so every screen changes at once. Month headings and capture times follow it; the time of day (`jm`), the
  first day of the week and numbers stay the language's, as the owner asked.

## Consequences

* A pattern order is literal: in CJK languages `d MMM y` gives "24 12月 2025". Whoever picks it asked for that order.
* `Formats(dateLocale:)` stays for callers that need another locale's week, but no screen uses it.

## Options considered

* **A list of date locales**: brings their month names, which the owner excluded.
* **ISO 8601 only, as a switch**: covers one order of three the owner named.
