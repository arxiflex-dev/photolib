import 'dart:typed_data';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:fixnum/fixnum.dart';
import 'package:photolib_api/kernel.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:test/test.dart';

import 'kernel.dart';

void main() {
  final kernel = testKernel();
  late Replica db;
  var n = 0;
  setUp(() {
    n = 0;
    db = Replica(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  // The points as (id's last byte, lat, lon, seconds, cloud), by id: the scan's
  // order is the index's.
  List<(int, double, double, int, int)> rows(GeoPoints p) => [
    for (var i = 0; i < p.length; i++)
      (p.ids[i].last, p.latitudes[i], p.longitudes[i], p.times[i], p.cloud[i]),
  ]..sort((a, b) => a.$1.compareTo(b.$1));

  Future<void> photo({
    double? lat,
    double? lon,
    int takenUtc = 0,
    int hidden = 0,
    int trashed = 0,
    String state = 'present',
  }) => db
      .into(db.localAsset)
      .insert(
        LocalAssetCompanion.insert(
          id: Uint8List(16)..[15] = ++n,
          source: 'photokit',
          sourceId: 'asset-$n',
          size: n,
          mtime: 0,
          lat: Value(lat),
          lon: Value(lon),
          takenUtc: Value(takenUtc),
          hidden: Value(hidden),
          trashed: Value(trashed),
          state: Value(state),
        ),
      );

  test('geoPoints: the located items the timeline shows, with their '
      'positions and capture seconds', () async {
    await photo(lat: 48.85, lon: 2.35, takenUtc: 86400000);
    await photo(); // no position
    await photo(lat: 38.72, lon: -9.14, takenUtc: 3 * 86400000);
    await photo(lat: 1, lon: 1, hidden: 1);
    await photo(lat: 2, lon: 2, trashed: 1);
    await photo(lat: 3, lon: 3, state: 'missing');

    final points = await geoPoints(db);

    expect(rows(points), [
      (1, 48.85, 2.35, 86400, 0),
      (3, 38.72, -9.14, 3 * 86400, 0),
    ]);
    expect((await geoPoints(db, veiled: true)).length, 3);
  });

  test('geoPoints: videos are located items like photos, on the device and '
      'on the server', () async {
    await photo(lat: 48.85, lon: 2.35);
    await db.customStatement(
      "UPDATE local_asset SET mime = 'video/mp4' WHERE source_id = 'asset-1'",
    );
    await photo(lat: 48.86, lon: 2.36);
    await db.customStatement(
      'INSERT INTO library (id, owner_id, kind, privacy, access, state) '
      "VALUES (x'01', x'01', 'managed', 'standard', 'rw', 'online')",
    );
    await db.customStatement(
      'INSERT INTO asset (id, library_id, owner_id, original_filename, '
      "source, media_kind, lat, lon, taken_utc, created_at) VALUES (x'05', "
      "x'01', x'01', 'v.mp4', 'upload', 'video', 10, 5, 1000, 0)",
    );
    final points = await geoPoints(db);
    expect(points.length, 3);
    expect(points.cloud.where((c) => c == 1).length, 1);
  });

  test('geoPoints: an asset only the server holds is on the map, a trashed '
      'one is not', () async {
    await db.customStatement(
      'INSERT INTO library (id, owner_id, kind, privacy, access, state) '
      "VALUES (x'01', x'01', 'managed', 'standard', 'rw', 'online')",
    );
    Future<void> asset(int id, String extra, double lat) => db.customStatement(
      'INSERT INTO asset (id, library_id, owner_id, original_filename, '
      'source, media_kind, lat, lon, taken_utc, created_at $extra) '
      "VALUES (x'0$id', x'01', x'01', 'a$id.jpg', 'upload', 'image', $lat, 5, "
      '$id * 1000, 0 ${extra.isEmpty ? '' : ', 1'})',
    );
    await asset(2, '', 10);
    await asset(3, ', trashed_at', 11);
    final points = await geoPoints(db);
    expect(rows(points), [(2, 10.0, 5.0, 2, 1)]);
  });

  test('mapItems: the timeline items by id, but none of a folder the user '
      'keeps out of the library', () async {
    await photo(lat: 1, lon: 1);
    await photo(lat: 2, lon: 2);
    await db.customStatement(
      "INSERT INTO device_folder (volume, path) VALUES ('v', 'a/'), ('v', 'b/')",
    );
    await db.customStatement(
      "UPDATE local_asset SET volume = 'v', path = CASE source_id "
      "WHEN 'asset-1' THEN 'a/' ELSE 'b/' END, "
      "folder = (SELECT id FROM device_folder f WHERE f.volume = 'v' "
      "AND f.path = CASE source_id WHEN 'asset-1' THEN 'a/' ELSE 'b/' END)",
    );
    final ids = [Uint8List(16)..[15] = 1, Uint8List(16)..[15] = 2];
    expect(
      (await db.mapItems(ids).get()).map((i) => i.id[15]),
      unorderedEquals([1, 2]),
    );
    await excludeFolderOf(db, ids.first);
    expect((await db.mapItems(ids).get()).map((i) => i.id[15]), [2]);
  });

  test('the index answers a viewport, a time range and a lasso', () async {
    await photo(lat: 48.85, lon: 2.35, takenUtc: 86400000);
    await photo(lat: 48.86, lon: 2.36, takenUtc: 5 * 86400000);
    await photo(lat: 38.72, lon: -9.14, takenUtc: 3 * 86400000);
    final keyring = kernel.keyring();
    addTearDown(keyring.close);
    final points = await geoPoints(db);
    final index = await MapIndex.build(asAsync(keyring.call), points);

    expect(index.mapped, 3);
    expect(
      (await index.query(-180, -85, 180, 85, 3)).map((c) => c.count).toList()
        ..sort(),
      [1, 2],
    );
    final days = MapFilter(
      timeFrom: Int64(2 * 86400),
      timeTo: Int64(4 * 86400),
    );
    final lisbon = (await index.query(
      -180,
      -85,
      180,
      85,
      20,
      filter: days,
    )).single;
    expect(points.ids[lisbon.asset][15], 3);
    final lasso = MapFilter(polygon: [40, 0, 40, 5, 50, 5, 50, 0]);
    expect(
      [
        for (final i in (await index.assets(
          -180,
          -85,
          180,
          85,
          filter: lasso,
        )).assets)
          points.ids[i][15],
      ]..sort(),
      [1, 2],
    );
    expect((await index.assets(-180, -85, 180, 85, limit: 1)).total, 3);
    await index.close();
    await expectLater(
      index.query(-180, -85, 180, 85, 3),
      throwsA(isA<StateError>()),
    );
  });

  test('the build request is the protobuf message, packed without the '
      'protobuf library', () {
    GeoPoints of(List<double> lat, List<double> lon, List<int> times) =>
        GeoPoints(
          ids: [for (final _ in lat) Uint8List(1)],
          cloud: Uint8List(lat.length),
          latitudes: Float64List.fromList(lat),
          longitudes: Float64List.fromList(lon),
          times: times,
        );
    for (final points in [
      of([1.5, -2.25, 85], [180, 0, -9.14], [0, -5, 1 << 40]),
      of(
        [for (var i = 0; i < 40; i++) i / 3],
        [for (var i = 0; i < 40; i++) -i / 7],
        [for (var i = 0; i < 40; i++) i * 1000003 - 20000000],
      ),
      of([1], [2], []),
    ]) {
      expect(
        encodeMapBuild(points),
        MapIndexBuildRequest(
          latitudes: points.latitudes,
          longitudes: points.longitudes,
          times: [for (final t in points.times) Int64(t)],
        ).writeToBuffer(),
      );
    }
    expect(encodeMapBuild(of([], [], [])), isEmpty);
  });
}
