import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/app.dart';
import 'package:photolib/core/kept.dart';
import 'package:photolib/core/keystore.dart';
import 'package:photolib/core/providers.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/backup/backup.dart';
import 'package:photolib/features/collections/collections.dart';
import 'package:photolib/features/folders/views.dart';
import 'package:photolib/features/offline/offline.dart';
import 'package:photolib/features/servers/nearby.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/viewer/slideshow.dart';
import 'package:photolib_data/photolib_data.dart' show Replica, Vault;

/// A vault object, in memory, read once [answered].
class MemoryStore implements SecretStore {
  new([this.value, this.answered]);
  String? value;
  final Future<void>? answered;

  @override
  Future<String?> read() async {
    await answered;
    return value;
  }

  @override
  Future<void> write(String? value) async => this.value = value;
}

extension SettledTap on WidgetTester {
  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettle();
  }

  /// Taps the selection bar's action [tooltip], in the bar's `More` menu when
  /// the window is too narrow to hold it.
  Future<void> tapAction(String tooltip) async {
    final button = find.byTooltip(tooltip);
    if (button.evaluate().isNotEmpty) {
      await tap(button.last);
    } else {
      await tap(find.byTooltip('More'));
      await pumpAndSettle();
      await tap(find.text(tooltip));
    }
    await pumpAndSettle();
  }

  /// Scrolls the page to [finder], which a long list such as Settings builds
  /// only near the screen, and lays the jump out before anything taps it.
  Future<void> scrollTo(Finder finder) async {
    await scrollUntilVisible(finder, 100);
    await pump();
  }

  /// Pumps frames while real time passes until [done]: the app's file and
  /// database work needs real time, which a widget test's frames do not pass,
  /// as long as a loaded machine's disk takes. Fails once its own waits add up
  /// to [within], which a stopped process (SIGSTOP) does not run out. Each
  /// frame advances the test's clock by [step], as an animation needs.
  Future<void> pumpUntil(
    FutureOr<bool> Function() done, {
    Duration within = const Duration(minutes: 2),
    Duration step = Duration.zero,
  }) async {
    const frame = Duration(milliseconds: 5);
    for (var waited = Duration.zero; !await done(); waited += frame) {
      if (waited > within) fail('not done after $within');
      await runAsync(() => Future<void>.delayed(frame));
      await pump(step);
    }
  }

  /// Presses [key] while holding [modifiers]; true when the app handled it.
  Future<bool> pressKey(
    LogicalKeyboardKey key, {
    List<LogicalKeyboardKey> modifiers = const [],
    String? character,
  }) async {
    for (final modifier in modifiers) {
      await sendKeyDownEvent(modifier);
    }
    final handled = await sendKeyEvent(key, character: character);
    for (final modifier in modifiers.reversed) {
      await sendKeyUpEvent(modifier);
    }
    await pumpAndSettle();
    return handled;
  }
}

Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(400, 800),
  double dpr = 1,
  List<Override> overrides = const [],
  List<Locale>? locales,
  FutureOr<Replica> Function(Ref ref)? replica,
  SecretStore? serverStore,
  SecretStore? settings,
  Future<Vault> Function()? vault,
  SecretStore? kept,
  SecretStore? folderViews,
  List<Nearby> nearby = const [],
}) async {
  tester.view.physicalSize = size * dpr;
  tester.view.devicePixelRatio = dpr;
  addTearDown(tester.view.reset);
  // Last in, first out: the app is gone, and its streams with it, before a
  // test's `tearDown` closes the database they read, which waits for them.
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  });
  if (locales != null) {
    tester.platformDispatcher.localesTestValue = locales;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  }
  await tester.pumpWidget(
    ProviderScope(
      retry: retry,
      overrides: [
        // The vault's data isolate needs real time, which a widget test does
        // not give it: the replica never opens unless the test brings one.
        replicaProvider.overrideWith(
          (ref) => replica?.call(ref) ?? Completer<Replica>().future,
        ),
        vaultProvider.overrideWith(
          (ref) => vault?.call() ?? Completer<Vault>().future,
        ),
        serverStoreProvider.overrideWithValue(serverStore ?? MemoryStore()),
        settingsStoreProvider.overrideWithValue(settings ?? MemoryStore()),
        keepAwakeProvider.overrideWithValue(({required enable}) async {}),
        backupStoreProvider.overrideWithValue(MemoryStore()),
        collectionsStoreProvider.overrideWithValue(MemoryStore()),
        offlinePolicyStoreProvider.overrideWithValue(MemoryStore()),
        offlinePinsStoreProvider.overrideWithValue(MemoryStore()),
        keptStoreProvider.overrideWithValue(kept ?? MemoryStore()),
        folderViewsStoreProvider.overrideWithValue(
          folderViews ?? MemoryStore(),
        ),
        networkChangesProvider.overrideWithValue(const Stream.empty()),
        nearbyProvider.overrideWith((ref) async => nearby),
        ...overrides,
      ],
      child: const PhotolibApp(),
    ),
  );
  await tester.pumpAndSettle();
}
