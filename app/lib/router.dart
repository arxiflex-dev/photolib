import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/errors.dart';
import 'package:photolib/core/logging.dart';
import 'package:photolib/core/observers.dart';
import 'package:photolib/features/admin/admin_page.dart';
import 'package:photolib/features/collections/collections_page.dart';
import 'package:photolib/features/folders/device_folders.dart';
import 'package:photolib/features/folders/folders_page.dart';
import 'package:photolib/features/folders/items_page.dart';
import 'package:photolib/features/gallery/onboarding.dart';
import 'package:photolib/features/gallery/shortcuts.dart';
import 'package:photolib/features/library/library_page.dart';
import 'package:photolib/features/map/map_page.dart';
import 'package:photolib/features/offline/storage_page.dart';
import 'package:photolib/features/passphrase/passphrase_prompt.dart';
import 'package:photolib/features/privacy/privacy_page.dart';
import 'package:photolib/features/search/search_page.dart';
import 'package:photolib/features/servers/accounts_ui.dart';
import 'package:photolib/features/servers/setup_link.dart';
import 'package:photolib/features/settings/diagnostics.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/settings/settings_page.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/app_shell.dart';

StatefulShellBranch _tab(String path, Widget Function() page) =>
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          builder: (context, state) => AccountScope(child: page()),
        ),
      ],
    );

/// The app's routes: three tabs in a shell, settings and the console.
final Provider<GoRouter> routerProvider = Provider((ref) {
  final router = GoRouter(
    // Read once: the settings are loaded before the app starts.
    initialLocation: ref.read(settingsProvider).startLocation,
    observers: [NavigationLog()],
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            PassphraseGate(child: AppShell(shell: shell)),
        branches: [
          _tab('/library', LibraryPage.new),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/collections',
                builder: (context, state) =>
                    const AccountScope(child: CollectionsPage()),
                routes: [
                  for (final (path, tab) in [('folders', 0), ('albums', 1)])
                    GoRoute(
                      path: path,
                      builder: (context, state) => FoldersPage(tab: tab),
                    ),
                  GoRoute(
                    path: 'map',
                    builder: (context, state) => const MapPage(),
                  ),
                  GoRoute(
                    path: 'favourites',
                    builder: (context, state) =>
                        const ItemsPage(ItemsSource.favourites()),
                  ),
                ],
              ),
            ],
          ),
          _tab('/search', SearchPage.new),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: 'diagnostics',
            builder: (context, state) => const DiagnosticsPage(),
          ),
          GoRoute(
            path: 'folders',
            builder: (context, state) => const SourcesPage(),
          ),
          GoRoute(
            path: 'storage',
            builder: (context, state) => const StoragePage(),
          ),
          GoRoute(
            path: 'viewing',
            builder: (context, state) => const ViewingPage(),
          ),
          GoRoute(
            path: 'privacy',
            builder: (context, state) => const PrivacyPage(),
          ),
          GoRoute(
            path: 'gallery',
            builder: (context, state) => const OnboardingPage(),
          ),
        ],
      ),
      GoRoute(path: '/admin', builder: (context, state) => const AdminPage()),
      // A home-screen shortcut or widget to a folder or an album
      // (ADR-0401).
      for (final kind in ['folder', 'album'])
        GoRoute(
          path: '/shortcut/$kind',
          builder: (context, state) => switch (shortcutSource(state.uri)) {
            final source? => ItemsPage(source),
            null => ErrorView(
              message: AppLocalizations.of(context).errorNotFound,
            ),
          },
        ),
      // A password setup link (ADR-0243): SetupLinks opens it over the library.
      GoRoute(
        path: '/password-setup',
        redirect: (context, state) {
          // On the web the page is the link, until the router leaves it.
          final link = setupLink(state.uri, page: kIsWeb ? Uri.base : null);
          // Not while the router builds, which no provider may change during.
          scheduleMicrotask(
            () => ref.read(openedSetupLinkProvider.notifier).open(link),
          );
          return '/library';
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: ErrorView(message: AppLocalizations.of(context).errorNotFound),
    ),
  );
  // Each scope's router stops taking the platform's links with the scope.
  ref.onDispose(router.dispose);
  final location = router.routeInformationProvider;
  location.addListener(
    () =>
        const Logger('photolib.navigation')
            .debug('location', fields: {'location': '${location.value.uri}'}),
  );
  return router;
});
