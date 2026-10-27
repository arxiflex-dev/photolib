import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:test/test.dart';

void main() {
  late Replica db;
  var n = 0;
  Uint8List id() => Uint8List(16)..[15] = ++n;
  setUp(() {
    n = 0;
    db = Replica(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  Future<Uint8List> person(
    String? name, {
    int faces = 1,
    bool hidden = false,
    bool cover = true,
    Uint8List? mergedInto,
  }) async {
    final p = id();
    final first = id();
    await db
        .into(db.face)
        .insert(
          FaceCompanion.insert(
            id: first,
            assetId: Uint8List(16)..[0] = n,
            bbox: '0,0,1,1',
            personId: Value(p),
          ),
        );
    for (var i = 1; i < faces; i++) {
      await db
          .into(db.face)
          .insert(
            FaceCompanion.insert(
              id: id(),
              assetId: id(),
              bbox: '0,0,1,1',
              personId: Value(p),
            ),
          );
    }
    await db
        .into(db.person)
        .insert(
          PersonCompanion.insert(
            id: p,
            ownerId: Uint8List(16),
            name: Value(name),
            hidden: Value(hidden ? 1 : 0),
            coverFaceId: Value(cover ? first : null),
            mergedInto: Value(mergedInto),
          ),
        );
    return first;
  }

  test(
    'the named person with the most faces, and the asset of their cover',
    () async {
      await person('Ann', faces: 2);
      await person('Bo', faces: 5);
      await person('Cy', faces: 3);
      final top = await topPerson(db);
      expect(top?.name, 'Bo');
      expect(top?.asset, isNotNull);
    },
  );

  test('unnamed, hidden, merged and cover-less people are no one', () async {
    await person(null, faces: 9);
    await person('', faces: 9);
    await person('Hidden', faces: 9, hidden: true);
    await person('Nocover', faces: 9, cover: false);
    await person('Merged', faces: 9, mergedInto: Uint8List(16));
    expect(await topPerson(db), isNull);
    await person('Dee');
    expect((await topPerson(db))?.name, 'Dee');
  });
}
