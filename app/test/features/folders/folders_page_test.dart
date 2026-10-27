import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/app.dart';
import 'package:photolib/core/deletion.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/collections/collections.dart';
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/folders/views.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

import '../../support/media_platform.dart';
import '../../support/pump_app.dart';
import '../../support/viewer.dart';

void main() {
  late Replica db;
  late MemoryStore views;
  late int next;
  late FakePlatform platform;
  setUp(() {
    db = Replica(NativeDatabase.memory());
    views = MemoryStore();
    next = 0;
    platform = FakePlatform();
  });
  tearDown(() => db.close());

  Future<Uint8List> item(
    String path, {
    String source = 'mediastore',
    String volume = 'external_primary',
    int size = 1,
    int mtime = 0,
    int? durationMs,
    bool favorite = false,
    bool hidden = false,
  }) async {
    final id = Uint8List(16)..[15] = ++next;
    final name = path.split('/').last;
    await db
        .into(db.localAsset)
        .insert(
          LocalAssetCompanion.insert(
            id: id,
            source: source,
            volume: Value(volume),
            sourceId: '$next',
            size: size,
            mtime: mtime,
            path: Value(
              source == 'folder'
                  ? path
                  : path.substring(0, path.length - name.length),
            ),
            name: Value(source == 'folder' ? null : name),
            mime: Value(name.endsWith('.mp4') ? 'video/mp4' : 'image/jpeg'),
            durationMs: Value(durationMs),
            favorite: Value(favorite ? 1 : 0),
            hidden: Value(hidden ? 1 : 0),
          ),
        );
    return id;
  }

  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(500, 900),
    Grey? pipeline,
  }) => pumpApp(
    tester,
    size: size,
    replica: (_) => db,
    folderViews: views,
    overrides: [
      thumbnailPipelineProvider.overrideWith((ref) async => pipeline ?? Grey()),
      mediaPlatformProvider.overrideWithValue((_) => platform),
    ],
  );

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  Future<void> openFolders(WidgetTester tester) async {
    await tester.tapAndSettle(find.text('Collections'));
    await tester.tapAndSettle(find.text('Folders'));
  }

  List<String> titles(WidgetTester tester, Finder within) => [
    for (final t in tester.widgetList<ListTile>(
      find.descendant(of: within, matching: find.byType(ListTile)),
    ))
      if (t.title case Text(:final data?)) data,
  ];

  testWidgets('folder tiles show their count, the look of a folder and their '
      'volume; same-named folders on two volumes stay apart; junk folders '
      'wait behind one tap', (tester) async {
    await item('DCIM/Camera/a.jpg');
    await item('DCIM/Camera/b.jpg');
    await item('DCIM/Camera/c.jpg', volume: '0000-0000');
    await item('Music/Album/cover.jpg');
    await pump(tester);
    await openFolders(tester);
    final list = find.byType(ReorderableListView);
    expect(titles(tester, list), ['Camera', 'Camera']);
    expect(
      find.text('2 items\nDCIM/Camera/', findRichText: true),
      findsNothing,
    );
    expect(
      find.textContaining('2 items'),
      findsOneWidget,
      reason: 'the internal Camera',
    );
    expect(find.textContaining('1 item'), findsOneWidget);
    expect(find.text('Internal'), findsOneWidget);
    expect(find.text('SD card'), findsOneWidget);
    expect(
      find.descendant(of: list, matching: find.byIcon(Icons.folder)),
      findsNWidgets(2),
    );
    await tester.tapAndSettle(find.text('Show excluded folders (1)'));
    expect(titles(tester, list), ['Album', 'Camera', 'Camera']);
    await tester.tapAndSettle(find.text('Hide excluded folders'));
    expect(titles(tester, list), ['Camera', 'Camera']);
    await unmount(tester);
  });

  testWidgets('folders keep the order they are dragged into, pinned ones on '
      'top, through new files and a restart', (tester) async {
    for (final f in ['A', 'B', 'C']) {
      await item('$f/1.jpg');
    }
    await pump(tester);
    await openFolders(tester);
    final list = find.byType(ReorderableListView);
    expect(titles(tester, list), ['A', 'B', 'C']);
    // C dragged above A.
    final drag = await tester.startGesture(tester.getCenter(find.text('C')));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
    await drag.moveBy(
      tester.getCenter(find.text('A')) - tester.getCenter(find.text('C')),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await drag.up();
    await tester.pumpAndSettle();
    expect(titles(tester, list), ['C', 'A', 'B']);
    await tester.tapAndSettle(find.byTooltip('Pin B'));
    expect(titles(tester, list), ['B', 'C', 'A']);
    await item('0/1.jpg');
    await item('A/2.jpg');
    await tester.pumpAndSettle();
    expect(titles(tester, list), ['B', 'C', 'A', '0']);
    await unmount(tester);
    await pump(tester);
    await openFolders(tester);
    expect(titles(tester, list), ['B', 'C', 'A', '0']);
    await unmount(tester);
  });

  testWidgets('a folder sorts as the user chose, remembers it, lists names, '
      'sizes and dates, captions its videos, and the viewer pages in that '
      'order', (tester) async {
    await item('F/img10.jpg', size: 3000, mtime: 1);
    await item('F/img9.jpg', size: 1000, mtime: 3);
    await item('F/clip.mp4', size: 2000, mtime: 2, durationMs: 83000);
    await pump(tester);
    await openFolders(tester);
    await tester.tapAndSettle(find.text('F'));
    // Newest first by default; a video carries its name and length.
    expect(find.text('clip.mp4'), findsOneWidget);
    expect(find.text('1:23'), findsOneWidget);
    Future<void> choose(String option) async {
      await tester.tapAndSettle(find.byTooltip('View options'));
      await tester.tapAndSettle(
        find.widgetWithText(CheckedPopupMenuItem<ItemView>, option),
      );
    }

    await choose('Name');
    await choose('Ascending');
    await choose('List');
    expect(titles(tester, find.byType(ListView)), [
      'clip.mp4',
      'img9.jpg',
      'img10.jpg',
    ]);
    expect(find.textContaining('3 kB · '), findsOneWidget);
    expect(find.textContaining('1970'), findsNWidgets(3));
    expect(find.text('1:23'), findsOneWidget);
    await tester.tapAndSettle(find.text('img9.jpg'));
    final viewer = tester.widget<ViewerPage>(find.byType(ViewerPage));
    expect(viewer.position.value, 1);
    await viewer.pages.preload(0);
    expect(
      [
        for (var i = 0; i < 3; i++)
          (viewer.pages[i]! as ThumbnailItem).id?.last,
      ],
      [3, 2, 1],
      reason: 'clip.mp4, img9.jpg, img10.jpg',
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ViewerPage), findsNothing);
    await unmount(tester);
    final stored = jsonDecode(views.value!) as Map<String, Object?>;
    expect(
      (stored['views']! as Map)['mediastore|external_primary|F/'],
      'name_asc_list_0',
    );
  });

  testWidgets('a hidden item stays out of folders, their counts and the '
      'favourites until hidden items show', (tester) async {
    await item('A/1.jpg', favorite: true);
    await item('A/2.jpg', favorite: true, hidden: true);
    await item('B/3.jpg', hidden: true);
    await pump(tester);
    for (final veiled in [false, true]) {
      await openFolders(tester);
      expect(titles(tester, find.byType(ReorderableListView)), [
        'A',
        if (veiled) 'B',
      ], reason: 'veiled: $veiled');
      expect(find.textContaining('2 items'), veiled ? findsOne : findsNothing);
      await tester.tapAndSettle(find.text('A'));
      expect(find.byType(ThumbnailAt), findsNWidgets(veiled ? 2 : 1));
      // Back to the folders, then to the collections.
      await tester.tapAndSettle(find.byType(BackButton));
      await tester.tapAndSettle(find.byType(BackButton));
      await tester.tapAndSettle(find.text('Favourites'));
      expect(find.byType(ThumbnailAt), findsNWidgets(veiled ? 2 : 1));
      await tester.tapAndSettle(find.byType(BackButton));
      if (veiled) break;
      await tester.tapAndSettle(find.text('Library'));
      await tester.tapAndSettle(
        find.byTooltip('Show hidden and archived items for 5 minutes'),
      );
    }
    await unmount(tester);
  });

  testWidgets("a folder's selection favourites, moves to the trash and "
      "hides, with undo, as the library's does", (tester) async {
    await item('A/1.jpg');
    await item('A/2.jpg');
    await pump(tester);
    await openFolders(tester);
    await tester.tapAndSettle(find.text('A'));
    Future<void> selectAll() async {
      await tester.longPress(find.byType(ThumbnailAt).first);
      await tester.tapAndSettle(find.byTooltip('Select all'));
    }

    await selectAll();
    await tester.tapAction('Favourite');
    expect(platform.calls, ['favorite true 1,2']);
    expect(find.byType(MarkBadges), findsNWidgets(2));
    await selectAll();
    await tester.tapAction('Favourite');
    expect(platform.calls.last, 'favorite false 1,2');

    await selectAll();
    await tester.tapAction('Move to trash');
    expect(platform.calls.last, 'trash 1,2');
    expect(find.byType(ThumbnailAt), findsNothing);
    await tester.tapAndSettle(find.text('Undo'));
    expect(platform.calls.last, 'restore 1,2');
    expect(find.byType(ThumbnailAt), findsNWidgets(2));

    await selectAll();
    await tester.tapAndSettle(find.byTooltip('Show menu'));
    await tester.tapAndSettle(find.text('Hide'));
    expect(find.byType(ThumbnailAt), findsNothing);
    await tester.tapAndSettle(find.text('Undo'));
    expect(find.byType(ThumbnailAt), findsNWidgets(2));
    await unmount(tester);
  });

  testWidgets("a finger on a folder's cell starts its screen-size decode, "
      'which the viewer it opens takes over', (tester) async {
    await item('A/1.jpg');
    await item('A/2.jpg');
    final grey = Grey();
    await pump(tester, pipeline: grey);
    await openFolders(tester);
    await tester.tapAndSettle(find.text('A'));
    final finger = await tester.startGesture(
      tester.getCenter(find.byType(ThumbnailAt).last),
    );
    await tester.pump();
    expect(grey.at(512), ['2'], reason: 'while the finger is down');
    await finger.up();
    await tester.pumpAndSettle();
    expect(find.byType(ViewerPage), findsOneWidget);
    expect(grey.at(512).where((f) => f == '2'), hasLength(1));
    await unmount(tester);
  });

  testWidgets('album folders nest, an album fills from a folder picked in '
      'its own sort, and keeps its own view', (tester) async {
    await item('F/a.jpg', mtime: 2);
    await item('F/b.jpg', mtime: 1);
    final trips = await createAlbumFolder(db, 'Trips');
    views.value =
        '{"views": {"mediastore|external_primary|F/": '
        '"name_desc_grid_0"}}';
    await pump(tester);
    await tester.tapAndSettle(find.text('Collections'));
    await tester.tapAndSettle(find.text('Albums'));
    await tester.tapAndSettle(find.text('Trips'));
    await tester.tapAndSettle(find.text('New album'));
    await tester.enterText(find.byType(TextField), 'Rome');
    await tester.pump();
    await tester.tapAndSettle(find.text('OK'));
    final rome = (await albumChildren(db, trips).first).single;
    expect(await albumPath(db, rome.id), ['Trips']);
    await tester.tapAndSettle(find.text('Rome'));
    expect(find.text('This album is empty'), findsOneWidget);
    await tester.tapAndSettle(find.byTooltip('Add to album'));
    await tester.tapAndSettle(find.text('F'));
    // The picker shows the folder by name, descending, as its view says.
    await tester.tapAndSettle(find.byType(ThumbnailAt).first);
    await tester.tapAndSettle(find.byTooltip('Add to album'));
    expect(
      [for (final a in await albumItems(db, rome.id).first) a.name],
      ['b.jpg'],
    );
    await tester.tapAndSettle(find.byTooltip('View options'));
    await tester.tapAndSettle(
      find.widgetWithText(CheckedPopupMenuItem<ItemView>, 'Name'),
    );
    expect(await albumView(db, rome.id), ('name_asc', 'grid'));
    await unmount(tester);
  });

  testWidgets('the app opens on the start screen and tab the user chose', (
    tester,
  ) async {
    await item('Music/x.jpg');
    await item('F/fav.jpg', favorite: true);
    for (final (stored, shown) in [
      ('{"startScreen": "folders", "albumsFirst": true}', 'New album'),
      ('{"startScreen": "folders"}', 'Show excluded folders (1)'),
      ('{"startScreen": "favourites"}', 'fav.jpg'),
    ]) {
      final container = ProviderContainer(
        overrides: [
          replicaProvider.overrideWith((ref) async => db),
          vaultProvider.overrideWith((ref) => Completer<Vault>().future),
          serverStoreProvider.overrideWithValue(MemoryStore()),
          settingsStoreProvider.overrideWithValue(MemoryStore(stored)),
          collectionsStoreProvider.overrideWithValue(MemoryStore()),
          folderViewsStoreProvider.overrideWithValue(
            MemoryStore('{"views": {"favourites": "name_asc_list_0"}}'),
          ),
          thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
        ],
      );
      await runPhotolib(container);
      await tester.pumpAndSettle();
      expect(find.text(shown), findsOneWidget, reason: stored);
      await unmount(tester);
      container.dispose();
      // Drift closes the queries the container held on a timer.
      await tester.pump(Duration.zero);
    }
  });

  testWidgets('Settings choose the start screen and the default tab', (
    tester,
  ) async {
    final settings = MemoryStore();
    await pumpApp(tester, settings: settings, size: const Size(800, 1200));
    await tester.tapAndSettle(find.byTooltip('Settings'));
    await tester.tapAndSettle(find.text('Folders and albums'));
    await tester.tapAndSettle(find.text('Albums'));
    final json = jsonDecode(settings.value!) as Map<String, Object?>;
    expect((json['startScreen'], json['albumsFirst']), ('folders', true));
  });

  group('desktop folder', () {
    late Directory tmp;
    late String root;
    setUp(() async {
      tmp = await Directory.systemTemp.createTemp('photolib-page-');
      root = tmp.path;
      for (final name in ['F/1.jpg', 'F/2.jpg']) {
        final file = File('$root/$name');
        await file.create(recursive: true);
        await file.writeAsString(name);
        await file.setLastModified(DateTime.utc(2001));
        await item(name, source: 'folder', volume: root);
      }
      await Directory('$root/G').create();
      await addFolder(db, root);
    });
    tearDown(() => tmp.delete(recursive: true));

    List<String> names(String dir) => [
      for (final e in Directory('$root/$dir').listSync())
        e.path.split('/').last,
    ]..sort();

    // Taps [target] where real I/O and workers run, as what a tap starts runs
    // in the tap's zone, which the test's fake clock would never finish.
    Future<void> tap(WidgetTester tester, Finder target) =>
        tester.runAsync(() => tester.tap(target));

    // Lets real time pass, frame by frame, until [done].
    Future<void> eventually(WidgetTester tester, bool Function() done) async {
      for (var i = 0; i < 800 && !done(); i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 25)),
        );
        await tester.pump();
      }
      await tester.pumpAndSettle();
      // What the frames finished calls back in the real zone.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }

    bool shows(Finder finder) => finder.evaluate().isNotEmpty;

    Future<void> select(WidgetTester tester) async {
      await pump(tester, size: const Size(900, 900));
      await openFolders(tester);
      await tester.tapAndSettle(find.text('F'));
      await tester.longPress(find.byType(ThumbnailAt).first);
      await tester.tapAndSettle(find.byTooltip('Select all'));
    }

    testWidgets('the move dialog starts in the current folder, goes up and '
        'into folders by name, makes a folder, moves file by file, keeps the '
        'time, remembers the target and undoes', (tester) async {
      await select(tester);
      await tap(tester, find.byTooltip('Move to…'));
      await eventually(tester, () => shows(find.byType(AlertDialog)));
      expect(find.text(isolated('$root/F')), findsOneWidget);
      final here = find.widgetWithText(FilledButton, 'Move here');
      expect(tester.widget<FilledButton>(here).onPressed, isNull);
      await tap(tester, find.byIcon(Icons.arrow_upward));
      await eventually(tester, () => shows(find.text('G')));
      await tap(tester, find.text('G'));
      await eventually(tester, () => shows(find.text(isolated('$root/G'))));
      await tap(tester, find.text('New folder'));
      await eventually(tester, () => shows(find.byType(TextField)));
      await tester.enterText(find.byType(TextField), 'H');
      await tester.pump();
      await tester.tap(find.text('OK'));
      final made = find.text(isolated('$root/G/H'));
      await eventually(tester, () => shows(made));
      expect(made, findsOneWidget);
      await tap(tester, here);
      await eventually(
        tester,
        () => views.value?.contains('$root/G/H') ?? false,
      );
      expect(find.byIcon(Icons.check), findsNWidgets(2));
      expect(names('G/H'), ['1.jpg', '2.jpg']);
      expect(
        File('$root/G/H/1.jpg').lastModifiedSync().toUtc(),
        DateTime.utc(2001),
      );
      expect(jsonDecode(views.value!), containsPair('recent', ['$root/G/H']));
      await tap(tester, find.text('Undo'));
      await eventually(tester, () => names('G/H').isEmpty);
      expect(names('F'), ['1.jpg', '2.jpg']);
      await unmount(tester);
    });

    testWidgets('deleting a folder asks with its count, then moves its items '
        'to the trash through the DeletionService, as one request the '
        'snack bar undoes', (tester) async {
      await pumpApp(
        tester,
        replica: (_) => db,
        folderViews: views,
        overrides: [
          thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
          mediaPlatformProvider.overrideWithValue((_) => platform),
        ],
      );
      await openFolders(tester);
      await tester.tapAndSettle(find.text('F'));
      for (final sure in [false, true]) {
        await tester.tapAndSettle(find.byType(PopupMenuButton<void>));
        await tap(tester, find.text('Delete folder'));
        await eventually(tester, () => shows(find.byType(AlertDialog)));
        expect(
          find.text(
            'Move the photos and videos in F to the trash?\n2 items\n'
            'From this device only',
          ),
          findsOneWidget,
        );
        await tester.tap(find.text(sure ? 'Move to trash' : 'Cancel'));
        await eventually(tester, () => !sure || platform.calls.isNotEmpty);
        expect(platform.calls, sure ? ['trash 1,2'] : isEmpty);
      }
      await eventually(
        tester,
        () => shows(find.text('2 items moved to the trash')),
      );
      expect(find.byType(ThumbnailAt), findsNothing);
      expect(await db.trashItems(false).get(), hasLength(2));
      await tap(tester, find.text('Undo'));
      await eventually(tester, () => platform.calls.length == 2);
      expect(platform.calls, ['trash 1,2', 'restore 1,2']);
      expect(await db.trashItems(false).get(), isEmpty);
      await unmount(tester);
    });
    testWidgets('a batch rename previews every name, refuses one too long '
        'and is undone', (tester) async {
      await select(tester);
      await tap(tester, find.byTooltip('Rename'));
      await eventually(tester, () => shows(find.byType(AlertDialog)));
      final pattern = find.widgetWithText(TextField, 'New name');
      await tester.enterText(pattern, 'Trip {n}');
      await tester.pumpAndSettle();
      expect(find.text('Trip 1.jpg'), findsOneWidget);
      expect(find.text('Trip 2.jpg'), findsOneWidget);
      await tester.enterText(pattern, 'x' * 300);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Too long: a name has at most 255 bytes'),
        findsNWidgets(2),
      );
      final rename = find.widgetWithText(TextButton, 'Rename');
      expect(tester.widget<TextButton>(rename).onPressed, isNull);
      await tester.enterText(pattern, 'Trip {n}');
      await tester.pumpAndSettle();
      await tap(tester, rename);
      await eventually(tester, () => shows(find.text('Files renamed: 2')));
      expect(names('F'), ['Trip 1.jpg', 'Trip 2.jpg']);
      await tap(tester, find.text('Undo'));
      // Each name passes through a temporary one: wait for the last.
      await eventually(
        tester,
        () => !names('F').any((n) => n.startsWith('Trip')),
      );
      expect(names('F'), ['1.jpg', '2.jpg']);
      await unmount(tester);
    });
  });

  test('collections list the folders and the favourites', () {
    expect(CollectionKind.values.take(3), [
      CollectionKind.albums,
      CollectionKind.folders,
      CollectionKind.favourites,
    ]);
  });
}
