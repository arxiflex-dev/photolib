import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/errors.dart';
import 'package:photolib/core/keystore.dart';
import 'package:photolib/core/logging.dart';
import 'package:photolib/core/providers.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/library/timeline/disk_cache.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/timeline_row.dart';
import 'package:photolib/features/library/timeline/timeline_view.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/viewer/slideshow.dart';
import 'package:photolib/features/viewer/viewer_page.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_data/testing.dart';
import 'package:photolib_kernel/photolib_kernel.dart';

import '../../support/pump_app.dart';
import '../../support/viewer.dart';

class _FakeVault extends Fake implements Vault {
  @override
  bool get rebuilt => false;
}

void main() {
  late Replica db;
  // The id of the last asset added, which a test names in its expectations:
  // each test counts from 1, whatever ran before it (the tests run in any
  // order under --test-randomize-ordering-seed).
  var next = 0;
  setUp(() {
    db = Replica(NativeDatabase.memory());
    next = 0;
  });
  tearDown(() => db.close());

  Future<void> add(String taken, {int added = 0}) => db
      .into(db.localAsset)
      .insert(
        LocalAssetCompanion.insert(
          id: Uint8List(16)..[15] = ++next,
          source: 'folder',
          volume: const Value('/p'),
          sourceId: '$next',
          path: Value('$next.jpg'),
          size: 1,
          mtime: 0,
          takenLocal: Value(taken),
          added: Value(added),
        ),
      );

  Future<void> pump(
    WidgetTester tester, {
    MemoryLog? log,
    ThumbnailPipeline? pipeline,
    SecretStore? serverStore,
  }) async {
    for (final day in [
      '2024-05-03',
      '2024-05-03',
      '2024-05-01',
      '2024-04-30',
    ]) {
      await add('${day}T12:00:00');
    }
    await pumpApp(
      tester,
      replica: (_) => db,
      serverStore: serverStore,
      overrides: [
        thumbnailPipelineProvider.overrideWith(
          (ref) async => pipeline ?? ThumbnailPipeline(),
        ),
        if (log != null) memoryLogProvider.overrideWithValue(log),
      ],
    );
  }

  /// Unmounts the app, so that drift closes its queries on the test's clock.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  // The centre of the timeline's [n]th cell of its first row.
  Offset cell(WidgetTester tester, int n) {
    final box = tester.getRect(find.byType(TimelineView));
    final side = box.width / 3;
    return box.topLeft + Offset(side * (n + 0.5), 48 + side / 2);
  }

  for (final release in [false, true]) {
    testWidgets('a thumbnail that fails is logged with its file and cause'
        '${release ? ', redacted in a release build' : ''}', (tester) async {
      Log.configure(release: release);
      addTearDown(() => Log.configure(release: false));
      final log = MemoryLog();
      await pump(
        tester,
        log: log,
        pipeline: ThumbnailPipeline(
          decoders: [
            Thumbnailer(
              'decoder',
              (item, _, _) async => throw FileSystemException(
                'Cannot open file',
                item.uri.toFilePath(),
              ),
            ),
          ],
        ),
      );
      final failed = log.records.firstWhere((r) => r.message == 'no thumbnail');
      expect(failed.logger, 'photolib.thumbnails');
      expect(failed.level, LogLevel.warning);
      expect('${failed.error}', contains('Cannot open file'));
      expect('${failed.error}', contains('cause: decoder: threw'));
      if (release) {
        expect(failed.fields['file'], '<redacted>');
        expect(failed.toJson(), isNot(contains('.jpg')));
        expect(log.records.where((r) => r.level == LogLevel.debug), isEmpty);
      } else {
        expect(
          log.records
              .where((r) => r.message == 'no thumbnail')
              .map((r) => r.fields['file']),
          contains('/p/1.jpg'),
        );
        expect('${failed.error}', contains('/p/'));
      }
      await unmount(tester);
    });
  }

  testWidgets("each tile's way to the screen is in the debug log, timed per "
      'stage', (tester) async {
    final log = MemoryLog();
    final tile = Pixels.encoded(img.encodeJpg(img.Image(width: 2, height: 2)));
    await pump(
      tester,
      log: log,
      pipeline: ThumbnailPipeline(
        thumbnailers: [Thumbnailer('os', (_, _, _) async => tile)],
      ),
    );
    List<LogRecord> logged() =>
        log.records.where((r) => r.message == 'tile').toList();
    await tester.pumpUntil(() => logged().length >= 4);
    final tiles = logged();
    expect(tiles.map((r) => r.fields['file']), contains('/p/$next.jpg'));
    expect(tiles.first.level, LogLevel.debug);
    expect(tiles.first.fields.keys, [
      'file',
      'tier',
      'queue',
      'decode',
      'upload',
    ]);
    expect(tiles.first.fields['decode'], isA<double>());
    await unmount(tester);
  });

  testWidgets('cells paint the ThumbHashes of the device index, and those '
      'the warm-up keeps as they come', (tester) async {
    final hash = base64.decode(
      ((jsonDecode(File('../testdata/thumbhash.json').readAsStringSync())
                      as Map)['cases']
                  as List)
              .first['hash']
          as String,
    );
    // Thumbnails that never come, so cells keep their placeholders.
    await pump(
      tester,
      pipeline: ThumbnailPipeline(
        thumbnailers: [
          Thumbnailer('os', (_, _, _) => Completer<Pixels?>().future),
        ],
      ),
    );
    final row = find
        .descendant(
          of: find.byType(TimelineRow),
          matching: find.byType(CustomPaint),
        )
        .first;
    final mesh = paints..something((method, _) => method == #drawVertices);
    expect(tester.renderObject(row), isNot(mesh));
    await saveThumbHashes(db, {Uint8List(16)..[15] = next - 3: hash});
    // The timeline follows the index at most once a second.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(tester.renderObject(row), mesh);
    await unmount(tester);
  });

  testWidgets('a folder whose scan ends is warmed into the disk cache, '
      'newest first, its progress shown as the library scrolls, and the log '
      'sums it up', (tester) async {
    final log = MemoryLog();
    final dir = Directory.systemTemp.createTempSync('warm');
    var closed = false;
    addTearDown(() {
      expect(closed, isTrue, reason: 'deleting an open cache races its writes');
      dir.deleteSync(recursive: true);
    });
    final cache = (await tester.runAsync(() async {
      final (vault, cipher) = await scratchVault(
        '${dir.path}/store',
        Kernel().keyring,
      );
      addTearDown(vault.lock);
      return await DiskCache.open('${dir.path}/cache', cipher);
    }))!;
    final warmed = <String>[];
    final release = Completer<void>();
    final tile = Pixels.encoded(img.encodeJpg(img.Image(width: 2, height: 2)));
    await addFolder(db, '/p');
    await pump(
      tester,
      log: log,
      pipeline: ThumbnailPipeline(
        cache: cache,
        // The timeline's cells, from the platform; the warm-up decodes.
        thumbnailers: [Thumbnailer('os', (_, _, _) async => tile)],
        decoders: [
          Thumbnailer('decoder', (item, _, _) async {
            warmed.add(item.uri.path);
            await release.future;
            return tile;
          }),
        ],
      ),
    );
    expect(warmed, isEmpty, reason: 'still scanning');
    await (db.update(db.mediaSource)..where((s) => s.root.equals('/p'))).write(
      const MediaSourceCompanion(state: Value('online')),
    );
    final progress = find.text('Preparing thumbnails: 0 of 4');
    await tester.pumpUntil(() => progress.evaluate().isNotEmpty);
    expect(progress, findsOneWidget);
    await tester.drag(find.byType(TimelineView), const Offset(0, -100));
    await tester.pump();
    release.complete();
    final bar = find.byType(LinearProgressIndicator);
    // Real disk writes: up to 30 s on a loaded machine.
    await tester.pumpUntil(() => bar.evaluate().isEmpty);
    expect(bar, findsNothing);
    // Two of May 3 (the later id first), May 1, April 30.
    expect(warmed, [
      for (final n in [next - 2, next - 3, next - 1, next]) '/p/$n.jpg',
    ]);
    Iterable<Object?> summaries() => log.records
        .where((r) => r.message == 'warm-up')
        .map((r) => r.fields['summary']);
    await tester.pumpUntil(() => summaries().isNotEmpty);
    expect(cache.bytes, greaterThan(0));
    expect(summaries(), ['warmed 4 of 4']);
    await unmount(tester);
    // Its index is still being written; a delete beside that fails.
    unawaited(cache.close().then((_) => closed = true));
    await tester.pumpUntil(() => closed);
  });

  testWidgets('the library is the device index by day, sorted and grouped '
      'from its menu', (tester) async {
    await pump(tester);
    expect(find.text('May 3, 2024'), findsOneWidget);
    expect(find.text('Apr 30, 2024'), findsOneWidget);

    Future<void> choose(String option) async {
      await tester.tap(find.byTooltip('View options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(option));
      await tester.pumpAndSettle();
    }

    await choose('Group by month');
    expect(find.text('May 2024'), findsOneWidget);
    expect(find.text('Apr 2024'), findsOneWidget);
    await choose('Recently added');
    expect(find.text('Jan 2024'), findsNothing);
    expect(find.text('Jan 1970'), findsOneWidget, reason: 'all added at 0');
    await choose('Date taken');
    await choose('Group by day');
    expect(find.text('May 1, 2024'), findsOneWidget);

    await tester.tap(find.byTooltip('Smaller thumbnails'));
    await tester.pumpAndSettle();
    expect(find.text('May 2024'), findsOneWidget, reason: 'months');
    await unmount(tester);
  });

  testWidgets('signed in, tiles say where their photos are, and the menu '
      'shows one backup state at a time, with a way back from none', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await db.customStatement(
      'INSERT INTO library (id, owner_id, kind, privacy, access, state, txid) '
      "VALUES (x'01', x'09', 'managed', 'standard', 'rw', 'online', 1)",
    );
    await db.customStatement(
      'INSERT INTO asset (id, library_id, owner_id, original_filename, source, '
      "media_kind, taken_local, created_at, txid) VALUES (zeroblob(16), x'01', "
      "x'09', 'a.jpg', 'upload', 'image', '2024-06-01T12:00:00', 0, 1)",
    );
    final signedIn = MemoryStore(
      jsonEncode(
        SavedServer(
          endpoints: [Uri.parse('https://photos.example.org')],
          instance: 'instance-a',
          account: const Account(name: 'ann', token: 't', deviceId: 'd'),
        ).toJson(),
      ),
    );
    await pump(tester, serverStore: signedIn);
    expect(find.semantics.byLabel(RegExp('^Jun 1, 2024, 1 of 1')).evaluate(), [
      isSemantics(tooltip: 'Cloud only'),
    ]);
    expect(find.semantics.byLabel(RegExp('^May 3, 2024, 1 of 2')).evaluate(), [
      isSemantics(tooltip: 'Not backed up'),
    ]);

    Future<void> choose(String option) async {
      await tester.tap(find.byTooltip('View options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(option).last);
      await tester.pumpAndSettle();
    }

    await choose('Cloud only');
    expect(find.text('Jun 1, 2024'), findsOneWidget);
    expect(find.text('May 3, 2024'), findsNothing);
    // The filter shows above the timeline, and its chip clears it.
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(find.text('May 3, 2024'), findsOneWidget);
    await choose('Cloud only');
    await choose('Not backed up');
    expect(find.text('Jun 1, 2024'), findsNothing);
    expect(find.text('May 3, 2024'), findsOneWidget);
    await choose('Backed up');
    expect(find.text('Nothing is backed up yet'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(find.text('Jun 1, 2024'), findsOneWidget);
    expect(find.text('May 3, 2024'), findsOneWidget);

    await choose('Backup badges');
    expect(find.semantics.byLabel(RegExp('^May 3, 2024, 1 of 2')).evaluate(), [
      isSemantics(tooltip: ''),
    ]);
    semantics.dispose();
    await unmount(tester);
  });

  testWidgets('signed out, nothing is backed up: no badges, no backup filter', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    expect(find.semantics.byLabel(RegExp('^May 3, 2024, 1 of 2')).evaluate(), [
      isSemantics(tooltip: ''),
    ]);
    await tester.tap(find.byTooltip('View options'));
    await tester.pumpAndSettle();
    expect(find.text('Cloud only'), findsNothing);
    expect(find.text('Backup badges'), findsNothing);
    semantics.dispose();
    await unmount(tester);
  });

  testWidgets('a long press selects: the bar counts, selects all and shows '
      'what is selected, where a tap deselects', (tester) async {
    await pump(tester);
    await tester.longPressAt(cell(tester, 0));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    await tester.tap(find.byTooltip('Select all'));
    await tester.pumpAndSettle();
    expect(find.text('4 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Show selected'));
    await tester.pumpAndSettle();
    expect(find.byType(ThumbnailAt), findsNWidgets(4));
    await tester.tap(find.byType(ThumbnailAt).first);
    await tester.pumpAndSettle();
    expect(find.text('3 selected'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Clear selection'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('View options'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('a selection plays as a slideshow', (tester) async {
    await pump(tester, pipeline: Grey());
    await tester.longPressAt(cell(tester, 1));
    await tester.pumpAndSettle();
    await tester.tapAction('Slideshow');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('slide 1')), findsOneWidget);
    expect(find.byKey(const ValueKey('slide 0')), findsNothing);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(SlideshowPage), findsNothing);
    expect(find.text('1 selected'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('a selection keeps the timeline it was made in until cleared', (
    tester,
  ) async {
    await pump(tester);
    await tester.longPressAt(cell(tester, 1));
    await tester.pumpAndSettle();
    await add('2024-06-01T00:00:00');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Jun 1, 2024'), findsNothing);
    expect(find.text('1 selected'), findsOneWidget);
    await tester.tap(find.byTooltip('Clear selection'));
    await tester.pumpAndSettle();
    expect(find.text('Jun 1, 2024'), findsOneWidget);
    await unmount(tester);
  });

  for (final failing in ['replica', 'vault']) {
    testWidgets('a local store whose $failing cannot open says so, and opens '
        'on retry', (tester) async {
      await add('2024-05-03T12:00:00');
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
        overrides: [
          thumbnailPipelineProvider.overrideWith(
            (ref) async => ThumbnailPipeline(),
          ),
        ],
      );
      expect(
        find.text('Photolib could not open the library kept on this device'),
        findsOneWidget,
      );
      expect(find.text('Your photos will appear here'), findsNothing);
      expect(find.text('Add folder'), findsNothing);

      // The library's own, beside StoreBanner's where the vault failed.
      await tester.tap(
        find.descendant(
          of: find.byType(ErrorView),
          matching: find.text('Try again'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('May 3, 2024'), findsOneWidget);
      expect(opens, 2);
      await unmount(tester);
    });
  }

  testWidgets('a tap opens the item full screen, laid out so from the start '
      'while its photo flies from its cell', (tester) async {
    await pump(tester, pipeline: Grey());
    await tester.tapAt(cell(tester, 1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(
      tester.getRect(find.byType(ViewerPage)),
      Offset.zero & const Size(400, 800),
    );
    expect(find.byKey(const ValueKey('flight')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('flight')), findsNothing);
    expect(
      tester.getRect(find.byType(ViewerPage)),
      Offset.zero & const Size(400, 800),
    );
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.byType(ViewerPage), findsNothing);
    await unmount(tester);
  });

  testWidgets('edits the server refused are said, by why, until dismissed', (
    tester,
  ) async {
    for (final (n, error) in [
      (1, 'mutation.forbidden'),
      (2, 'mutation.not_found'),
      (3, 'mutation.forbidden'),
      (4, null),
    ]) {
      await db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              mutationId: Uint8List(16)..[15] = n,
              entity: 'assets',
              entityId: Uint8List(16),
              mutation: Uint8List(0),
              error: Value(error),
              createdAt: n,
            ),
          );
    }
    await pump(tester);
    await tester.pumpAndSettle();
    expect(
      find.text('3 changes were undone: the server refused them.'),
      findsOneWidget,
    );
    expect(
      find.text('You may view the items but not change them.'),
      findsOneWidget,
    );
    expect(
      find.text('The items were deleted or are no longer shared with you.'),
      findsOneWidget,
    );
    expect(find.text('The server could not accept the changes.'), findsNothing);
    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();
    expect(find.textContaining('undone'), findsNothing);
    expect(await db.select(db.outbox).get(), hasLength(1));
    await unmount(tester);
  });
}
