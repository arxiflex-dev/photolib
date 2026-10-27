import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/features/gallery/widgets.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib_data/photolib_data.dart' hide Stack;

void main() {
  late Replica db;
  late Directory dir;
  var n = 0;
  setUp(() async {
    db = Replica(NativeDatabase.memory());
    dir = await Directory.systemTemp.createTemp('photolib-widgets-');
    n = 0;
  });
  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  Future<Uint8List> photo(
    String taken, {
    bool favorite = false,
    String path = 'DCIM/Camera/',
  }) async {
    final id = Uint8List(16)..[15] = ++n;
    await db
        .into(db.localAsset)
        .insert(
          LocalAssetCompanion.insert(
            id: id,
            source: 'mediastore',
            volume: const Value('external_primary'),
            sourceId: '$n',
            size: 1,
            mtime: 0,
            path: Value(path),
            name: Value('$n.jpg'),
            mime: const Value('image/jpeg'),
            takenLocal: Value(taken),
            takenUtc: Value(DateTime.parse('${taken}Z').millisecondsSinceEpoch),
            favorite: Value(favorite ? 1 : 0),
          ),
        );
    return id;
  }

  Future<Uint8List> render(ThumbnailItem item) async =>
      Uint8List.fromList(utf8.encode('png of ${item.uri.pathSegments.last}'));

  Map<String, Object?> snapshot() =>
      jsonDecode(File('${dir.path}/snapshot.json').readAsStringSync())
          as Map<String, Object?>;

  test('picks a memory, the latest favourite and an album cover', () async {
    await photo('2019-10-27T10:00:00');
    final old = await photo('2020-05-01T10:00:00', favorite: true);
    final latest = await photo('2024-05-01T10:00:00', favorite: true);
    await photo('2025-01-01T10:00:00');
    final album = await createAlbum(db, 'Summer');
    await addToAlbum(db, album, [old]);

    final pictures = await widgetPictures(
      db,
      DateTime(2026, 10, 27),
      favourites: 'Favourites',
    );

    expect(
      pictures.keys,
      unorderedEquals(['memories', 'favourites', 'albums']),
    );
    expect(pictures['memories']!.title, '2019');
    expect(pictures['memories']!.link.path, '/library');
    expect(pictures['favourites']!.title, 'Favourites');
    expect(pictures['favourites']!.item.id, latest);
    expect(pictures['favourites']!.link.path, '/collections/favourites');
    expect(pictures['albums']!.title, 'Summer');
    expect(pictures['albums']!.link.path, '/shortcut/album');
  });

  test('an empty library has nothing to show', () async {
    expect(
      await widgetPictures(db, DateTime(2026, 10, 27), favourites: 'F'),
      isEmpty,
    );
  });

  test('writes the pictures and a snapshot that names them', () async {
    await photo('2019-10-27T10:00:00');
    await photo('2024-05-01T10:00:00', favorite: true);
    final pictures = await widgetPictures(
      db,
      DateTime(2026, 10, 27),
      favourites: 'Favourites',
    );
    final changed = await writeWidgetPictures(dir, pictures, render);
    expect(changed, isTrue);
    final json = snapshot();
    expect((json['memories']! as Map)['title'], '2019');
    final image = (json['memories']! as Map)['image']! as String;
    expect(File('${dir.path}/$image').readAsStringSync(), 'png of 1');
    expect(json.keys, containsAll(['memories', 'favourites']));
    expect(json.keys, isNot(contains('people')));
    // Nothing new: the widgets are not redrawn.
    expect(await writeWidgetPictures(dir, pictures, render), isFalse);
  });

  test('a picture that cannot be rendered is left out, and pictures no '
      'longer named go', () async {
    await photo('2019-10-27T10:00:00');
    await photo('2024-05-01T10:00:00', favorite: true);
    final pictures = await widgetPictures(
      db,
      DateTime(2026, 10, 27),
      favourites: 'Favourites',
    );
    await writeWidgetPictures(dir, pictures, render);
    // The snapshot and one picture each.
    expect(dir.listSync().length, 3);
    await File('${dir.path}/stale.png').writeAsString('old');
    // The memory's picture is gone, so it must be rendered again.
    File('${dir.path}/${pictures['memories']!.item.key}.png').deleteSync();
    await writeWidgetPictures(dir, pictures, (item) async {
      if (item.key == pictures['memories']!.item.key) {
        throw StateError('no decoder');
      }
      return await render(item);
    });
    // The memory is out of the snapshot, the favourite stays; stale.png goes.
    expect(snapshot().keys, ['favourites']);
    expect(File('${dir.path}/stale.png').existsSync(), isFalse);
  });

  test(
    'the people widget shows the cover of the person with most faces',
    () async {
      final asset = await photo('2021-01-01T10:00:00');
      final face = Uint8List(16)..[0] = 9;
      final person = Uint8List(16)..[0] = 7;
      await db
          .into(db.face)
          .insert(
            FaceCompanion.insert(
              id: face,
              assetId: asset,
              bbox: '0,0,1,1',
              personId: Value(person),
            ),
          );
      await db
          .into(db.person)
          .insert(
            PersonCompanion.insert(
              id: person,
              ownerId: Uint8List(16),
              name: const Value('Ann'),
              coverFaceId: Value(face),
            ),
          );
      final pictures = await widgetPictures(
        db,
        DateTime(2026, 10, 27),
        favourites: 'F',
      );
      expect(pictures['people']?.title, 'Ann');
      expect(pictures['people']?.item.id, asset);
    },
  );
}
