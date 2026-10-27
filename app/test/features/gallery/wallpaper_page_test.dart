import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/folders/folders_page.dart' show Cover;
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/wallpaper_page.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/theme.dart';

import '../../support/viewer.dart' show Grey;

class _Platform implements GalleryPlatform {
  final set = <(Uri, WallpaperTarget)>[];
  PlatformException? fail;

  @override
  Future<void> setWallpaper(Uri uri, WallpaperTarget target) async {
    if (fail case final error?) throw error;
    set.add((uri, target));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  final item = ThumbnailItem(
    'a',
    Uri.parse('content://media/external_primary/images/media/5'),
    id: Uint8List(16),
  );
  late _Platform platform;
  setUp(() => platform = _Platform());

  Future<void> pump(WidgetTester tester, {double scale = 1}) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          galleryPlatformProvider.overrideWithValue(platform),
          thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
        ],
        child: MaterialApp(
          theme: appTheme(Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => WallpaperPage.show(context, item),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('previews the picture and sets it on both screens by default', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byType(Cover), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(platform.set, [(item.uri, WallpaperTarget.both)]);
    expect(find.text('Wallpaper set'), findsOneWidget);
    // The page closes once the wallpaper is set.
    expect(find.byType(WallpaperPage), findsNothing);
  });

  for (final (label, target) in [
    ('Home screen', WallpaperTarget.home),
    ('Lock screen', WallpaperTarget.lock),
    ('Home and lock screens', WallpaperTarget.both),
  ]) {
    testWidgets('sets the wallpaper of the $label only', (tester) async {
      await pump(tester);
      await tester.tap(find.text(label));
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(platform.set.single.$2, target);
    });
  }

  testWidgets('a wallpaper the phone refuses is reported and kept open', (
    tester,
  ) async {
    platform.fail = PlatformException(code: 'failed');
    await pump(tester);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('The wallpaper could not be set.'), findsOneWidget);
    expect(find.byType(WallpaperPage), findsOneWidget);
  });

  testWidgets('fits a narrow phone at 200 % text', (tester) async {
    await pump(tester, scale: 2);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.byType(FilledButton), 100);
    expect(tester.takeException(), isNull);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
