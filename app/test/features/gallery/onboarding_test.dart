import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/device_library.dart';
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/gallery_prefs.dart';
import 'package:photolib/features/gallery/onboarding.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/locales.dart';
import 'package:photolib/ui/theme.dart';
import 'package:photolib_data/photolib_data.dart' show MediaAccess;

import '../../support/pump_app.dart' show MemoryStore;

class _Platform implements GalleryPlatform {
  new({this.isDefault = false});

  final bool isDefault;
  final String camera = 'Pixel Camera';
  final opened = <SystemScreen>[];

  @override
  Future<GalleryStatus> status() async =>
      (isDefault: isDefault, camera: camera, shortcuts: true);

  @override
  Future<bool> open(SystemScreen screen) async {
    opened.add(screen);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _Access extends MediaAccessNotifier {
  new(this.access);

  final MediaAccess access;
  int requests = 0;

  @override
  Future<MediaAccess?> build() async => access;

  @override
  Future<void> request() async => requests++;
}

void main() {
  late _Platform platform;
  late MemoryStore store;
  setUp(() {
    platform = _Platform();
    store = MemoryStore();
  });

  Future<_Access> pump(
    WidgetTester tester, {
    MediaAccess access = MediaAccess.partial,
    bool manages = false,
    Locale locale = const Locale('en'),
    double scale = 1,
  }) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final media = _Access(access);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          galleryPlatformProvider.overrideWithValue(platform),
          galleryPrefsStoreProvider.overrideWithValue(store),
          mediaAccessProvider.overrideWith(() => media),
          canManageMediaProvider.overrideWith((ref) async => manages),
        ],
        child: MaterialApp(
          theme: appTheme(Brightness.light),
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: const [...launchLocales, ...pseudoLocales],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: const OnboardingPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return media;
  }

  const mediaWhy =
      'Without access to all your photos and videos, Photolib cannot '
      'show your library.';
  testWidgets('lists the steps and explains each permission, what breaks '
      'without it', (tester) async {
    await pump(tester);
    for (final text in [
      'Make Photolib your gallery',
      'Open photos with Photolib',
      'Without this, a photo you tap in another app opens in another gallery.',
      'Photos and videos',
      mediaWhy,
      'Fewer confirmation dialogs',
      'Without this, Android asks you each time you trash or delete photos.',
      'Notifications',
      'Without them you will not see that a backup has stalled.',
    ]) {
      await tester.scrollUntilVisible(find.text(text), 100);
      expect(find.text(text), findsOneWidget, reason: text);
    }
  });

  testWidgets('never asks for unrestricted battery use or all files', (
    tester,
  ) async {
    await pump(tester);
    // The only screens it can open: the default apps, MANAGE_MEDIA,
    // notifications and the app's details.
    expect(
      SystemScreen.values.map((s) => s.name),
      unorderedEquals([
        'defaultApps',
        'manageMedia',
        'notifications',
        'details',
      ]),
    );
    expect(find.textContaining('battery limits'), findsOneWidget);
  });

  testWidgets('names the default camera and which cameras hand off', (
    tester,
  ) async {
    await pump(tester);
    await tester.scrollUntilVisible(find.textContaining('Pixel Camera'), 100);
    expect(find.textContaining('Pixel Camera'), findsOneWidget);
    expect(find.textContaining('Aperture'), findsOneWidget);
  });

  testWidgets('warns that uninstalling deletes the vault key', (tester) async {
    await pump(tester);
    final warning = find.textContaining('uninstalling Photolib deletes');
    await tester.scrollUntilVisible(warning, 100);
    expect(warning, findsOneWidget);
    expect(find.textContaining('recovery code'), findsOneWidget);
  });

  testWidgets('each step opens its system screen, or asks for media access', (
    tester,
  ) async {
    final media = await pump(tester);
    Future<void> press(String step) async {
      final button = find.descendant(
        of: find.ancestor(of: find.text(step), matching: find.byType(Card)),
        matching: find.byType(OutlinedButton),
      );
      await tester.scrollUntilVisible(button, 100);
      await tester.tap(button);
      await tester.pump();
    }

    await press('Open photos with Photolib');
    await press('Photos and videos');
    await press('Fewer confirmation dialogs');
    await press('Notifications');
    expect(platform.opened, [
      SystemScreen.defaultApps,
      SystemScreen.manageMedia,
      SystemScreen.notifications,
    ]);
    expect(media.requests, 1);
  });

  testWidgets('a step already in place says so and has no button', (
    tester,
  ) async {
    platform = _Platform(isDefault: true);
    await pump(tester, access: MediaAccess.full, manages: true);
    expect(find.text('Done'), findsNWidgets(3));
    expect(find.byType(OutlinedButton), findsOneWidget);
    // Nor does it explain what it has: only the notifications are left.
    expect(find.textContaining('Without access'), findsNothing);
  });

  testWidgets('explains a permission once', (tester) async {
    await pump(tester);
    expect(find.textContaining('Without this, Android asks'), findsOneWidget);
    // Back again, the same device: the reasons are not repeated.
    await tester.pumpWidget(const SizedBox());
    await pump(tester);
    expect(find.textContaining('Without this, Android asks'), findsNothing);
    expect(find.text('Fewer confirmation dialogs'), findsOneWidget);
  });

  for (final locale in [const Locale('en', 'XA'), const Locale('ar', 'XB')]) {
    testWidgets('fits a narrow phone at 200 % text in $locale', (tester) async {
      await pump(tester, locale: locale, scale: 2);
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(ListView), const Offset(0, -3000));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}
