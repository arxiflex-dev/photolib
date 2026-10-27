import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/desktop/file_drag.dart';
import 'package:photolib/features/gallery/gallery_links.dart';
import 'package:photolib/features/servers/accounts_ui.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/servers/setup_link.dart';
import 'package:photolib/features/settings/store.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/adaptive.dart';
import 'package:photolib/ui/commands.dart';

/// The three stable tabs: a bottom bar on phones, a rail on larger windows.
class AppShell extends ConsumerWidget {
  /// The tabs of [shell].
  const new({required this.shell, super.key});

  /// go_router's shell, which keeps each tab's pages.
  final StatefulNavigationShell shell;

  /// Closes what the tabs pushed, which showed the account switched from
  /// (ADR-0234).
  void _switched(AsyncValue<String>? previous, AsyncValue<String> next) {
    if (previous?.value == null || previous?.value == next.value) return;
    for (final branch in shell.route.branches) {
      branch.navigatorKey.currentState?.popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(replicaNameProvider, _switched);
    final strings = AppLocalizations.of(context);
    final size = WindowSize.of(MediaQuery.sizeOf(context).width);
    final tabs = <(IconData, String, ShortcutActivator?)>[
      (Icons.photo_library_outlined, strings.tabLibrary, null),
      (Icons.collections_bookmark_outlined, strings.tabCollections, null),
      (Icons.search, strings.tabSearch, const CharacterActivator('/')),
    ];
    void select(int index) =>
        shell.goBranch(index, initialLocation: index == shell.currentIndex);
    void settings() => context.push('/settings');

    return GalleryLinks(
      child: SetupLinks(
        child: FileDrops(
          child: Commands(
            commands: [
              for (final (i, (icon, label, shortcut)) in tabs.indexed)
                Command(label, () => select(i), icon: icon, shortcut: shortcut),
              Command(
                strings.settingsTitle,
                settings,
                icon: Icons.settings_outlined,
                shortcut: primary(LogicalKeyboardKey.comma),
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                title: Text(strings.appTitle),
                actions: [
                  const AccountSwitcher(),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: strings.settingsTitle,
                    onPressed: settings,
                  ),
                ],
              ),
              body: Column(
                children: [
                  const StoreBanner(),
                  Expanded(
                    child: Row(
                      children: [
                        if (size != WindowSize.compact)
                          NavigationRail(
                            extended: size == WindowSize.expanded,
                            labelType: size == WindowSize.expanded
                                ? null
                                : NavigationRailLabelType.all,
                            selectedIndex: shell.currentIndex,
                            onDestinationSelected: select,
                            destinations: [
                              for (final (icon, label, _) in tabs)
                                NavigationRailDestination(
                                  icon: Icon(icon),
                                  label: Text(label),
                                ),
                            ],
                          ),
                        Expanded(child: shell),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: size == WindowSize.compact
                  ? NavigationBar(
                      selectedIndex: shell.currentIndex,
                      onDestinationSelected: select,
                      destinations: [
                        for (final (icon, label, _) in tabs)
                          NavigationDestination(icon: Icon(icon), label: label),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
