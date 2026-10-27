// The default-gallery readiness gates of M1-46 (docs/dev/android-default-gallery.md):
// no operation on a user's files loses one under a full disk, a 300-character
// name or a kill in the middle of a move; the trash gives back what it took.
// ignore_for_file: avoid_slow_async_io
@TestOn('linux')
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/core/media_store.dart';
import 'package:photolib/features/folders/file_ops.dart';
import 'package:photolib/features/folders/rename.dart';
import 'package:photolib_data/photolib_data.dart' show LocalAssetData;

void main() {
  late Directory tmp;
  late Directory other;
  // /dev/shm is another file system than the temp directory's on most hosts:
  // the move cannot rename and copies, as between a phone's volumes.
  final shm = Directory('/dev/shm');
  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('photolib-ready-');
    other = await shm.createTemp('photolib-ready-');
  });
  tearDown(() async {
    await tmp.delete(recursive: true);
    await other.delete(recursive: true);
  });

  Future<File> file(String path, {int kib = 64}) async {
    final f = File(path);
    final random = Random(path.length);
    await f.writeAsBytes([
      for (var i = 0; i < kib << 10; i++) random.nextInt(256),
    ]);
    await f.setLastModified(DateTime.utc(2001, 2, 3, 4, 5, 6));
    return f;
  }

  Future<String> sum(File f) async =>
      (await sha256.bind(f.openRead()).single).toString();

  Future<List<String>> names(Directory d) async =>
      [for (final e in await d.list().toList()) e.path.split('/').last]..sort();

  group('a full disk', () {
    test('loses nothing: a copy that cannot be written leaves the original, '
        'no target and no partial file', () async {
      if (!File('/dev/full').existsSync()) markTestSkipped('no /dev/full');
      final source = await file('${tmp.path}/a.jpg');
      final before = await sum(source);
      // The part file the copy writes is /dev/full: every write fails with
      // ENOSPC, as on a disk with no room. (Dart cannot delete a link to it,
      // so the link stays; a regular partial file would go.)
      final part = partOf(other.path, '${other.path}/a.jpg');
      await Link(part).create('/dev/full');
      final transfer = Transfer([source.path], other.path, move: true);
      await transfer.run();
      expect(transfer.files.single.error, contains('No space left'));
      expect(transfer.files.single.target, isNull);
      expect(await sum(source), before);
      expect(File('${other.path}/a.jpg').existsSync(), isFalse);
      expect(await names(other), [part.split('/').last]);
    });

    test('a copy is not made at all of a move that cannot rename', () async {
      final source = await file('${tmp.path}/b.jpg');
      final before = await sum(source);
      final transfer = Transfer([source.path], other.path, move: true);
      await transfer.run();
      expect(transfer.files.single.error, isNull);
      expect(await sum(File(transfer.files.single.target!)), before);
      expect(source.existsSync(), isFalse);
      expect(
        (await File(transfer.files.single.target!).lastModified()).toUtc(),
        DateTime.utc(2001, 2, 3, 4, 5, 6),
      );
    });
  });

  group('names of 300 characters', () {
    final long = '${'n' * 296}.jpg';

    test('are refused by a rename before anything is touched', () async {
      final plan = planRename([
        (name: 'a.jpg', taken: DateTime(2024)),
      ], RenamePattern(template: 'n' * 296));
      expect(plan.single.problem, RenameProblem.tooLong);
    });

    test('count in bytes: 150 two-byte characters are too long', () {
      final plan = planRename([
        (name: 'a.jpg', taken: DateTime(2024)),
      ], RenamePattern(template: 'é' * 150));
      expect(plan.single.problem, RenameProblem.tooLong);
    });

    test('lose no file when the file system refuses them', () async {
      final source = await file('${tmp.path}/a.jpg');
      final before = await sum(source);
      final results = await renameFiles([(source.path, '${tmp.path}/$long')]);
      expect(results.single.error, isNotNull);
      expect(results.single.target, isNull);
      expect(await sum(source), before);
      expect(await names(tmp), ['a.jpg']);
    });

    test('a new folder of that name is refused', () async {
      expect(await createFolder(tmp.path, long), isNotNull);
      expect(await names(tmp), isEmpty);
    });

    test('a file with the longest name there is still moves between volumes: '
        'the temporary name does not depend on it', () async {
      final longest = '${'m' * 251}.jpg';
      final source = await file('${tmp.path}/$longest');
      final before = await sum(source);
      final transfer = Transfer([source.path], other.path, move: true);
      await transfer.run();
      expect(transfer.files.single.error, isNull);
      expect(await sum(File('${other.path}/$longest')), before);
      expect(source.existsSync(), isFalse);
    });

    test('a move to a name too long for the target loses nothing', () async {
      final source = await file('${tmp.path}/${'q' * 255}');
      final before = await sum(source);
      final transfer = Transfer([source.path], other.path, move: true);
      await transfer.run();
      // Either it moved whole or it stayed whole.
      final moved = File('${other.path}/${'q' * 255}');
      expect(source.existsSync() != moved.existsSync(), isTrue);
      expect(await sum(source.existsSync() ? source : moved), before);
    });
  });

  group('a kill in the middle of a move', () {
    test('keeps the file whole, in its place or moved, and leaves no half '
        'file under its name', () async {
      final source = await file('${tmp.path}/big.jpg', kib: 8192);
      final before = await sum(source);
      final transfer = Transfer([source.path], other.path, move: true);
      final running = transfer.run();
      // Killed as soon as it has begun.
      await Future<void>.delayed(const Duration(milliseconds: 2));
      transfer.cancel();
      await running;
      // The file is whole where it is: in its place, or moved; never half.
      final target = File('${other.path}/big.jpg');
      expect(source.existsSync() || target.existsSync(), isTrue);
      for (final f in [source, target]) {
        if (f.existsSync()) expect(await sum(f), before, reason: f.path);
      }
      // What is left of the copy is hidden and has no final name.
      expect([
        for (final n in await names(other))
          if (n != 'big.jpg') n,
      ], everyElement(startsWith('.photolib-')));
    });

    test('a process killed after the copy and before the removal leaves both, '
        'and moving again loses nothing', () async {
      final source = await file('${tmp.path}/c.jpg');
      final before = await sum(source);
      // What a kill leaves: the half-written partial file of the copy.
      await File(partOf(other.path, '${other.path}/c.jpg'))
          .writeAsBytes([1, 2, 3]);
      final transfer = Transfer([source.path], other.path, move: true);
      await transfer.run();
      expect(transfer.files.single.error, isNull);
      expect(await sum(File('${other.path}/c.jpg')), before);
      expect(source.existsSync(), isFalse);
      expect(await names(other), ['c.jpg']);
    });

    test(
      'files moved before the kill stay whole and the rest stay put',
      () async {
        final sources = [
          for (var i = 0; i < 4; i++)
            await file('${tmp.path}/$i.jpg', kib: 512),
        ];
        final sums = [for (final s in sources) await sum(s)];
        final transfer = Transfer(
          [for (final s in sources) s.path],
          other.path,
          move: true,
        );
        final running = transfer.run();
        await Future<void>.delayed(const Duration(milliseconds: 5));
        transfer.cancel();
        await running;
        for (final (i, s) in sources.indexed) {
          final moved = File('${other.path}/$i.jpg');
          final at = s.existsSync() ? s : moved;
          expect(at.existsSync(), isTrue, reason: 'file $i is somewhere');
          expect(await sum(at), sums[i], reason: 'file $i is whole');
        }
      },
    );
  });

  group('the trash', () {
    const channel = MethodChannel('org.photolib/media_requests');
    final calls = <(String, List<String>, bool)>[];
    setUp(() {
      calls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            final args = call.arguments as Map;
            calls.add((
              call.method,
              (args['uris'] as List).cast<String>(),
              args['value'] as bool,
            ));
            return switch (call.method) {
              'trash' when args['value'] == true => [
                for (final u in (args['uris'] as List))
                  1900000000000 + int.parse((u as String).split('/').last),
              ],
              _ => null,
            };
          });
    });
    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    LocalAssetData item(int id) => LocalAssetData(
      id: Uint8List(16)..[15] = id % 256,
      source: 'mediastore',
      volume: 'external_primary',
      sourceId: '$id',
      size: 1,
      mtime: 0,
      state: 'present',
      favorite: 0,
      trashed: 0,
      edited: 0,
      folder: 0,
      hidden: 0,
      archived: 0,
      tile: 0,
      mime: 'image/jpeg',
    );

    test('takes each item to the system trash, in batches of 2,000, and '
        'gives back when each expires, in order', () async {
      const store = MediaStoreChannel();
      final items = [for (var i = 1; i <= 4500; i++) item(i)];
      final binned = await store.trash(items);
      expect([for (final c in calls) c.$2.length], [2000, 2000, 500]);
      expect(calls.every((c) => c.$1 == 'trash' && c.$3), isTrue);
      expect([for (final b in binned) b.expires].first, 1900000000001);
      expect(binned.last.expires, 1900000004500);
      expect(binned, hasLength(4500));
      expect(binned.every((b) => b.bin == null), isTrue);
    });

    test(
      'restores exactly the items it was asked to, and nothing else',
      () async {
        const store = MediaStoreChannel();
        final items = [for (var i = 1; i <= 3; i++) item(i)];
        await store.restore(items);
        expect(calls.single.$1, 'trash');
        expect(calls.single.$3, isFalse);
        expect(calls.single.$2, [
          for (var i = 1; i <= 3; i++)
            'content://media/external_primary/images/media/$i',
        ]);
      },
    );

    test('deletes for good through the one delete request only', () async {
      const store = MediaStoreChannel();
      await store.purge([item(7)]);
      expect(calls.single.$1, 'delete');
    });

    test('a refusal leaves the items as they were', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(code: 'refused');
          });
      const store = MediaStoreChannel();
      await expectLater(
        store.trash([item(1)]),
        throwsA(isA<PlatformException>()),
      );
    });
  });

  test('the readiness doc names every gate the tests above prove', () {
    final doc = File('../docs/dev/android-default-gallery.md')
        .readAsStringSync();
    for (final gate in [
      'full disk',
      '300-character names',
      'kill mid-move',
      'trash fidelity',
      'thumbnail success equals playback success',
      'uninstall',
    ]) {
      expect(doc, contains(gate), reason: gate);
    }
    expect(utf8.encode(doc), isNotEmpty);
  });
}
