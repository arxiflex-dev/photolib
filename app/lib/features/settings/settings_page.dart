import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/feature_flags.dart';
import 'package:photolib/core/providers.dart';
import 'package:photolib/features/admin/admin_page.dart';
import 'package:photolib/features/backup/backup_page.dart';
import 'package:photolib/features/folders/device_folders.dart';
import 'package:photolib/features/library/timeline/benchmark.dart';
import 'package:photolib/features/offline/storage_page.dart';
import 'package:photolib/features/people/people_section.dart';
import 'package:photolib/features/servers/server_tile.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/settings/indexing.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/settings/store.dart';
import 'package:photolib/features/viewer/toolbar.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/locales.dart';
import 'package:photolib/ui/adaptive.dart';
import 'package:photolib/ui/tokens.dart';

/// Settings: language, theme, server, folders, on-device indexing,
/// administration and diagnostics.
class SettingsPage extends ConsumerWidget {
  /// The page at /settings.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final tokens = AppTokens.of(context);
    final release = ref.watch(releaseBuildProvider);
    final diagnostics =
        ref.watch(settingsProvider).diagnostics ||
        ref.watch(featureFlagsProvider).isOn(Flag.diagnostics);

    return Scaffold(
      appBar: AppBar(title: Text(strings.settingsTitle)),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.all(tokens.md),
          children: [
            StoreBanner(margin: EdgeInsets.only(bottom: tokens.md)),
            const _Language(),
            SizedBox(height: tokens.sm),
            Text(strings.settingsTheme, style: textTheme.titleMedium),
            SizedBox(height: tokens.sm),
            const _ThemePicker(),
            const _StartScreen(),
            SizedBox(height: tokens.lg),
            Text(strings.settingsServer, style: textTheme.titleMedium),
            const ServerList(),
            if (ref.watch(sessionProvider) != null) const _PrivacyTile(),
            const BackupTile(),
            const StorageTile(),
            const LibrarySection(),
            const IndexingSection(),
            const FacesSection(),
            SizedBox(height: tokens.lg),
            const RecoveryCodeTile(),
            if (ref.watch(adminClientProvider) != null) ...[
              SizedBox(height: tokens.lg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: Text(strings.adminTitle),
                onTap: () => context.push('/admin'),
              ),
            ],
            // Always in debug builds; in release, an advanced setting
            // (ADR-0115).
            if (release)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.diagnosticsAdvanced),
                value: diagnostics,
                onChanged: (on) =>
                    ref.read(settingsProvider.notifier).setDiagnostics(on: on),
              ),
            if (!release || diagnostics)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.bug_report_outlined),
                title: Text(strings.diagnosticsTitle),
                onTap: () => context.push('/settings/diagnostics'),
              ),
            if (ref.watch(featureFlagsProvider).isOn(Flag.diagnostics))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.speed_outlined),
                title: Text(strings.timelineBenchmark),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const TimelineBenchmarkPage(),
                  ),
                ),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.photo_outlined),
              title: Text(strings.settingsViewing),
              onTap: () => context.push('/settings/viewing'),
            ),
            // The licences the app registers: Roboto, and on Windows the LGPL
            // notices of the libmpv and FFmpeg it bundles (ADR-0229).
            AboutListTile(
              icon: const Icon(Icons.info_outline),
              applicationName: strings.appTitle,
            ),
          ],
        ),
      ),
    );
  }
}

/// The language the app shows: the device's, or a launch language listed in
/// its own name and script, for whoever cannot read the one shown.
class _Language extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final language = ref.watch(settingsProvider.select((s) => s.language));
    final notifier = ref.read(settingsProvider.notifier);
    Text name(Locale? locale) => locale == null
        ? Text(strings.languageDevice)
        : Text(lookupAppLocalizations(locale).languageName, locale: locale);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.language),
      title: Text(strings.settingsLanguage),
      subtitle: name(language),
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(strings.settingsLanguage),
          children: [
            RadioGroup<Locale?>(
              groupValue: language,
              onChanged: (locale) {
                notifier.setLanguage(locale);
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  for (final locale in [null, ...launchLocales])
                    RadioListTile<Locale?>(value: locale, title: name(locale)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemePicker extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(strings.themeSystem),
        ),
        ButtonSegment(value: ThemeMode.light, label: Text(strings.themeLight)),
        ButtonSegment(value: ThemeMode.dark, label: Text(strings.themeDark)),
      ],
      selected: {ref.watch(settingsProvider).themeMode},
      onSelectionChanged: (modes) =>
          ref.read(settingsProvider.notifier).setThemeMode(modes.single),
    );
  }
}

/// How the viewer, its videos and the grid behave (VIEW-39, VIEW-14,
/// FMT-13): a switch each, the background of transparent images and the
/// viewer's bar.
class ViewingPage extends ConsumerWidget {
  /// The page, as Settings opens it.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final tokens = AppTokens.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.settingsViewing)),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.all(tokens.md),
          children: [
            for (final toggle in Toggle.values)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.settingsToggle(toggle.name)),
                value: settings.isOn(toggle),
                onChanged: (on) => notifier.setToggle(toggle, on: on),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.viewerFilmstrip),
              value:
                  settings.filmstrip ??
                  MediaQuery.sizeOf(context).width >= wideViewer,
              onChanged: (on) => notifier.setFilmstrip(on: on),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.viewerHdr),
              value: settings.hdr,
              onChanged: (_) => notifier.toggleHdr(),
            ),
            SizedBox(height: tokens.md),
            Text(strings.settingsBackground),
            SizedBox(height: tokens.sm),
            SegmentedButton<ViewerBackground>(
              segments: [
                for (final background in ViewerBackground.values)
                  ButtonSegment(
                    value: background,
                    label: Text(strings.viewerBackground(background.name)),
                  ),
              ],
              selected: {settings.background},
              onSelectionChanged: (chosen) =>
                  notifier.setBackground(chosen.single),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.view_week_outlined),
              title: Text(strings.settingsViewerBar),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ToolbarPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings › Viewer › Toolbar (docs/10 §4.6, VIEW-40): the actions pinned
/// to the viewer's bar, in order, which buttons move up and down, remove and
/// a drag reorders, then those in its `⋮` menu, which a button adds; and a
/// reset. Only the actions this platform has show.
class ToolbarPage extends ConsumerWidget {
  /// The page, from Settings or the viewer's menu.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final tokens = AppTokens.of(context);
    final stored = ref.watch(settingsProvider.select((s) => s.bar));
    final notifier = ref.read(settingsProvider.notifier);
    final pins = [...stored.where(onThisPlatform)];
    // The actions this platform lacks keep their place after the others.
    void set(List<ViewerAction> to) =>
        notifier.setBar([...to, ...stored.where((a) => !onThisPlatform(a))]);
    return Scaffold(
      appBar: AppBar(title: Text(strings.settingsViewerBar)),
      body: ContentWidth(
        child: ListView(
          padding: EdgeInsets.all(tokens.md),
          children: [
            Text(strings.toolbarInBar, style: textTheme.titleMedium),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorderItem: (from, to) {
                final order = [...pins];
                set(order..insert(to, order.removeAt(from)));
              },
              children: [
                for (var i = 0; i < pins.length; i++)
                  _pin(strings, pins, i, set),
              ],
            ),
            SizedBox(height: tokens.md),
            Text(strings.toolbarInMenu, style: textTheme.titleMedium),
            for (final action in ViewerAction.values)
              if (onThisPlatform(action) && !pins.contains(action))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(actionIcon(action)),
                  title: Text(actionLabel(action, strings)),
                  trailing: _button(
                    Icons.add_circle_outline,
                    strings.toolbarAdd(actionLabel(action, strings)),
                    () => set([...pins, action]),
                  ),
                ),
            SizedBox(height: tokens.md),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton(
                onPressed: () => notifier.setBar(defaultPins),
                child: Text(strings.toolbarReset),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _button(
    IconData icon,
    String tooltip,
    VoidCallback? onPressed,
  ) => IconButton(icon: Icon(icon), tooltip: tooltip, onPressed: onPressed);

  /// The pin at [i] of [pins], with buttons that [set] them moved up and
  /// down or without it.
  Widget _pin(
    AppLocalizations strings,
    List<ViewerAction> pins,
    int i,
    void Function(List<ViewerAction>) set,
  ) {
    final label = actionLabel(pins[i], strings);
    void swap(int j) => set(
      [...pins]
        ..[i] = pins[j]
        ..[j] = pins[i],
    );
    return ListTile(
      key: ValueKey(pins[i]),
      contentPadding: EdgeInsets.zero,
      leading: Icon(actionIcon(pins[i])),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(
            Icons.arrow_upward,
            strings.toolbarUp(label),
            i == 0 ? null : () => swap(i - 1),
          ),
          _button(
            Icons.arrow_downward,
            strings.toolbarDown(label),
            i == pins.length - 1 ? null : () => swap(i + 1),
          ),
          _button(
            Icons.remove_circle_outline,
            strings.toolbarRemove(label),
            () => set([...pins]..removeAt(i)),
          ),
          // The handle of a drag, beside the buttons.
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

/// Opens the private libraries' keys and recovery (ADR-0255).
class _PrivacyTile extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.lock_outline),
    title: Text(AppLocalizations.of(context).privacyTitle),
    onTap: () => context.push('/settings/privacy'),
  );
}

/// What the app opens on, and the tab the folders and albums open on.
class _StartScreen extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final tokens = AppTokens.of(context);
    final gap = SizedBox(height: tokens.sm);
    return Padding(
      padding: EdgeInsets.only(top: tokens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.settingsStart, style: textTheme.titleMedium),
          gap,
          SegmentedButton<StartScreen>(
            segments: [
              for (final screen in StartScreen.values)
                ButtonSegment(
                  value: screen,
                  label: Text(strings.startScreen(screen.name)),
                ),
            ],
            selected: {settings.startScreen},
            onSelectionChanged: (s) => notifier.setStartScreen(s.single),
          ),
          gap,
          Text(strings.settingsDefaultTab, style: textTheme.titleSmall),
          gap,
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(strings.settingsFolders)),
              ButtonSegment(value: true, label: Text(strings.collectionAlbums)),
            ],
            selected: {settings.albumsFirst},
            onSelectionChanged: (s) =>
                notifier.setAlbumsFirst(albums: s.single),
          ),
        ],
      ),
    );
  }
}
