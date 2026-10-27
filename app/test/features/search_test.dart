import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/search/search_page.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/viewer/slideshow.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/ui/media_grid.dart';
import 'package:photolib_api/photolib_api.dart'
    show SearchHit, SearchTextRequest, SearchTextResponse, ServerError;
import 'package:photolib_data/photolib_data.dart';

import '../support/fake_server.dart';
import '../support/pump_app.dart';
import '../support/viewer.dart';

class _FakeVault extends Fake implements Vault {
  @override
  bool get rebuilt => false;
}

/// A MediaStore item [n] in [folder], taken at [n] o'clock on [day] of March
/// 2024.
LocalAssetCompanion _item(
  int n,
  String name, {
  String folder = 'DCIM/Camera/',
  int day = 1,
  bool favorite = false,
  String? make,
  String? model,
}) => LocalAssetCompanion.insert(
  id: Uint8List(16)..[15] = n,
  source: 'mediastore',
  volume: const Value('external_primary'),
  sourceId: '$n',
  size: 1,
  mtime: n,
  path: Value(folder),
  name: Value(name),
  mime: Value(name.endsWith('.mp4') ? 'video/mp4' : 'image/jpeg'),
  takenLocal: Value('2024-03-${'$day'.padLeft(2, '0')}T0$n:00:00'),
  favorite: Value(favorite ? 1 : 0),
  make: Value(make),
  model: Value(model),
);

void main() {
  late Replica db;
  setUp(() => db = Replica(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> openSearch(
    WidgetTester tester,
    List<LocalAssetCompanion> items, {
    Size size = const Size(400, 800),
    ThumbnailPipeline? pipeline,
    List<Override> overrides = const [],
  }) async {
    await db.batch((b) => b.insertAll(db.localAsset, items));
    // Filed under their folders, as the MediaStore index files them.
    await db.customStatement(
      'INSERT OR IGNORE INTO device_folder (volume, path) '
      'SELECT volume, path FROM local_asset',
    );
    await db.customStatement(
      'UPDATE local_asset SET folder = (SELECT id FROM device_folder f '
      'WHERE f.volume = local_asset.volume AND f.path = local_asset.path)',
    );
    await pumpApp(
      tester,
      size: size,
      replica: (_) => db,
      overrides: [
        thumbnailPipelineProvider.overrideWith(
          (ref) async => pipeline ?? Grey(),
        ),
        ...overrides,
      ],
    );
    await tester.tapAndSettle(find.text('Search'));
  }

  /// Unmounts the app, so that drift closes its queries on the test's clock.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    // The search runs once typing pauses.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  /// Taps [finder], a chip of the row that scrolls them, or a text.
  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tapAndSettle(finder);
  }

  /// The names in the results, in order.
  List<String> shown(WidgetTester tester) => [
    for (final text in tester.widgetList<Text>(
      find.descendant(of: find.byType(GridView), matching: find.byType(Text)),
    ))
      text.data!,
  ];

  /// The thumbnails [of] shows.
  Finder thumbnails(Finder of) => find.descendant(
    of: of,
    matching: find.byWidgetPredicate((w) => w is RawImage && w.image != null),
  );

  testWidgets('the pictures whose text the server read are found by that text, '
      'and the search falls back to names when it cannot', (tester) async {
    const payload = '<img src=x onerror=alert(1)>';
    final sign = Uint8List(16)..[15] = 77;
    final server = FakeServer({
      'SearchService/SearchText': (request) {
        final query = (request as SearchTextRequest).query;
        if (query == 'offline') throw ServerError('unavailable', null);
        return SearchTextResponse(
          hits: [
            if (query == 'estacao' || query == payload)
              SearchHit(assetId: uuidOf(sign), text: payload),
          ],
        );
      },
    });
    await openSearch(
      tester,
      [_item(1, 'IMG_1.jpg'), _item(2, 'IMG_2.jpg'), _item(3, 'estacao.jpg')],
      overrides: [sessionProvider.overrideWithValue(server)],
    );
    await db.customStatement(
      'UPDATE local_asset SET asset_id = ? WHERE source_id = ?',
      [sign, '2'],
    );

    await type(tester, 'estacao');
    expect(shown(tester), ['estacao.jpg', 'IMG_2.jpg']);
    expect(
      server.requests<SearchTextRequest>('SearchService/SearchText').last.query,
      'estacao',
    );

    // Markup a picture holds is only ever text: it asks the server as text
    // and finds its picture.
    await type(tester, payload);
    expect(shown(tester), ['IMG_2.jpg']);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      payload,
      reason: 'markup is the text of the query and nothing else',
    );

    await type(tester, 'offline');
    expect(
      shown(tester),
      isEmpty,
      reason: 'a server that fails finds nothing more',
    );
    await type(tester, 'img');
    expect(shown(tester), ['IMG_2.jpg', 'IMG_1.jpg']);
    await unmount(tester);
  });

  testWidgets('words and filters find items, newest first, with their count', (
    tester,
  ) async {
    await openSearch(tester, [
      _item(1, 'IMG_1.jpg'),
      _item(2, 'VID_2.mp4'),
      _item(3, 'IMG_3.jpg', favorite: true),
      _item(4, 'Screenshot_4.png', folder: 'Pictures/Screenshots/'),
    ]);
    expect(find.text('Search your library'), findsOneWidget);

    await type(tester, 'img');
    expect(find.text('2 items'), findsOneWidget);
    expect(shown(tester), ['IMG_3.jpg', 'IMG_1.jpg']);

    await tap(tester, find.text('Favourites'));
    expect(shown(tester), ['IMG_3.jpg']);
    expect(find.text('1 item'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(GridView),
        matching: find.byIcon(Icons.favorite),
      ),
      findsOneWidget,
      reason: 'a favourite carries its badge',
    );

    await tester.tapAndSettle(find.byTooltip('Clear text'));
    expect(shown(tester), ['IMG_3.jpg']);
    await tap(tester, find.text('Favourites'));
    expect(find.text('Search your library'), findsOneWidget);

    await tap(tester, find.text('Videos'));
    expect(shown(tester), ['VID_2.mp4']);
    await tap(tester, find.text('Photos'));
    expect(shown(tester), ['Screenshot_4.png', 'IMG_3.jpg', 'IMG_1.jpg']);
    await tap(tester, find.text('Screenshots'));
    expect(shown(tester), ['Screenshot_4.png']);

    await type(tester, 'nothing');
    expect(find.text('Nothing matches'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('folders and cameras are chosen from those of the library', (
    tester,
  ) async {
    await openSearch(tester, [
      _item(1, 'a.jpg', folder: 'DCIM/Trip/', make: 'Google', model: 'Pixel 7'),
      _item(2, 'b.jpg', folder: 'Pictures/', make: 'Canon', model: 'Canon R5'),
      _item(3, 'c.jpg', folder: 'Pictures/', make: 'Canon', model: 'Canon R5'),
    ]);
    await tap(tester, find.text('Folder'));
    await tester.tapAndSettle(find.byTooltip('Expand'));
    for (final (folder, items) in [
      ('DCIM', '1 item'),
      ('Trip', '1 item'),
      ('Pictures', '2 items'),
    ]) {
      expect(
        find.descendant(
          of: find.widgetWithText(ListTile, folder),
          matching: find.textContaining(items),
        ),
        findsOneWidget,
      );
    }
    await tester.tapAndSettle(find.text('Trip'));
    expect(shown(tester), ['a.jpg']);

    await tap(tester, find.byTooltip('Delete'));
    expect(find.text('Search your library'), findsOneWidget);

    await tap(tester, find.text('Camera'));
    expect(find.text('Google Pixel 7'), findsOneWidget);
    await tester.tapAndSettle(find.text('Canon R5'));
    expect(shown(tester), ['c.jpg', 'b.jpg']);
    expect(
      find.widgetWithText(InputChip, 'Canon R5'),
      findsOneWidget,
      reason: 'the chip names the camera',
    );
    await unmount(tester);
  });

  testWidgets('a date range finds what was taken on those days', (
    tester,
  ) async {
    await openSearch(tester, [
      _item(1, 'a.jpg', day: 9),
      _item(2, 'b.jpg', day: 10),
      _item(3, 'c.jpg', day: 12),
      _item(4, 'd.jpg', day: 13),
      // Flutter's full-screen picker of a phone overflows in the test font.
    ], size: const Size(1280, 800));
    await tap(tester, find.text('Dates'));
    await tester.tapAndSettle(find.byTooltip('Switch to input'));
    final fields = find.byType(TextField);
    await tester.enterText(
      fields.at(fields.evaluate().length - 2),
      '03/10/2024',
    );
    await tester.enterText(fields.last, '03/12/2024');
    await tester.tapAndSettle(find.text('OK'));
    expect(shown(tester), ['c.jpg', 'b.jpg']);
    expect(find.text('Mar 10, 2024 – Mar 12, 2024'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('results show their thumbnails, which a long press previews '
      'while selecting, and open in the viewer', (tester) async {
    await openSearch(tester, [
      for (var n = 1; n <= 3; n++) _item(n, 'IMG_$n.jpg'),
    ]);
    await type(tester, 'jpg');
    expect(thumbnails(find.byType(GridView)), findsNWidgets(3));
    await tester.longPress(find.text('IMG_2.jpg'));
    await tester.pumpAndSettle();
    final press = await tester.startGesture(
      tester.getCenter(find.text('IMG_1.jpg')),
    );
    await tester.pump(kLongPressTimeout * 2);
    expect(thumbnails(find.byKey(const ValueKey('peek'))), findsOneWidget);
    await press.up();
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.byTooltip('Clear selection'));
    await tester.tapAndSettle(find.text('IMG_1.jpg'));
    expect(find.byType(ViewerPage), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('results are selected as in the library', (tester) async {
    await openSearch(tester, [
      for (var n = 1; n <= 3; n++) _item(n, 'IMG_$n.jpg'),
    ]);
    await type(tester, 'jpg');
    await tester.longPress(find.text('IMG_2.jpg'));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    await tester.tapAndSettle(find.text('IMG_1.jpg'));
    expect(find.text('2 selected'), findsOneWidget);
    await tester.tapAndSettle(find.byTooltip('Select all'));
    expect(find.text('3 selected'), findsOneWidget);
    await tester.tapAndSettle(find.byTooltip('Clear selection'));
    expect(find.text('3 items'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('a column count it does not offer, as a later build may keep, '
      'shows the default', (tester) async {
    await db.batch((b) => b.insertAll(db.localAsset, [_item(1, 'IMG_1.jpg')]));
    await pumpApp(
      tester,
      replica: (_) => db,
      settings: MemoryStore('{"searchColumns":5}'),
    );
    await tester.tapAndSettle(find.text('Search'));
    await type(tester, 'img');
    expect(tester.widget<MediaGrid>(find.byType(MediaGrid)).columns, 4);
    await tester.tapAndSettle(find.byTooltip('Zoom out'));
    expect(tester.widget<MediaGrid>(find.byType(MediaGrid)).columns, 6);
    await unmount(tester);
  });

  for (final failing in ['replica', 'vault']) {
    testWidgets('a local store whose $failing cannot open says so, and '
        'searches on retry', (tester) async {
      await db.batch(
        (b) => b.insertAll(db.localAsset, [_item(1, 'IMG_1.jpg')]),
      );
      var opens = 0;
      Future<T> open<T>(T opened) async => ++opens == 1
          // As a browser's database worker, or the keystore, fails.
          ? throw StateError('database worker error')
          : opened;
      await pumpApp(
        tester,
        replica: (ref) async {
          if (failing == 'replica') return await open(db);
          await ref.watch(vaultProvider.future);
          return db;
        },
        vault: failing == 'vault' ? () => open(_FakeVault()) : null,
      );
      await tester.tapAndSettle(find.text('Search'));
      await type(tester, 'img');
      final search = find.byType(SearchPage);
      expect(
        find.descendant(
          of: search,
          matching: find.text(
            'Photolib could not open the library kept on this device',
          ),
        ),
        findsOneWidget,
      );

      await tester.tapAndSettle(
        find.descendant(of: search, matching: find.text('Try again')),
      );
      expect(shown(tester), ['IMG_1.jpg']);
      expect(opens, 2);
      await unmount(tester);
    });
  }

  testWidgets('the results play as a slideshow, or those selected', (
    tester,
  ) async {
    final grey = Grey();
    await openSearch(tester, [
      for (var n = 1; n <= 3; n++) _item(n, 'IMG_$n.jpg'),
    ], pipeline: grey);
    await type(tester, 'jpg');
    Future<List<String>> play() async {
      grey.asked.clear();
      await tester.tapAction('Slideshow');
      expect(find.byType(SlideshowPage), findsOneWidget);
      for (var i = 0; i < 3; i++) {
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
      }
      expect(find.byType(SlideshowPage), findsNothing);
      return [for (final uri in grey.asked) uri.pathSegments.last];
    }

    expect(await play(), ['3', '2', '1'], reason: 'newest first');
    await tester.longPress(find.text('IMG_3.jpg'));
    await tester.pumpAndSettle();
    await tester.tapAndSettle(find.text('IMG_1.jpg'));
    expect(await play(), ['3', '1']);
    expect(find.text('2 selected'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('a finger on a result starts its screen-size decode, which the '
      'viewer it opens takes over', (tester) async {
    final grey = Grey();
    await openSearch(tester, [
      for (var n = 1; n <= 3; n++) _item(n, 'IMG_$n.jpg'),
    ], pipeline: grey);
    await type(tester, 'jpg');
    final finger = await tester.startGesture(
      tester.getCenter(find.text('IMG_2.jpg')),
    );
    await tester.pump();
    expect(grey.at(512), ['2'], reason: 'while the finger is down');
    await finger.up();
    await tester.pumpAndSettle();
    expect(find.byType(ViewerPage), findsOneWidget);
    expect(grey.at(512).where((f) => f == '2'), hasLength(1));
    await unmount(tester);
  });
}
