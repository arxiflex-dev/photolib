import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/deletion.dart';
import 'package:photolib/features/library/deletion.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/features/servers/hints.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/servers/sync.dart' show syncProvider;
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib_data/photolib_data.dart';

import '../../support/fake_server.dart';
import '../../support/media_platform.dart';
import '../../support/pump_app.dart';
import '../../support/viewer.dart';

void main() {
  ThumbnailItem item(
    Availability backup,
    int bytes, {
    String scheme = 'file',
  }) => ThumbnailItem(
    '$backup $bytes',
    Uri(scheme: scheme, path: '$bytes'),
    backup: backup,
    bytes: bytes,
  );

  // What the dialog [show] opened returns once it closes.
  late Future<DeleteChoice?> choice;

  Future<void> show(WidgetTester tester, List<ThumbnailItem> items) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                choice = confirmDeletion(context, DeletionPlan.of(items)),
            child: const Text('delete'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('delete'));
    await tester.pumpAndSettle();
  }

  testWidgets('says what goes where, by where each item is, with the bytes '
      'this device gets back, and offers to remove only backed-up copies', (
    tester,
  ) async {
    await show(tester, [
      item(Availability.backedUp, 2000),
      item(Availability.backedUp, 1500000),
      item(Availability.notBackedUp, 900),
      for (var i = 0; i < 3; i++) item(Availability.cloudOnly, 4000000 + i),
    ]);
    for (final line in [
      'Delete 6 items?',
      '2 on this device and backed up · 1.5 MB',
      '1 only on this device, not backed up · 900 B',
      '3 only in your library · 12 MB',
      'From this device and your library',
      'The 2 backed-up items; your library keeps them',
    ]) {
      expect(find.text(line), findsOneWidget, reason: line);
    }
    expect(
      find.text(
        'Copies on this device go to its trash: the space returns once it is '
        'emptied.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('iCloud'), findsNothing);
    await tester.tap(find.text('Remove from this device'));
    await tester.pumpAndSettle();
    expect(await choice, DeleteChoice.removeFromDevice);
  });

  testWidgets('moving to trash is the first choice; cancel chooses none', (
    tester,
  ) async {
    final items = [item(Availability.backedUp, 1)];
    await show(tester, items);
    await tester.tap(find.text('Move to trash'));
    await tester.pumpAndSettle();
    expect(await choice, DeleteChoice.trash);
    await show(tester, items);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await choice, isNull);
  });

  testWidgets('nothing backed up: no removal from this device alone; only in '
      'the library: nothing on this device to trash', (tester) async {
    await show(tester, [item(Availability.notBackedUp, 5)]);
    expect(find.text('Delete 1 item?'), findsOneWidget);
    expect(find.text('From this device only'), findsOneWidget);
    expect(find.text('Remove from this device'), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await show(tester, [item(Availability.cloudOnly, 5)]);
    expect(find.text('From your library'), findsOneWidget);
    expect(find.textContaining('the space returns'), findsNothing);
    expect(find.text('Remove from this device'), findsNothing);
  });

  testWidgets('a PhotoKit copy says iCloud Photos follows', (tester) async {
    await show(tester, [item(Availability.backedUp, 5, scheme: 'ph')]);
    expect(
      find.text(
        'With iCloud Photos on, items deleted from this device also leave '
        'iCloud and your other Apple devices.',
      ),
      findsOneWidget,
    );
  });

  group('signed out', () {
    Future<void> press(WidgetTester tester, ThumbnailItem item) async {
      final db = Replica(NativeDatabase.memory());
      addTearDown(db.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            serverProvider.overrideWithValue(const AsyncData(null)),
            deletionProvider.overrideWith(
              (ref) async => DeletionService(db, (_) => FakePlatform()),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) => TextButton(
                  onPressed: () => unawaited(
                    deleteItems(context, ref, [item], chosen: () => context),
                  ),
                  child: const Text('delete'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('delete'));
      await tester.pumpAndSettle();
    }

    testWidgets('an Apple Photos item still asks, and says iCloud Photos '
        'follows, as Photos itself is the only other to say it', (
      tester,
    ) async {
      await press(tester, item(Availability.notBackedUp, 5, scheme: 'ph'));
      expect(find.textContaining('With iCloud Photos on'), findsOneWidget);
      expect(find.text('Move to trash'), findsOneWidget);
    });

    testWidgets('a file on this device is trashed at once, as before', (
      tester,
    ) async {
      await press(tester, item(Availability.notBackedUp, 5));
      expect(find.textContaining('iCloud'), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('signed in, the trash asks', () {
    late Replica db;
    late FakePlatform platform;
    setUp(() {
      db = Replica(NativeDatabase.memory());
      platform = FakePlatform();
    });
    tearDown(() => db.close());

    Uint8List id(int n) => Uint8List(16)..[15] = n;

    // Device item 1 is backed up as asset 11, device item 2 is not, and asset
    // 12 is only in the library.
    Future<void> library() async {
      await db.customStatement(
        'INSERT INTO library (id, owner_id, kind, privacy, access, state, '
        "txid) VALUES (x'01', x'09', 'managed', 'standard', 'rw', 'online', 1)",
      );
      for (final (n, day) in [(11, '05-01'), (12, '06-01')]) {
        await db.customStatement(
          'INSERT INTO asset (id, library_id, owner_id, original_filename, '
          'source, media_kind, taken_local, created_at, file_size_total, '
          "txid) VALUES (?, x'01', x'09', 'a.jpg', 'upload', 'image', "
          "'2024-${day}T12:00:00', 0, 2000000, 1)",
          [id(n)],
        );
      }
      for (final n in [1, 2]) {
        await db
            .into(db.localAsset)
            .insert(
              LocalAssetCompanion.insert(
                id: id(n),
                source: 'mediastore',
                volume: const Value('external_primary'),
                sourceId: '$n',
                path: const Value('DCIM/'),
                name: Value('$n.jpg'),
                mime: const Value('image/jpeg'),
                size: 1000,
                mtime: 0,
                takenLocal: Value('2024-05-0${n}T12:00:00'),
                assetId: Value(n == 1 ? id(11) : null),
              ),
            );
      }
    }

    Future<void> pump(
      WidgetTester tester, {
      Size size = const Size(400, 800),
    }) => pumpApp(
      tester,
      size: size,
      replica: (_) => db,
      serverStore: MemoryStore(
        jsonEncode(
          SavedServer(
            endpoints: [Uri.parse('https://photos.example.org')],
            instance: 'instance-a',
            account: Account(
              name: 'ann',
              token: 't',
              deviceId: 'd',
              expires: DateTime.utc(2099),
            ),
          ).toJson(),
        ),
      ),
      overrides: [
        thumbnailPipelineProvider.overrideWith((ref) async => Grey()),
        mediaPlatformProvider.overrideWithValue((_) => platform),
        connectProvider.overrideWithValue((config, instance) => FakeServer()),
        syncProvider.overrideWithValue((db, config, instance) async {}),
        followProvider.overrideWithValue(null),
      ],
    );

    Future<void> unmount(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    }

    // The newest cell, asset 12's.
    Offset first(WidgetTester tester) {
      final box = tester.getRect(find.byType(TimelineView));
      return box.topLeft + Offset(box.width / 6, 48 + box.width / 6);
    }

    Future<void> selectAll(WidgetTester tester) async {
      await tester.longPressAt(first(tester));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Select all'));
      await tester.pumpAndSettle();
      await tester.tapAction('Move to trash');
      await tester.pumpAndSettle();
    }

    // Which of assets 11 and 12 the library's trash holds.
    Future<List<bool>> trashed() async => [
      for (final n in [11, 12])
        (await (db.select(
              db.asset,
            )..where((a) => a.id.equals(id(n)))).getSingle()).trashedAt !=
            null,
    ];

    Future<List<String>> shown() async => [
      for (final item
          in await db.timelinePage(99999999, false, null, 9, 0).get())
        if (item.source == 'server')
          'asset ${item.id.last}'
        else
          '${item.id.last}',
    ];

    testWidgets('moving a selection to the trash says what goes where first, '
        'then takes every copy, each into its trash, and undoes it', (
      tester,
    ) async {
      await library();
      await pump(tester);
      await selectAll(tester);
      for (final line in [
        'Delete 3 items?',
        '1 on this device and backed up · 1 kB',
        '1 only on this device, not backed up · 1 kB',
        '1 only in your library · 2 MB',
      ]) {
        expect(find.text(line), findsOneWidget, reason: line);
      }
      expect(platform.calls, isEmpty);
      await tester.tap(find.text('Move to trash').last);
      await tester.pumpAndSettle();
      expect(platform.calls, ['trash 1,2']);
      expect(await trashed(), [true, true]);
      expect(await shown(), isEmpty);
      expect(find.text('3 items moved to the trash'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(platform.calls, ['trash 1,2', 'restore 1,2']);
      expect(await trashed(), [false, false]);
      expect(await shown(), ['asset 12', '2', '1']);
      await unmount(tester);
    });

    testWidgets('removing from this device takes only the backed-up copies, '
        'which then show from the library; cancel keeps the selection', (
      tester,
    ) async {
      await library();
      await pump(tester);
      await selectAll(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('3 selected'), findsOneWidget);
      expect(platform.calls, isEmpty);
      expect(await trashed(), [false, false]);
      await tester.tapAction('Move to trash');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove from this device'));
      await tester.pumpAndSettle();
      expect(platform.calls, ['trash 1']);
      expect(await trashed(), [false, false]);
      expect(await shown(), ['asset 12', '2', 'asset 11']);
      expect(find.text('1 item moved to the trash'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets("a folder's selection asks too", (tester) async {
      await library();
      await pump(tester);
      await tester.tapAndSettle(find.text('Collections'));
      await tester.tapAndSettle(find.text('Folders'));
      await tester.tapAndSettle(find.text('DCIM'));
      await tester.longPress(find.byType(ThumbnailAt).first);
      await tester.tapAndSettle(find.byTooltip('Select all'));
      await tester.tapAction('Move to trash');
      expect(find.text('Delete 2 items?'), findsOneWidget);
      expect(
        find.text('1 only on this device, not backed up · 1 kB'),
        findsOneWidget,
      );
      await tester.tapAndSettle(find.text('Move to trash').last);
      expect(platform.calls, ['trash 1,2']);
      expect(await trashed(), [true, false]);
      await unmount(tester);
    });

    testWidgets('the viewer asks too, and deletes what only the library has '
        "without the device's dialog", (tester) async {
      await library();
      await pump(tester, size: const Size(1000, 700));
      await tester.tapAt(first(tester));
      await tester.pumpAndSettle();
      expect(find.byType(ViewerPage), findsOneWidget);
      await tester.pressKey(LogicalKeyboardKey.delete);
      await tester.pumpAndSettle();
      expect(find.text('1 only in your library · 2 MB'), findsOneWidget);
      expect(find.text('From your library'), findsOneWidget);
      await tester.tap(find.text('Move to trash').last);
      await tester.pumpAndSettle();
      expect(find.byType(ViewerPage), findsNothing);
      expect(platform.calls, isEmpty);
      expect(await trashed(), [false, true]);
      await unmount(tester);
    });
  });
}
