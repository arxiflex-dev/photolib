import 'dart:async';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/device_library.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/folders/device_folders.dart';
import 'package:photolib/features/library/library_page.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/features/viewer/info_panel.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/source_tree.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_data/testing.dart';
import 'package:photolib_harness/photolib_harness.dart';

import '../support/pump_app.dart';

/// Android's library, MediaStore, in memory; the tests index it.
class _Device extends FakeMediaStore implements DeviceLibrary {
  @override
  Future<MediaAccess> requestAccess() async => granted;

  @override
  Future<void> Function()? get select => null;

  @override
  Stream<void> get changes => const Stream.empty();

  @override
  Future<void> index(Replica replica) =>
      MediaStoreIndexer(replica, this).sync();

  /// Adds [name] to the folder [path] of the internal storage.
  void add(String name, String path, {int taken = 1600000000000}) =>
      (mounted['external_primary'] ??= FakeVolume()).add(
        name,
        path: path,
        taken: taken,
      );
}

/// Runs [work] on the database while the app runs: a query completes on the
/// real event loop, and what awaits it on the test's, which the app's own
/// queries also wait for.
Future<T> run<T>(WidgetTester tester, Future<T> Function() work) async {
  late T result;
  var done = false;
  unawaited(
    work().then((r) {
      result = r;
      done = true;
    }),
  );
  while (!done) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
  return result;
}

/// Lets the app's database work and the frames it causes run.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 40; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pumpAndSettle();
}

void main() {
  late Replica db;
  late _Device device;
  setUp(() {
    db = Replica(NativeDatabase.memory());
    device = _Device();
  });
  tearDown(() => db.close());

  /// The app on the phone, its library indexed.
  Future<void> pump(
    WidgetTester tester, {
    Size size = const Size(400, 800),
    FutureOr<Replica> Function(Ref ref)? replica,
  }) async {
    await pumpApp(
      tester,
      size: size,
      replica: replica ?? (_) => db,
      overrides: [
        deviceLibraryProvider.overrideWithValue(device),
        thumbnailPipelineProvider.overrideWith(
          (ref) async => ThumbnailPipeline(),
        ),
      ],
    );
    await settle(tester);
  }

  /// Taps [finder] and waits for what that writes: drift runs on timers.
  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await settle(tester);
  }

  /// Unmounts the app, so that drift closes its queries on the test's clock.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  Future<Map<String, bool>> shown() async => {
    for (final f in await db.deviceFolders().get()) f.name: !f.out,
  };

  Future<int> timeline() async => (await db.timelineDays(false, null).get())
      .fold<int>(0, (n, d) => n + d.count);

  /// The rows of the source tree, each its name indented by its depth.
  List<String> rows(WidgetTester tester) => [
    for (final tile in tester.widgetList<ListTile>(
      find.descendant(
        of: find.byType(SourceTree),
        matching: find.byType(ListTile),
      ),
    ))
      _indented(tile),
  ];

  testWidgets('Settings › Library › Device folders is the source tree: every '
      'bucket of every volume under the folders above it, searchable, an eye '
      'each', (tester) async {
    // 40 buckets on 3 volumes: bucket b holds b % 3 + 1 items.
    for (final (volume, buckets) in [
      ('external_primary', 20),
      ('1111-2222', 12),
      ('3333-4444', 8),
    ]) {
      final v = device.mounted[volume] = FakeVolume();
      for (var b = 0; b < buckets; b++) {
        final path = b == 0 && volume == 'external_primary'
            ? 'Android/data/com.app/cache/'
            : 'Pictures/$volume $b/';
        for (var i = 0; i <= b % 3; i++) {
          v.add('$i.jpg', path: path, taken: 1700000000000 - i * 86400000);
        }
      }
    }
    await run(tester, () => device.index(db));
    await pump(tester, size: const Size(600, 4000));
    await tap(tester, find.byTooltip('Settings'));
    await tap(tester, find.text('Device folders'));

    expect(rows(tester), [
      'This device',
      ' Internal storage',
      '  Android',
      '  Pictures',
      ' SD card',
      '  Pictures',
      ' SD card',
      '  Pictures',
    ]);
    expect(find.text('3 items · Nov 14, 2023 · Partly shown'), findsNothing);
    expect(find.byTooltip('Hide Pictures'), findsNWidgets(3));

    await tester.enterText(find.byType(TextField), 'SD 1111');
    await settle(tester);
    expect(rows(tester), isEmpty, reason: 'no such name');
    await tester.enterText(find.byType(TextField), '1111-2222 1');
    await settle(tester);
    expect(rows(tester), [
      'This device',
      ' SD card',
      '  Pictures',
      '   1111-2222 1',
      '   1111-2222 10',
      '   1111-2222 11',
    ]);
    expect(
      find.text('2 items · Nov 14, 2023'),
      findsNWidgets(2),
      reason: '1111-2222 1 and 10: bucket b holds b % 3 + 1',
    );

    await tap(tester, find.byTooltip('Hide 1111-2222 10'));
    expect(find.byTooltip('Show 1111-2222 10'), findsOneWidget);
    expect((await run(tester, shown))['1111-2222 10'], isFalse);

    await tester.enterText(find.byType(TextField), 'cache');
    await settle(tester);
    expect(
      find.byTooltip('Show cache'),
      findsOneWidget,
      reason: 'junk, hidden and still listed',
    );
    await unmount(tester);
  });

  testWidgets('5,000 folders build only the rows on screen, a screen a '
      'frame; tools/perf times the frames (device-folders-scroll)', (
    tester,
  ) async {
    await db.customStatement(
      'WITH RECURSIVE f(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM f '
      'WHERE i < 5000) INSERT INTO device_folder (id, volume, path, name, '
      "visibility) SELECT i, 'external_primary', 'F' || (i / 100) || '/F' || i "
      "|| '/', 'F' || i, IIF(i % 5 = 0, 'hidden', 'inherit') FROM f",
    );
    await db.customStatement(
      'INSERT INTO timeline_day SELECT 20240101, id, 0, 1 FROM device_folder',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [replicaProvider.overrideWith((ref) async => db)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: SourcesPage(),
        ),
      ),
    );
    await settle(tester);
    expect(find.text('5,000 items · Jan 1, 2024'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'F');
    await settle(tester);
    final list = tester.state<ScrollableState>(find.byType(Scrollable).last);
    var most = 0;
    while (list.position.pixels < list.position.maxScrollExtent) {
      list.position.jumpTo(
        min(list.position.pixels + 800, list.position.maxScrollExtent),
      );
      await tester.pump();
      most = max(most, find.byType(ListTile).evaluate().length);
    }
    expect(most, inInclusiveRange(1, 20));
    expect(
      find.text('F5000'),
      findsOneWidget,
      reason: 'the last, in natural order',
    );
    await unmount(tester);
  });

  testWidgets('from everything or from nothing: the device eye switches modes '
      'and keeps both lists', (tester) async {
    device
      ..add('a.jpg', 'DCIM/Camera/')
      ..add('b.png', 'Pictures/Screenshots/')
      ..add('c.jpg', 'WhatsApp/Media/WhatsApp Images/');
    await run(tester, () => device.index(db));
    await pump(tester, size: const Size(400, 1000));
    await tap(tester, find.byTooltip('Settings'));
    await tap(tester, find.text('Device folders'));
    // Every node with an e, the three folders among them.
    await tester.enterText(find.byType(TextField), 'e');
    await settle(tester);
    Future<void> flip(String folder) =>
        tap(tester, find.byTooltip(RegExp('^(Show|Hide) $folder\$')));

    await flip('Screenshots');
    expect(await run(tester, shown), {
      'Camera': true,
      'Screenshots': false,
      'WhatsApp Images': true,
    });
    await flip('This device');
    expect(
      find.text('Show only the chosen folders', findRichText: true),
      findsNothing,
    );
    expect(await run(tester, timeline), 0);
    await flip('Camera');
    expect(await run(tester, shown), {
      'Camera': true,
      'Screenshots': false,
      'WhatsApp Images': false,
    });
    expect(await run(tester, timeline), 1);

    await flip('This device');
    expect(await run(tester, timeline), 2);
    await flip('This device');
    expect(await run(tester, timeline), 1);
    await unmount(tester);
  });

  testWidgets('Device folders say when the local store cannot open, and Try '
      'again opens it again', (tester) async {
    device.add('a.jpg', 'DCIM/Camera/');
    await run(tester, () => device.index(db));
    var fails = true;
    await pump(
      tester,
      size: const Size(400, 1000),
      replica: (_) async =>
          fails ? throw StateError('database worker error') : db,
    );
    await tap(tester, find.byTooltip('Settings'));
    await tap(tester, find.text('Device folders'));
    expect(
      find.text('Photolib could not open the library kept on this device'),
      findsOneWidget,
    );
    expect(rows(tester), isEmpty);
    expect(takeProblems(), [contains('indexing failed')]);

    fails = false;
    await tap(tester, find.text('Try again'));
    expect(find.text('Try again'), findsNothing);
    expect(rows(tester), ['This device', ' Internal storage', '  DCIM']);
    await unmount(tester);
  });

  testWidgets('a folder that comes after the first index is shown, or not '
      'while only the chosen are, and the app asks once to keep or exclude '
      'it', (tester) async {
    device.add('a.jpg', 'DCIM/Camera/');
    await run(tester, () => device.index(db));
    await pump(tester);
    expect(find.byType(MaterialBanner), findsNothing);

    device
      ..add('b.png', 'Pictures/Screenshots/')
      ..add('c.png', 'Pictures/Screenshots/');
    await run(tester, () => device.index(db));
    await settle(tester);
    expect(find.text('Screenshots, 2 items, is new'), findsOneWidget);
    expect(await run(tester, timeline), 3);
    await tap(tester, find.text('Exclude'));
    expect(find.byType(MaterialBanner), findsNothing);
    expect(await run(tester, timeline), 1);

    await run(tester, () async {
      await setOnlyChosen(db, on: true);
      await showFolder(db, 1, shown: true);
    });
    device.add('d.jpg', 'Telegram/Telegram Images/');
    await run(tester, () => device.index(db));
    await settle(tester);
    expect(find.text('Telegram Images, 1 item, is new'), findsOneWidget);
    expect(await run(tester, timeline), 1);
    await tap(tester, find.text('Keep'));
    expect(find.byType(MaterialBanner), findsNothing);
    expect(await run(tester, timeline), 2);
    await unmount(tester);
  });

  testWidgets('a long press and one tap exclude the folders of what is '
      'selected, with a way back', (tester) async {
    device
      ..add('a.jpg', 'DCIM/Camera/')
      ..add('b.png', 'Pictures/Screenshots/');
    await run(tester, () => device.index(db));
    await pump(tester);
    final box = tester.getRect(find.byType(TimelineView));
    await tester.longPressAt(box.topLeft + Offset(box.width / 6, 48 + 60));
    await settle(tester);
    await tap(tester, find.byTooltip('Exclude this folder'));
    expect(find.text('Excluded from the library'), findsOneWidget);
    expect((await run(tester, shown)).values.where((s) => !s), hasLength(1));
    await tap(tester, find.text('Undo'));
    expect((await run(tester, shown)).values, everyElement(isTrue));
    await unmount(tester);
  });

  testWidgets("search's folder picker is the source tree: a tap picks a "
      'folder, an eye hides one', (tester) async {
    device
      ..add('a.jpg', 'DCIM/Camera/')
      ..add('b.png', 'Pictures/Screenshots/');
    await run(tester, () => device.index(db));
    await pump(tester);
    await tap(tester, find.text('Search'));
    await tester.ensureVisible(find.text('Folder'));
    await tap(tester, find.text('Folder'));
    expect(find.byType(SourceTree), findsOneWidget);
    await tap(tester, find.byTooltip('Expand').last);
    await tap(tester, find.byTooltip('Hide Screenshots'));
    expect(await run(tester, shown), {'Camera': true, 'Screenshots': false});
    await tap(tester, find.text('Pictures'));
    expect(find.byType(SourceTree), findsNothing);
    expect(find.text('Pictures'), findsOneWidget, reason: 'the filter chip');
    await unmount(tester);
  });

  testWidgets("the viewer's info excludes the item's folder from its file's "
      'sheet', (tester) async {
    device.add('b.png', 'Pictures/Screenshots/');
    await run(tester, () => device.index(db));
    final row = await run(tester, db.select(db.localAsset).getSingle);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [replicaProvider.overrideWith((ref) async => db)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: InfoPanel(row)),
        ),
      ),
    );
    await tap(tester, find.text('b.png'));
    await tap(tester, find.text('Exclude this folder'));
    expect(await run(tester, shown), {'Screenshots': false});
    expect(find.text('Excluded from the library'), findsOneWidget);
    // The panel's queries close on a timer.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  });

  testWidgets('the excluded folders show, marked, for 5 minutes', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    device
      ..add('a.jpg', 'DCIM/Camera/')
      ..add('b.png', 'Pictures/Screenshots/');
    await run(tester, () => device.index(db));
    await run(tester, () async {
      await excludeFolderOf(db, (await db.select(db.localAsset).get()).last.id);
    });
    await pump(tester);
    FinderBase<SemanticsNode> marked() =>
        find.semantics.byHint('In an excluded folder');
    expect(marked(), findsNothing);

    await tap(tester, find.byTooltip('View options'));
    await tap(tester, find.text('Show excluded folders for 5 minutes'));
    expect(marked(), findsOneWidget);
    expect(await run(tester, timeline), 2);
    await tester.pump(revealFor);
    await settle(tester);
    expect(marked(), findsNothing);
    expect(await run(tester, timeline), 1);
    await unmount(tester);
    semantics.dispose();
  });

  testWidgets('an excluded item another app opens shows, its folder the '
      'swipe context, and says its folder is excluded', (tester) async {
    device
      ..add('a.jpg', 'DCIM/Camera/')
      ..add('b.png', 'Pictures/Screenshots/')
      ..add('c.png', 'Pictures/Screenshots/', taken: 1500000000000);
    await run(tester, () => device.index(db));
    final c = await run(tester, () async {
      final c = (await db.select(db.localAsset).get()).last;
      await excludeFolderOf(db, c.id);
      return c;
    });
    await pump(tester);
    final library = tester.state<ConsumerState>(find.byType(LibraryPage));
    unawaited(openInFolder(library.context, library.ref, c.id));
    await settle(tester);
    expect(
      find.text("This item's folder is excluded from your library"),
      findsOneWidget,
    );
    final viewer = tester.widget<ViewerPage>(find.byType(ViewerPage));
    expect((viewer.count, viewer.position.value), (2, 1));
    await unmount(tester);
  });
}

/// The name of [tile], a row of the source tree, indented by its depth.
String _indented(ListTile tile) {
  final depth = (tile.contentPadding! as EdgeInsetsDirectional).start ~/ 16;
  return '${' ' * depth}${(tile.title! as Text).data}';
}
