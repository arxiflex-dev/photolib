import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/logging.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/folders/device_folders.dart';
import 'package:photolib/features/folders/folders.dart';
import 'package:photolib/features/viewer/info_panel.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_harness/photolib_harness.dart';

import '../support/pump_app.dart';

void main() {
  late Replica db;
  setUp(() => db = Replica(NativeDatabase.memory()));
  tearDown(() => db.close());

  final pickedIn = <String?>[];
  Future<void> pumpDesktop(
    WidgetTester tester, {
    String? picked,
    FolderAccess? access,
    FutureOr<Replica> Function(Ref ref)? replica,
  }) {
    pickedIn.clear();
    return pumpApp(
      tester,
      replica: replica ?? (_) => db,
      overrides: [
        folderPickerProvider.overrideWithValue(({initialDirectory}) async {
          pickedIn.add(initialDirectory);
          return picked;
        }),
        if (access != null) folderAccessProvider.overrideWithValue(access),
      ],
    );
  }

  Future<List<String>> roots() async => [
    for (final s in await db.select(db.mediaSource).get()) s.root,
  ];

  /// Unmounts the app, so that drift closes its queries on the test's clock.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  // A scanning folder's progress never settles.
  Future<void> open(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pump();
    await tester.tap(finder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> openSettings(WidgetTester tester) =>
      open(tester, find.byTooltip('Settings'));

  /// Settings › Library › Folders: the source tree.
  Future<void> openFolders(WidgetTester tester) async {
    await openSettings(tester);
    await open(tester, find.widgetWithText(ListTile, 'Folders'));
  }

  for (final picked in ['/home/me/Pictures', null]) {
    testWidgets('the empty library adds the folder picked: $picked', (
      tester,
    ) async {
      final heard = <LogRecord>[];
      addTearDown(Log.records.listen(heard.add).cancel);
      await pumpDesktop(tester, picked: picked);
      await tester.tap(find.text('Add folder'));
      await tester.pump();
      expect(await roots(), [?picked]);
      final pick = heard.singleWhere((r) => r.message == 'folder picked');
      expect(pick.logger, 'photolib.folders');
      expect(pick.fields['folder'], picked);
      await unmount(tester);
    });
  }

  testWidgets('while the store is shut no folder can be added', (tester) async {
    await pumpApp(
      tester,
      overrides: [
        folderPickerProvider.overrideWithValue(
          ({initialDirectory}) async => '/home/me/Pictures',
        ),
      ],
      vault: () => Future.error(PlatformException(code: 'Libsecret error')),
    );
    expect(find.text('Add folder'), findsNothing);
    await openSettings(tester);
    expect(find.text('Add folder'), findsNothing);
  });

  testWidgets('a folder inside or around one in the library is refused', (
    tester,
  ) async {
    await addFolder(db, '/home/me');
    await pumpDesktop(tester, picked: '/home/me/Pictures');
    await tester.tap(find.text('Add folder'));
    await tester.pump();
    expect(await roots(), ['/home/me']);
    expect(
      find.text(
        'This folder is already in the library, or inside or around one '
        'that is',
      ),
      findsOneWidget,
    );
    await unmount(tester);
  });

  testWidgets('without a folder picker there are no folders to manage', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('Add folder'), findsNothing);
    await openSettings(tester);
    expect(find.widgetWithText(ListTile, 'Folders'), findsNothing);
    expect(find.text('Add folder'), findsNothing);
  });

  testWidgets(
    'a browser without File System Access says why it has no folders',
    (tester) async {
      await pumpApp(
        tester,
        overrides: [foldersUnsupportedProvider.overrideWithValue(true)],
      );
      expect(
        find.text(
          'This browser cannot keep a folder as your library. Open Photolib in '
          'Chrome or Edge on a computer, or use the desktop app.',
        ),
        findsOneWidget,
      );
      expect(find.text('Add folder'), findsNothing);
    },
  );

  testWidgets("the viewer's info excludes a desktop file's folder: hidden on "
      'its node, and its items leave the timeline', (tester) async {
    await db.customStatement(
      "INSERT INTO device_folder (id, volume, path) VALUES (7, '/p', '2024/')",
    );
    await db
        .into(db.localAsset)
        .insert(
          LocalAssetCompanion.insert(
            id: Uint8List(16),
            source: 'folder',
            volume: const Value('/p'),
            sourceId: 'x',
            size: 1,
            mtime: 1,
            path: const Value('2024/a.jpg'),
            folder: const Value(7),
          ),
        );
    final row = await db.select(db.localAsset).getSingle();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [replicaProvider.overrideWith((ref) async => db)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: InfoPanel(row)),
        ),
      ),
    );
    await tester.pump();
    // In the file's sheet.
    await tester.tap(find.text('a.jpg'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Exclude this folder'));
    await tester.pump();
    await tester.pump();
    expect((await db.select(db.deviceFolder).getSingle()).visibility, 'hidden');
    expect(await db.timelineDays(false, null).get(), isEmpty);
    // The panel's queries close on a timer.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  });

  group('a browser with File System Access', () {
    late _Browser browser;
    Future<void> pumpBrowser(WidgetTester tester) => pumpApp(
      tester,
      replica: (_) => db,
      overrides: [
        browserFoldersProvider.overrideWithValue(browser = _Browser(db)),
      ],
    );

    testWidgets('adds the folder the user picks, or says it overlaps', (
      tester,
    ) async {
      await pumpBrowser(tester);
      browser.picked = 'Photos';
      await tester.tap(find.text('Add folder'));
      await tester.pump();
      expect(await roots(), ['Photos']);
      expect(find.textContaining('already in the library'), findsNothing);

      await tester.tap(find.text('Add folder'));
      await tester.pump();
      expect(await roots(), ['Photos']);
      expect(find.textContaining('already in the library'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('asks again for access to an offline folder', (tester) async {
      await db.batch(
        (b) => b.insertAll(db.mediaSource, [
          MediaSourceCompanion.insert(
            root: 'Away',
            state: const Value('offline'),
          ),
          MediaSourceCompanion.insert(
            root: 'Here',
            state: const Value('online'),
          ),
        ]),
      );
      await pumpBrowser(tester);
      await openFolders(tester);
      expect(find.byTooltip('Allow access to this folder'), findsOneWidget);
      await tester.tap(find.byTooltip('Allow access to this folder'));
      await tester.pump();
      expect(browser.allowed, ['Away']);
      await unmount(tester);
    });
  });

  test('the macOS sandbox lets the app read the folders the user picks, '
      'from one start to the next, and save the diagnostic bundle and '
      'downloads where the user chose', () {
    // Read-write for the save dialog (ADR-0115, ADR-0128); the folders'
    // bookmarks still grant only reading.
    expect(
      File('macos/Runner/FolderAccess.swift').readAsStringSync(),
      contains('.securityScopeAllowOnlyReadAccess'),
    );
    for (final build in ['DebugProfile', 'Release']) {
      for (final entitlement in [
        'com.apple.security.files.user-selected.read-write',
        'com.apple.security.files.bookmarks.app-scope',
      ]) {
        expect(
          File('macos/Runner/$build.entitlements').readAsStringSync(),
          contains('<key>$entitlement</key>\n\t<true/>'),
          reason: '$build: $entitlement',
        );
      }
    }
  });

  group('macOS', () {
    test(
      'logs each bookmark kept, forgotten or lost, and each failure',
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        const channel = MethodChannel('org.photolib/folders');
        messenger.setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'forget') throw PlatformException(code: 'gone');
          return call.method == 'lost' ? ['/b'] : null;
        });
        final heard = <LogRecord>[];
        addTearDown(() {
          messenger.setMockMethodCallHandler(channel, null);
          debugDefaultTargetPlatformOverride = null;
        });
        addTearDown(Log.records.listen(heard.add).cancel);
        final access = ProviderContainer().read(folderAccessProvider)!;
        await access.keep('/a');
        expect(await access.lost(['/a', '/b']), {'/b'});
        await expectLater(
          access.forget('/a'),
          throwsA(isA<PlatformException>()),
        );
        expect(
          [for (final r in heard) '${r.message} ${r.fields}'],
          [
            'bookmark keep {folders: /a}',
            'bookmark lost {folders: [/a, /b], lostFolders: [/b]}',
            'bookmark forget failed {folders: /a}',
          ],
        );
        expect(heard.last.error, isA<PlatformException>());
        expect(takeProblems(), [contains('bookmark forget failed')]);
      },
    );

    test('asks which folders it lost when they change, not at every '
        'directory a scan finishes', () async {
      await addFolder(db, '/a');
      final access = _Access();
      final app = ProviderContainer(
        overrides: [
          replicaProvider.overrideWith((ref) async => db),
          folderAccessProvider.overrideWithValue(access),
        ],
      );
      addTearDown(app.dispose);
      final checkpoints = <String?>[];
      final folders = watchFolders(db)
          .listen((f) => checkpoints.add(f.first.checkpoint));
      addTearDown(folders.cancel);
      Future<void> until(bool Function() done) async {
        while (!done()) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
      }

      app.listen(lostFoldersProvider, (_, _) {});
      await until(() => access.asked.isNotEmpty);
      for (final dir in ['2023', '2024', '2025']) {
        await (db.update(db.mediaSource)..where((s) => s.root.equals('/a')))
            .write(MediaSourceCompanion(checkpoint: Value(dir)));
        await until(() => checkpoints.last == dir);
      }
      await addFolder(db, '/b');
      await until(() => access.asked.last.length == 2);
      expect(access.asked, [
        ['/a'],
        ['/a', '/b'],
      ]);
    });

    testWidgets('keeps a bookmark of each folder picked, and drops it with '
        'the folder', (tester) async {
      final access = _Access();
      await pumpDesktop(tester, picked: '/Users/me/Pictures', access: access);
      await tester.tap(find.text('Add folder'));
      await tester.pump();
      expect(access.kept, ['/Users/me/Pictures']);
      await openFolders(tester);
      await tester.tap(find.byTooltip('Remove folder'));
      // A scanning folder's progress bar never settles.
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text('Remove'));
      await tester.pump();
      await tester.pump();
      expect(access.forgotten, ['/Users/me/Pictures']);
      await unmount(tester);
    });

    testWidgets('a folder whose access is gone offers to allow it again, '
        'over the library and in Settings', (tester) async {
      await addFolder(db, '/Volumes/Photos');
      await addFolder(db, '/Users/me/Pictures');
      final access = _Access()
        ..gone.addAll(['/Volumes/Photos', '/Users/me/Pictures']);
      await pumpDesktop(tester, picked: '/Volumes/Photos', access: access);
      await tester.pump();
      expect(
        find.text('Photolib can no longer read 2 folders.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Allow access'));
      await tester.pump();
      expect(pickedIn, ['/Users/me/Pictures'], reason: 'it opens there');
      expect(access.kept, isEmpty, reason: 'another folder was picked');

      await openFolders(tester);
      final allow = find.byTooltip('Allow access to this folder');
      expect(allow, findsNWidgets(2));
      await tester.tap(
        find.descendant(
          of: find.ancestor(
            of: find.textContaining('/Volumes/Photos'),
            matching: find.byType(ListTile),
          ),
          matching: allow,
        ),
      );
      await tester.pump();
      // The tree queries the replica again.
      await tester.pump(const Duration(seconds: 1));
      expect(pickedIn.last, '/Volumes/Photos');
      expect(access.kept, ['/Volumes/Photos']);
      expect(allow, findsOneWidget);
      await unmount(tester);
    });
  });

  test('the folders follow a scan, which commits a directory at a time, at '
      'most once a second, ending with what the scan left', () async {
    await addFolder(db, '/p');
    final app = ProviderContainer(
      overrides: [replicaProvider.overrideWith((ref) async => db)],
    );
    addTearDown(app.dispose);
    final counts = <int>[];
    // From before the first, so that n counts a second apart fit.
    final took = Stopwatch()..start();
    app.listen(
      sourceTreeProvider,
      (_, next) => counts.addAll([?next.value?.children.single.itemsBelow]),
    );
    while (counts.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    for (var n = 1; n <= 50; n++) {
      await db
          .into(db.localAsset)
          .insert(
            LocalAssetCompanion.insert(
              id: Uint8List(16)..[15] = n,
              source: 'folder',
              volume: const Value('/p'),
              sourceId: '$n',
              size: 1,
              mtime: 1,
            ),
          );
    }
    while (counts.last < 50) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(
      counts.length,
      lessThanOrEqualTo(1 + took.elapsed.inSeconds),
      reason: "each count reads the folder's index, a million entries in one",
    );
  });

  group('Settings', () {
    var n = 0;
    LocalAssetCompanion item(String root, String state) =>
        LocalAssetCompanion.insert(
          id: Uint8List(16)..[15] = ++n,
          source: 'folder',
          volume: Value(root),
          sourceId: '$n',
          size: 1,
          mtime: 1,
          state: Value(state),
        );
    setUp(
      () => db.batch((b) {
        for (final (root, state, items) in [
          ('/a', 'scanning', ['present', 'present']),
          ('/b', 'online', ['present', 'missing']),
          ('/c', 'offline', ['offline', 'offline', 'offline']),
        ]) {
          b
            ..insert(
              db.mediaSource,
              MediaSourceCompanion.insert(root: root, state: Value(state)),
            )
            ..insertAll(db.localAsset, [for (final i in items) item(root, i)]);
        }
      }),
    );

    Finder tile(String root) => find.ancestor(
      of: find.textContaining(root),
      matching: find.byType(ListTile),
    );

    testWidgets('lists each folder with its state and item count', (
      tester,
    ) async {
      await pumpDesktop(tester);
      await openFolders(tester);
      for (final (root, status) in [
        ('/a', 'Scanning, 2 items so far'),
        ('/b', '1 item'),
        ('/c', 'Offline, 3 items'),
      ]) {
        expect(
          find.descendant(of: tile(root), matching: find.text(status)),
          findsOneWidget,
          reason: root,
        );
      }
      expect(
        find.descendant(
          of: tile('/a'),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await db.into(db.localAsset).insert(item('/a', 'present'));
      await (db.update(db.mediaSource)..where((s) => s.root.equals('/a')))
          .write(const MediaSourceCompanion(state: Value('online')));
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: tile('/a'), matching: find.text('3 items')),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await unmount(tester);
    });

    testWidgets('stops watching the folders once closed', (tester) async {
      await pumpDesktop(tester);
      await openFolders(tester);
      final app = ProviderScope.containerOf(
        tester.element(find.byType(Scaffold).last),
      );
      expect(app.exists(sourceTreeProvider), isTrue);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(app.exists(sourceTreeProvider), isFalse);
      await unmount(tester);
    });

    testWidgets('say when the local store cannot open, over the folders it '
        'listed, and Try again opens it and asks for lost folders again', (
      tester,
    ) async {
      var fails = false;
      final access = _Access()..gone.add('/c');
      await pumpDesktop(
        tester,
        access: access,
        replica: (_) async =>
            fails ? throw StateError('database worker error') : db,
      );
      await openFolders(tester);
      expect(tile('/b'), findsOneWidget);

      fails = true;
      ProviderScope.containerOf(tester.element(find.byType(SourcesPage)))
          .invalidate(replicaProvider);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.text('Photolib could not open the library kept on this device'),
        findsOneWidget,
      );
      expect(tile('/b'), findsNothing);

      fails = false;
      access.asked.clear();
      await open(tester, find.text('Try again'));
      expect(find.text('Try again'), findsNothing);
      expect(access.asked, [
        ['/a', '/b', '/c'],
      ]);
      expect(
        find.descendant(
          of: tile('/c'),
          matching: find.byTooltip('Allow access to this folder'),
        ),
        findsOneWidget,
      );
      await unmount(tester);
    });

    testWidgets('say when the macOS bookmarks cannot tell which folders '
        'are lost, and Try again asks again', (tester) async {
      final access = _Access()
        ..fails = true
        ..gone.add('/c');
      await pumpDesktop(tester, access: access);
      await openFolders(tester);
      // Riverpod retries an exception for 38 s, a frame at a time, and drift
      // cancels the failed query on the real event loop.
      for (var s = 0; s < 60; s++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(tile('/b'), findsNothing);

      access.fails = false;
      await open(tester, find.text('Try again'));
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.byTooltip('Allow access to this folder'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('adds a folder', (tester) async {
      await pumpDesktop(tester, picked: '/d');
      await openFolders(tester);
      await tester.tap(find.byTooltip('Add folder'));
      await tester.pump();
      expect(await roots(), ['/a', '/b', '/c', '/d']);
      // The list follows the library at most once a second.
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.descendant(
          of: tile('/d'),
          matching: find.text('Scanning, 0 items so far'),
        ),
        findsOneWidget,
      );
      await unmount(tester);
    });

    testWidgets('removes a folder and its items once confirmed', (
      tester,
    ) async {
      await pumpDesktop(tester);
      await openFolders(tester);
      Future<void> remove(String button) async {
        await tester.tap(
          find.descendant(
            of: tile('/b'),
            matching: find.byTooltip('Remove folder'),
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.textContaining(RegExp('/b.? leave the library')),
          findsOneWidget,
        );
        await tester.tap(find.text(button));
        await tester.pump(const Duration(seconds: 1));
      }

      await remove('Cancel');
      expect(await roots(), ['/a', '/b', '/c']);

      await remove('Remove');
      expect(await roots(), ['/a', '/c']);
      expect(
        {for (final a in await db.select(db.localAsset).get()) a.volume},
        {'/a', '/c'},
      );
      expect(tile('/b'), findsNothing);
      await unmount(tester);
    });

    testWidgets("search's folder tree removes a desktop folder, once "
        'confirmed, as Settings does', (tester) async {
      await pumpDesktop(tester);
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Folder'));
      // The tree's spinner of a scan never settles.
      await open(tester, find.text('Folder'));
      await tester.tap(
        find.descendant(
          of: tile('/b'),
          matching: find.byTooltip('Remove folder'),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.textContaining(RegExp('/b.? leave the library')),
        findsOneWidget,
      );
      await tester.tap(find.text('Remove'));
      await tester.pump(const Duration(seconds: 1));
      expect(await roots(), ['/a', '/c']);
      await unmount(tester);
    });
  });
}

/// File System Access whose picker answers with [picked], adding it as the
/// real one does.
class _Browser implements BrowserFolders {
  new(this.db);

  final Replica db;
  String? picked;
  final allowed = <String>[];

  @override
  Future<bool?> pick(Replica db) async =>
      picked == null ? null : await addFolder(db, picked!);

  @override
  Future<void> allow(Replica db, String root) async => allowed.add(root);
}

class _Access implements FolderAccess {
  final kept = <String>[];
  final forgotten = <String>[];
  final gone = <String>{};

  @override
  Future<void> keep(String root) async {
    kept.add(root);
    gone.remove(root);
  }

  @override
  Future<void> forget(String root) async => forgotten.add(root);

  final asked = <List<String>>[];

  /// Whether [lost] fails, as the bookmarks' channel can.
  bool fails = false;

  @override
  Future<Set<String>> lost(Iterable<String> roots) async {
    asked.add([...roots]);
    if (fails) throw PlatformException(code: 'bookmarks');
    return roots.toSet().intersection(gone);
  }
}
