import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/deletion.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/features/trash/trash_page.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib_api/photolib_api.dart' show Confirmation;
import 'package:photolib_api/sync.dart'
    show EmptyTrashRequest, EmptyTrashResponse;
import 'package:photolib_data/photolib_data.dart';

import '../support/fake_server.dart';
import '../support/media_platform.dart';
import '../support/pump_app.dart';
import '../support/server_app.dart';

void main() {
  late Replica db;
  late FakePlatform platform;
  setUp(() {
    db = Replica(NativeDatabase.memory());
    platform = FakePlatform();
  });
  tearDown(() => db.close());

  Future<void> add(int n, {int hidden = 0, int trashed = 0, int? expires}) => db
      .into(db.localAsset)
      .insert(
        LocalAssetCompanion.insert(
          id: Uint8List(16)..[15] = n,
          source: 'folder',
          volume: const Value('/p'),
          sourceId: '$n',
          path: Value('$n.jpg'),
          size: 1,
          mtime: 0,
          takenLocal: Value('2024-05-0${n}T12:00:00'),
          hidden: Value(hidden),
          trashed: Value(trashed),
          expires: Value(expires),
        ),
      );

  Future<void> pump(WidgetTester tester, {Size size = const Size(400, 800)}) =>
      pumpApp(
        tester,
        size: size,
        replica: (_) => db,
        overrides: [
          thumbnailPipelineProvider.overrideWith(
            (ref) async => ThumbnailPipeline(),
          ),
          mediaPlatformProvider.overrideWithValue((_) => platform),
        ],
      );

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  Offset cell(WidgetTester tester, int n) {
    final box = tester.getRect(find.byType(TimelineView));
    final side = box.width / 3;
    return box.topLeft + Offset(side * (n + 0.5), 48 + side / 2);
  }

  Future<List<String>> shown() async => [
    for (final item
        in await db.timelinePage(99999999, false, null, 99, 0).get())
      item.sourceId,
  ];

  testWidgets('a selection moves to the trash at once, with no question '
      "but the platform's, and the snack bar undoes it", (tester) async {
    await add(1);
    await add(2);
    await pump(tester);
    await tester.longPressAt(cell(tester, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Move to trash'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(platform.calls, ['trash 2']);
    expect(await shown(), ['1']);
    expect(find.text('1 item moved to the trash'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(platform.calls, ['trash 2', 'restore 2']);
    expect(await shown(), ['2', '1']);
    await unmount(tester);
  });

  testWidgets("what Photolib cannot restore, as Photos' Recently Deleted, "
      'is offered no undo', (tester) async {
    platform = FakePlatform(restores: false);
    await add(1);
    await pump(tester);
    await tester.longPressAt(cell(tester, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Move to trash'));
    await tester.pumpAndSettle();
    expect(platform.calls, ['trash 1']);
    expect(find.text('1 item moved to the trash'), findsOneWidget);
    expect(find.text('Undo'), findsNothing);
    expect(await db.trashItems(true).get(), isEmpty);
    await unmount(tester);
  });

  testWidgets('favourites carry a badge in the timeline, which a screen '
      'reader hears', (tester) async {
    await add(1);
    await pump(tester);
    await tester.longPressAt(cell(tester, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Favourite'));
    await tester.pumpAndSettle();
    expect(platform.calls, ['favorite true 1']);
    // The timeline follows the index at most once a second.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    final semantics = tester.ensureSemantics();
    await tester.pump();
    expect(
      find.semantics
          .byLabel('May 1, 2024, 1 of 1, no preview')
          .evaluate()
          .single,
      isSemantics(value: 'Favourite'),
    );
    semantics.dispose();
    await unmount(tester);
  });

  testWidgets('the viewer favourites with L, and moves to the trash with '
      'Delete, closing on the library', (tester) async {
    await add(1);
    await add(2);
    // A desktop window, wide enough for the viewer's whole bar.
    await pump(tester, size: const Size(1000, 700));
    await tester.tapAt(cell(tester, 0));
    await tester.pumpAndSettle();
    await tester.pressKey(LogicalKeyboardKey.keyL, character: 'l');
    expect(platform.calls, ['favorite true 2']);
    expect(find.byTooltip('Remove from favourites'), findsOneWidget);
    await tester.pressKey(LogicalKeyboardKey.delete);
    expect(find.byType(ViewerPage), findsNothing);
    expect(platform.calls, ['favorite true 2', 'trash 2']);
    expect(find.text('1 item moved to the trash'), findsOneWidget);
    expect(await shown(), ['1']);
    await unmount(tester);
  });

  testWidgets('hidden items show for 5 minutes when asked, then hide again', (
    tester,
  ) async {
    await add(1);
    await add(2, hidden: 1);
    await pump(tester);
    expect(find.text('May 2, 2024'), findsNothing);
    const show = 'Show hidden and archived items for 5 minutes';
    await tester.tap(find.byTooltip(show));
    await tester.pumpAndSettle();
    expect(find.text('May 2, 2024'), findsOneWidget);
    await tester.pump(const Duration(minutes: 5));
    await tester.pumpAndSettle();
    expect(find.text('May 2, 2024'), findsNothing);

    // While they show, the menu unhides.
    await tester.tap(find.byTooltip(show));
    await tester.pumpAndSettle();
    await tester.longPressAt(cell(tester, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Unhide'));
    await tester.pumpAndSettle();
    expect(await shown(), ['2', '1']);
    await unmount(tester);
  });

  testWidgets('an item hides under a crossed-out picture in the viewer and '
      "the grid: the eye is the sources' alone (ADR-0290)", (tester) async {
    await add(1);
    await add(2, hidden: 1);
    await pump(tester, size: const Size(1000, 700));
    await tester.tap(
      find.byTooltip('Show hidden and archived items for 5 minutes'),
    );
    await tester.pumpAndSettle();
    // The hidden item, then the next one; hide is in ⋮ (docs/10 §4.6).
    await tester.tapAt(cell(tester, 0));
    await tester.pumpAndSettle();
    for (final (label, icon) in [
      ('Unhide', Icons.image_outlined),
      ('Hide', Icons.hide_image_outlined),
    ]) {
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.widgetWithText(MenuItemButton, label),
          matching: find.byIcon(icon),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      await tester.pressKey(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
    }
    expect(markIcon(Mark.hidden), Icons.hide_image);
    await unmount(tester);
  });

  testWidgets('the trash shows its retention and the time each item has left; '
      'deleting for good asks once, and not when the platform asks', (
    tester,
  ) async {
    final in3Days = DateTime.now()
        .add(const Duration(days: 2, hours: 12))
        .millisecondsSinceEpoch;
    await add(1, trashed: 1, expires: in3Days);
    await add(2, trashed: 1, expires: in3Days + Duration.millisecondsPerDay);
    await pump(tester);
    await tester.tap(find.byTooltip('Trash'));
    await tester.pumpAndSettle();
    expect(find.byType(TrashPage), findsOneWidget);
    expect(find.textContaining('after 60 days'), findsOneWidget);
    expect(find.text('3 days left'), findsOneWidget);
    expect(find.text('4 days left'), findsOneWidget);

    await tester.tap(find.text('3 days left'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();
    expect(platform.calls, ['restore 1']);
    expect(find.text('3 days left'), findsNothing);

    await tester.tap(find.text('Empty trash'));
    await tester.pumpAndSettle();
    expect(
      find.text('Delete 1 item forever? This cannot be undone.'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Delete forever'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(platform.calls, ['restore 1', 'purge 2']);
    expect(find.text('The trash is empty'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('the time Photolib keeps its trash is the setting: the header '
      'says it and an item trashed now expires then', (tester) async {
    await add(1);
    await pumpApp(
      tester,
      replica: (_) => db,
      settings: MemoryStore('{"trashDays":30}'),
      overrides: [
        thumbnailPipelineProvider.overrideWith(
          (ref) async => ThumbnailPipeline(),
        ),
        mediaPlatformProvider.overrideWithValue((_) => platform),
      ],
    );
    final before = DateTime.now();
    await tester.longPressAt(cell(tester, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Move to trash'));
    await tester.pumpAndSettle();
    final expires = (await db.trashItems(true).get()).single.expires!;
    final days = DateTime.fromMillisecondsSinceEpoch(expires)
        .difference(before)
        .inHours;
    expect(days, inInclusiveRange(30 * 24 - 1, 30 * 24 + 1));
    await tester.tap(find.byTooltip('Trash'));
    await tester.pumpAndSettle();
    expect(find.textContaining('after 30 days'), findsOneWidget);
    expect(find.text('30 days left'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('an entry the platform keeps no longer, as its time went by, '
      'is removed from the list without asking the platform', (tester) async {
    platform = FakePlatform(expires: true);
    final in3Days = DateTime.now()
        .add(const Duration(days: 2, hours: 12))
        .millisecondsSinceEpoch;
    await add(1, trashed: 1, expires: 1);
    await add(2, trashed: 1, expires: in3Days);
    await pump(tester);
    await tester.tap(find.byTooltip('Trash'));
    await tester.pumpAndSettle();
    expect(find.text('Remove from list'), findsNothing);
    await tester.tap(find.text('3 days left'));
    await tester.pumpAndSettle();
    expect(find.text('Remove from list'), findsNothing, reason: 'it is held');
    await tester.tap(find.text('3 days left'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deleted forever today'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove from list'));
    await tester.pumpAndSettle();
    expect(find.text('Deleted forever today'), findsNothing);
    expect(find.text('3 days left'), findsOneWidget);
    expect(platform.calls, isEmpty);
    expect(await db.trashItems(true).get(), hasLength(1));
    await unmount(tester);
  });

  group('signed in to a server', () {
    setUpServerApp();

    Future<void> remote(int n) => db.customStatement(
      'INSERT INTO asset (id, library_id, owner_id, original_filename, '
      'source, media_kind, trashed_at, created_at) '
      "VALUES (?, x'01', x'02', 'a.jpg', 'upload', 'image', 1, 1)",
      [Uint8List(16)..[15] = n],
    );

    Future<void> open(WidgetTester tester) async {
      keep(ann);
      await pumpServerApp(
        tester,
        replica: db,
        overrides: [
          thumbnailPipelineProvider.overrideWith(
            (ref) async => ThumbnailPipeline(),
          ),
          mediaPlatformProvider.overrideWithValue((_) => platform),
        ],
      );
      await tester.tap(find.byTooltip('Trash'));
      await tester.pumpAndSettle();
    }

    testWidgets('emptying asks once, and a large trash the server holds '
        'back asks again with its count', (tester) async {
      await remote(1);
      await remote(2);
      await remote(3);
      server = FakeServer({
        'SyncService/EmptyTrash': (request) =>
            (request as EmptyTrashRequest).confirmToken == 'T'
            ? EmptyTrashResponse(queued: Int64(2000))
            : EmptyTrashResponse(
                held: Confirmation(
                  count: Int64(2000),
                  total: Int64(2000),
                  token: 'T',
                ),
              ),
      });
      await open(tester);
      await tester.tap(find.text('Empty trash'));
      await tester.pumpAndSettle();
      expect(
        find.text('Delete 3 items forever? This cannot be undone.'),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Delete forever'));
      await tester.pumpAndSettle();
      expect(
        find.text('Delete 2,000 items forever? This cannot be undone.'),
        findsOneWidget,
        reason: 'the count the server will delete',
      );
      expect(
        server.requests<EmptyTrashRequest>('SyncService/EmptyTrash'),
        hasLength(1),
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Delete forever'));
      await tester.pumpAndSettle();
      expect(
        [
          for (final r in server.requests<EmptyTrashRequest>(
            'SyncService/EmptyTrash',
          ))
            r.confirmToken,
        ],
        ['', 'T'],
      );
      expect(find.byType(AlertDialog), findsNothing);
      await unmount(tester);
    });

    testWidgets('cancelling either question deletes nothing', (tester) async {
      await remote(1);
      server = FakeServer({
        'SyncService/EmptyTrash': (_) => EmptyTrashResponse(
          held: Confirmation(
            count: Int64(5000),
            total: Int64(5000),
            token: 'T',
          ),
        ),
      });
      await open(tester);
      await tester.tap(find.text('Empty trash'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(
        server.requests<EmptyTrashRequest>('SyncService/EmptyTrash'),
        isEmpty,
      );
      await tester.tap(find.text('Empty trash'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete forever'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(
        server.requests<EmptyTrashRequest>('SyncService/EmptyTrash'),
        hasLength(1),
        reason: 'asked, but never confirmed',
      );
      await unmount(tester);
    });
  });

  testWidgets('a platform that asks before deleting is the only question', (
    tester,
  ) async {
    platform = FakePlatform(asks: true);
    await add(1, trashed: 1);
    await pump(tester);
    await tester.tap(find.byTooltip('Trash'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Empty trash'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(platform.calls, ['purge 1']);
    await unmount(tester);
  });
}
