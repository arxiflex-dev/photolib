# ADR-0314 — Language setting: the device's language unless Settings chooses one

* **Status**: Accepted — 2026-10-23. The owner kept both decisions of the first question (the in-app choice is not
  written back to the system) and changed the second: dates have a Date format setting of their own
  ([ADR-0400](0400-date-format-setting.md)).
* **Requirements**: F-13, NFR-I18N-1, I18N-17. **Design**:
  i18n and accessibility §2;
  amends [ADR-0030](0030-i18n-and-accessibility-scaffolding.md).

## Context

The app shipped 21 languages but showed only the device's: `MaterialApp` set no `locale`, so nobody could use or check
a translation, or a right-to-left layout, without changing the whole device (owner, 2026-10-23, M1-53). Android 13+,
iOS and macOS have a per-app language setting of their own, which lists only the languages an app declares.

## Decision

* **Settings › Language** lists *Device language*, the default, then `launchLocales` (`app/lib/l10n/locales.dart`),
  each by its translation's `languageName` (*Deutsch*, *日本語*) drawn in its own locale, so a user who cannot read
  the language shown still finds theirs. Pseudo-locales are not listed.
* The choice is `Settings.language`, kept as its BCP 47 tag in the sealed `settings` object (ADR-0057). A tag this
  build does not ship (a dropped translation, a pseudo-locale) reads as the device language.
* It is `MaterialApp.locale`: every screen, the routes under the one shown too, rebuilds at once with its strings,
  direction and `Formats` (dates, numbers, file sizes and first day of the week from `AppLocalizations.localeName`).
* **Per-app language.** Android declares the launch languages in `res/xml/locales_config.xml`
  (`android:localeConfig`), iOS and macOS in `CFBundleLocalizations`, as Apple names them (`pt-BR`, `zh-Hans`);
  `app/test/per_app_language_test.dart` holds them to `launchLocales`. The system's per-app choice is the language
  *Device language* follows; a language chosen in the app wins over it and is not written back to the system.

## Consequences

* With a language chosen in both places, the system's page may name another than the app shows.
* Text the system shows for the app (iOS purpose strings and widgets, the share extension, notifications) follows the
  system's language, per-app or device, never the in-app choice.
* On the web, the names in CJK, Arabic, Hebrew and Devanagari scripts show as boxes until fallback fonts are served
  (ADR-0030, M2-25).

## Options considered

* **Only the system's per-app setting**: nothing on Windows, Linux, the web or Android before 13.
* **Writing the in-app choice to the system** (Android's `LocaleManager.setApplicationLocales`): both pages agree, on
  Android 13+ only, through native code the gate cannot build; iOS has no such call.
* **Names in English or in the language shown**: unreadable to the user who most needs the list.
