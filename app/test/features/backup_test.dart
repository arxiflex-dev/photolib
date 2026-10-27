import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/backup/backup.dart';
import 'package:photolib/features/servers/hints.dart' show followProvider;
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/servers/sync.dart' show syncProvider;
import 'package:photolib_api/photolib_api.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../support/fake_server.dart';
import '../support/pump_app.dart';

const DeviceState _metered = (
  metered: true,
  roaming: false,
  charging: true,
  battery: 80,
);

void main() {
  group('what a run may send', () {
    test('everything on an unmetered network', () {
      final c = backupConditions(const BackupSettings(), anyDevice);
      expect((c.photos, c.videos, c.cap, c.stop), (true, true, null, null));
    });

    test('photos up to the cap on a metered one, videos as chosen', () {
      var c = backupConditions(const BackupSettings(), _metered);
      expect((c.photos, c.videos, c.cap), (true, false, 50000000));
      c = backupConditions(
        const BackupSettings().copyWith(
          photosMetered: false,
          videosMetered: true,
          clear: {'meteredCap'},
        ),
        _metered,
      );
      expect((c.photos, c.videos, c.cap), (false, true, null));
    });

    test('nothing while it must charge, the battery is low or it roams', () {
      String? stop(BackupSettings s, DeviceState d) =>
          backupConditions(s, d).stop;
      const unplugged = (
        metered: false,
        roaming: false,
        charging: false,
        battery: 50,
      );
      const charging = BackupSettings(charging: true);
      expect(stop(charging, unplugged), 'charging');
      expect(stop(charging, anyDevice), isNull);
      expect(stop(const BackupSettings(), unplugged), isNull);
      expect(
        stop(const BackupSettings(), (
          metered: false,
          roaming: false,
          charging: false,
          battery: 19,
        )),
        'battery_low',
      );
      const roaming = (
        metered: true,
        roaming: true,
        charging: true,
        battery: 80,
      );
      expect(stop(const BackupSettings(), roaming), 'roaming');
      expect(stop(const BackupSettings(roaming: true), roaming), isNull);
    });

    test("NetworkManager's metered flag, guessed for a hotspot or tethering, "
        'counts', () {
      for (final (value, metered) in [
        (1, true),
        (3, true),
        (2, false),
        (4, false),
        (0, false),
      ]) {
        expect(meteredByNetworkManager('(<uint32 $value>,)\n'), metered);
      }
      expect(meteredByNetworkManager(''), isFalse, reason: 'no gdbus');
    });

    test("a Linux laptop's battery and mains", () async {
      final dir = Directory.systemTemp.createTempSync('photolib-power-');
      addTearDown(() => dir.deleteSync(recursive: true));
      void supply(String name, Map<String, String> files) {
        for (final MapEntry(:key, :value) in files.entries) {
          File('${dir.path}/$name/$key')
            ..createSync(recursive: true)
            ..writeAsStringSync('$value\n');
        }
      }

      expect(await linuxPower(dir), (true, 100), reason: 'a desktop');
      supply('BAT0', {
        'type': 'Battery',
        'capacity': '15',
        'status': 'Discharging',
      });
      supply('AC', {'type': 'Mains', 'online': '0'});
      expect(await linuxPower(dir), (false, 15));
      supply('AC', {'online': '1'});
      expect(await linuxPower(dir), (true, 15));
    });
  });

  test('backup is overdue once items have waited the hours chosen since it '
      'last completed, or since it first ran', () {
    const hour = 3600000;
    const now = 100 * hour;
    BackupStatus status(int pending, {int? completed, int? first}) => (
      completed: completed,
      first: first,
      stopped: null,
      pending: pending,
      contact: null,
    );
    expect(backupOverdue(status(3, completed: now - 25 * hour), 24, now), true);
    expect(
      backupOverdue(status(3, completed: now - 23 * hour), 24, now),
      false,
    );
    expect(backupOverdue(status(0, completed: 0), 24, now), false);
    expect(backupOverdue(status(3, first: now - 24 * hour), 24, now), true);
    expect(backupOverdue(status(3), 24, now), false, reason: 'never ran');
  });

  group('the device backs up', () {
    late Replica db;
    late MemoryStore keystore;
    late MemoryStore settings;
    late FakeServer server;
    late List<(NetworkConfig, BackupSelection, BackupConditions, String?)> runs;
    late List<(String, String)> notices;
    var answer = const BackupRunData(
      id: 1,
      started: 0,
      uploaded: 0,
      linked: 0,
      failed: 0,
      pending: 0,
    );
    final day = const Duration(days: 1).inMilliseconds;
    late int now;

    String saved({int? expires}) => jsonEncode(
      SavedServer(
        endpoints: [Uri.parse('https://photos.example.org')],
        instance: 'instance-a',
        account: Account(
          name: 'ann',
          token: 'token',
          deviceId: 'device-1',
          expires: expires == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(expires, isUtc: true),
        ),
      ).toJson(),
    );

    setUp(() {
      now = DateTime.now().millisecondsSinceEpoch;
      db = Replica(NativeDatabase.memory());
      keystore = MemoryStore(saved(expires: now + 60 * day));
      settings = MemoryStore(
        jsonEncode({
          'enabled': true,
          'folders': {'folder:/p:': true},
        }),
      );
      var rotations = 0;
      server = FakeServer({
        'AuthService/RotateSession': (_) => RotateSessionResponse(
          session: Session(
            token: 'renewed-${++rotations}',
            deviceId: 'device-1',
            expiresAt: Timestamp.fromDateTime(
              DateTime.fromMillisecondsSinceEpoch(now + 90 * day),
            ),
          ),
        ),
      });
      runs = [];
      notices = [];
    });
    tearDown(() => db.close());

    List<Override> overrides() => [
      replicaProvider.overrideWith((ref) async => db),
      serverStoreProvider.overrideWithValue(keystore),
      backupStoreProvider.overrideWithValue(settings),
      backupSupportedProvider.overrideWithValue(true),
      connectProvider.overrideWithValue((config, instance) => server),
      deviceStateProvider.overrideWithValue(() async => _metered),
      noticeProvider.overrideWithValue(
        (title, body) async => notices.add((title, body)),
      ),
      runBackupProvider.overrideWithValue((
        db,
        config,
        selection,
        conditions, {
        instance,
      }) async {
        runs.add((config, selection, conditions, instance));
        return answer;
      }),
    ];

    /// The app started, once it has renewed its session as every start does.
    Future<ProviderContainer> start() async {
      final container = ProviderContainer(overrides: overrides());
      addTearDown(container.dispose);
      final started = (await container.read(accountsProvider.future)).server;
      while (started?.account != null &&
          container.read(serverProvider).value?.account?.token == 'token') {
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }
      await container.read(backupSettingsProvider.notifier).loaded;
      return container;
    }

    test('on its session, by the selection, as far as the network allows, '
        'with no sign-in', () async {
      final app = await start();
      await app.read(backupProvider.notifier).run();
      final [(config, selection, conditions, instance)] = runs;
      expect(config.session, 'renewed-1');
      expect(config.endpoints, [Uri.parse('https://photos.example.org')]);
      expect(instance, 'instance-a');
      expect(selection.folders, {'folder:/p:': true});
      expect((conditions.photos, conditions.videos), (true, false));
      expect(
        server.calls.map((c) => c.$1).where((m) => !m.startsWith('Admin')),
        ['AuthService/RotateSession'],
        reason:
            "the start's renewal, beside its role check; then its session "
            'is fresh',
      );
    });

    test('renews a session with under a month left before it backs up, as '
        'one running for weeks has, never needing a sign-in or a second '
        'factor', () async {
      final app = await start();
      final servers = app.read(accountsProvider.notifier);
      final weeksLater = SavedServer.fromJson(jsonDecode(saved()) as Map)
          .signedIn(
            Account(
              name: 'ann',
              token: 'renewed-1',
              deviceId: 'device-1',
              expires: DateTime.fromMillisecondsSinceEpoch(
                now + 10 * day,
                isUtc: true,
              ),
            ),
          );
      await servers.put(weeksLater);
      await app.read(backupProvider.notifier).run();
      expect(
        server.requests<RotateSessionRequest>('AuthService/RotateSession'),
        hasLength(2),
      );
      expect(runs.single.$1.session, 'renewed-2');
      final kept = Accounts.fromJson(jsonDecode(keystore.value!) as Map)
          .server!;
      expect(kept.account!.token, 'renewed-2');
      expect(kept.account!.expires?.millisecondsSinceEpoch, now + 90 * day);
      // A call made with the old token, refused, signs nothing out.
      await servers.ended('renewed-1');
      expect(app.read(serverProvider).value!.account!.token, 'renewed-2');
    });

    test('a revocation signs the device out, which it remembers across a '
        'restart, and backs nothing up until the next sign-in', () async {
      answer = answer.copyWith(stopped: const Value('signed_out'));
      addTearDown(() => answer = answer.copyWith(stopped: const Value(null)));
      final app = await start();
      await app.read(backupProvider.notifier).run();
      final kept = Accounts.fromJson(jsonDecode(keystore.value!) as Map)
          .server!;
      expect((kept.account, kept.ended), (null, true));
      runs.clear();
      final again = await start();
      expect(again.read(serverProvider).value!.ended, isTrue);
      await again.read(backupProvider.notifier).run();
      expect(runs, isEmpty);
    });

    test('warns once when backup is overdue, and not again until it has '
        'completed', () async {
      await db.batch((b) {
        b
          ..insert(
            db.localAsset,
            LocalAssetCompanion.insert(
              id: Uint8List(16),
              source: 'folder',
              sourceId: '1',
              size: 1,
              mtime: 1,
            ),
          )
          ..insert(
            db.backupState,
            BackupStateCompanion.insert(
              localAssetId: Uint8List(16),
              state: 'selected',
              updatedAt: 1,
            ),
          )
          ..insert(
            db.backupRun,
            BackupRunCompanion.insert(started: now - 25 * 3600000),
          );
      });
      final app = await start();
      await app.read(backupProvider.notifier).run();
      expect(notices, [
        (
          'Backup has not completed',
          'No complete backup for 24 h. Waiting: 1 item',
        ),
      ]);
      await app.read(backupProvider.notifier).run();
      expect(notices, hasLength(1));
    });
  });

  group('the screens', () {
    late Replica db;
    setUp(() => db = Replica(NativeDatabase.memory()));
    tearDown(() async {
      await db.close();
    });

    /// One item in [folder] under `/p` for each `state reason` of [states].
    Future<void> items(List<String> states, {String folder = ''}) =>
        db.batch((b) {
          for (final (n, line) in states.indexed) {
            final [state, reason] = line.split(' ');
            final id = Uint8List(16)..[15] = n;
            b
              ..insert(
                db.localAsset,
                LocalAssetCompanion.insert(
                  id: id,
                  source: 'folder',
                  volume: const Value('/p'),
                  sourceId: '$n',
                  size: 1,
                  mtime: 1,
                  path: Value('${folder}IMG_$n.jpg'),
                ),
              )
              ..insert(
                db.backupState,
                BackupStateCompanion.insert(
                  localAssetId: id,
                  state: state,
                  reason: Value(reason == 'null' ? null : reason),
                  retryAt: Value(state == 'failed' ? 1 << 41 : null),
                  updatedAt: 1,
                ),
              );
          }
        });

    ProviderContainer app(WidgetTester tester) =>
        ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

    testWidgets('the backup page explains why each item not backed up waits, '
        'and when a failed one is tried again', (tester) async {
      await items([
        'discovered folder_excluded',
        'discovered folder_new',
        'discovered type_excluded',
        'discovered before_date',
        'selected null',
        'selected server_restored',
        'hashing null',
        'uploading null',
        'paused metered',
        'paused metered_cap',
        'failed unreadable',
        'failed changed',
        'failed quota.exceeded',
        'failed field.invalid',
        'backed_up null',
        'linked duplicate',
      ]);
      await pumpApp(tester, replica: (_) => db, size: const Size(800, 4000));
      await tester.tapAndSettle(find.byTooltip('Settings'));
      await tester.tapAndSettle(find.text('Backup'));
      for (final why in [
        'In a folder you did not choose',
        'In a new folder: choose whether to back it up',
        'A kind of item you did not choose',
        'Taken before the date you chose',
        'Waiting for its turn',
        'The server lost it in a restore: sending it again',
        'Waiting for a network that is not metered',
        'Too large for a metered network',
        'This device cannot read it',
        'It changed while it was sent',
        'Your storage on the server is full',
        'The server refused it: field.invalid',
      ]) {
        expect(find.text(why), findsOneWidget, reason: why);
      }
      expect(find.text('Being backed up'), findsOneWidget, reason: 'hashing');
      expect(find.text('2 items'), findsOneWidget, reason: 'working, twice');
      expect(find.textContaining('Trying again'), findsNWidgets(4));
      expect(find.text('Waiting: 10 items'), findsOneWidget);

      await tester.tapAndSettle(find.text('This device cannot read it'));
      expect(find.text('IMG_10.jpg'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    });

    testWidgets('the home screen asks once about each new folder, and says '
        'when backup last completed and what waits', (tester) async {
      await items(['selected null'], folder: 'Trip/');
      await pumpApp(tester, replica: (_) => db);
      app(tester)
          .read(backupSettingsProvider.notifier)
          .edit((s) => s.copyWith(enabled: true));
      await tester.pumpAndSettle();
      expect(find.text('New folder Trip: back it up?'), findsOneWidget);
      expect(find.text('No complete backup yet'), findsOneWidget);
      expect(find.text('Waiting: 1 item'), findsOneWidget);
      await tester.tapAndSettle(find.text('Back it up'));
      expect(find.textContaining('New folder'), findsNothing);
      expect(app(tester).read(backupSettingsProvider).folders, {
        'folder:/p:Trip/': true,
      });
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    });

    testWidgets('the home screen says when the device last reached a server '
        'out of reach (ADR-0200 B7)', (tester) async {
      final synced = DateTime(2026, 10, 23, 13, 20);
      await items(['selected null']);
      await db
          .into(db.syncCursor)
          .insert(
            SyncCursorCompanion.insert(
              stream: 'library',
              cursor: Uint8List(1),
              updatedAt: synced.millisecondsSinceEpoch,
            ),
          );
      await db
          .into(db.backupRun)
          .insert(
            BackupRunCompanion.insert(
              started: 1,
              ended: const Value(2),
              stopped: const Value('offline'),
            ),
          );
      // Signed in, as a device that synced is: signed out, the replica
      // forgets the server (ADR-0267).
      final offline = Unreachable('offline');
      await pumpApp(
        tester,
        replica: (_) => db,
        serverStore: MemoryStore(
          jsonEncode(
            SavedServer(
              endpoints: [Uri.parse('https://photos.example.org')],
              instance: 'instance-a',
              account: Account(
                name: 'ann',
                token: 'token',
                deviceId: 'device-1',
                expires: DateTime.utc(2099),
              ),
            ).toJson(),
          ),
        ),
        overrides: [
          connectProvider.overrideWithValue(
            (config, instance) =>
                FakeServer({'AuthService/RotateSession': (_) => offline}),
          ),
          syncProvider.overrideWithValue((db, config, instance) async {
            throw offline;
          }),
          followProvider.overrideWithValue(null),
          runBackupProvider.overrideWithValue(
            (db, config, selection, conditions, {instance}) async =>
                throw offline,
          ),
        ],
      );
      app(tester)
          .read(backupSettingsProvider.notifier)
          .edit((s) => s.copyWith(enabled: true));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Waiting: 1 item\n'
          'Backup waits until the server is in reach\n'
          'Last contact with the server Oct 23, 2026 1:20\u202fPM',
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    });

    testWidgets('the home screen keeps a notice naming the fix while the '
        'server has signed the device out', (tester) async {
      final serverStore = MemoryStore(
        jsonEncode(
          SavedServer(
            endpoints: [Uri.parse('https://photos.example.org')],
            instance: 'instance-a',
            ended: true,
          ).toJson(),
        ),
      );
      await pumpApp(tester, replica: (_) => db, serverStore: serverStore);
      app(tester)
          .read(backupSettingsProvider.notifier)
          .edit((s) => s.copyWith(enabled: true));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Backup stopped: the server signed this device out. '
          'Sign in again in Settings.',
        ),
        findsOneWidget,
      );
      await tester.tapAndSettle(find.text('Sign in'));
      expect(find.text('Email or sign-in name'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    });
  });
}
