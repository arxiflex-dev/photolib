@TestOn('vm')
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:photolib_api/kernel.dart' show GeoLevel;
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_kernel/photolib_kernel.dart';
import 'package:test/test.dart';

import 'kernel.dart';

Uint8List pack(String name) => File('../../assets/geo/$name').readAsBytesSync();

GeoPoints points(List<(double, double)> p) => GeoPoints(
  ids: [for (var i = 0; i < p.length; i++) Uint8List(1)..[0] = i],
  cloud: Uint8List(p.length),
  latitudes: Float64List.fromList([for (final (lat, _) in p) lat]),
  longitudes: Float64List.fromList([for (final (_, lon) in p) lon]),
  times: List.filled(p.length, 0),
);

const paris = (48.8566, 2.3522);
const lyon = (45.764, 4.8357);
const berlin = (52.52, 13.405);

void main() {
  final kernel = testKernel();
  late KernelKeyring keyring;
  late AsyncKernelCall call;
  setUp(() {
    keyring = kernel.keyring();
    call = asAsync(keyring.call);
  });
  tearDown(() => keyring.close());

  test('positions become a tree of countries, regions and cities with '
      'counts, most items first', () async {
    final geo = await GeoIndex.load(call, pack('places.bin'));
    final places = await geo.resolve(
      points([paris, paris, paris, lyon, berlin, (0, -30)]),
    );
    expect(places.assignment.last, -1, reason: 'the open sea is no place');
    final top = places.childrenOf(-1);
    expect([for (final i in top) places.nodes[i].name], ['France', 'Germany']);
    expect([for (final i in top) places.nodes[i].count], [4, 1]);
    final regions = places.childrenOf(top.first);
    expect(places.nodes[regions.first].name, 'Île-de-France');
    final cities = places.childrenOf(regions.first);
    expect(places.nodes[cities.single].level, GeoLevel.GEO_LEVEL_CITY);
    expect(places.nodes[cities.single].name, 'Paris');
    expect(places.placed, 5);
  });

  test('alphabetical order is an option', () async {
    final geo = await GeoIndex.load(call, pack('places.bin'));
    final places = await geo.resolve(
      points([paris, lyon, lyon, berlin]),
      sort: PlaceSort.name,
    );
    final france = places.childrenOf(-1).first;
    final cities = [
      for (final i in places.childrenOf(france))
        for (final c in places.childrenOf(i)) places.nodes[c].name,
    ];
    expect(cities, [...cities]..sort());
  });

  test('positionsIn lists the items beneath a place, ascending', () async {
    final geo = await GeoIndex.load(call, pack('places.bin'));
    final places = await geo.resolve(points([berlin, paris, lyon, paris]));
    final france = places.childrenOf(-1).first;
    expect(places.nodes[france].name, 'France');
    expect(places.positionsIn(france), [1, 2, 3]);
    final germany = places.childrenOf(-1).last;
    expect(places.positionsIn(germany), [0]);
  });

  test('names follow the names pack, the codes do not', () async {
    final english = await GeoIndex.load(call, pack('places.bin'));
    final german = await GeoIndex.load(
      call,
      pack('places.bin'),
      names: pack('names-de.bin'),
    );
    final here = points([(48.1351, 11.582)]);
    final en = await english.resolve(here);
    final de = await german.resolve(here);
    expect(
      [for (final n in en.nodes) n.name],
      ['Germany', 'Bavaria', 'Munich'],
    );
    expect(
      [for (final n in de.nodes) n.name],
      ['Deutschland', 'Bayern', 'München'],
    );
    expect(
      [for (final n in de.nodes) n.code],
      [for (final n in en.nodes) n.code],
    );
  });

  test('user places count their photos; a sensitive one only on ask', () async {
    final geo = await GeoIndex.load(call, pack('places.bin'));
    const home = UserPlace(
      id: 'h',
      name: 'Home',
      latitude: 45.764,
      longitude: 4.8357,
      sensitive: true,
    );
    const lake = UserPlace(
      id: 'l',
      name: 'Lake house',
      latitude: 46,
      longitude: 6.5,
    );
    final all = points([lyon, lyon, (46, 6.5), paris]);
    final hidden = await geo.resolve(all, userPlaces: [home, lake]);
    expect([for (final n in hidden.nodes) n.name], isNot(contains('Home')));
    expect(hidden.assignment.sublist(0, 2), [-1, -1]);
    expect(hidden.nodes.firstWhere((n) => n.name == 'Lake house').count, 1);
    final shown = await geo.resolve(
      all,
      userPlaces: [home, lake],
      includeSensitive: true,
    );
    final node = shown.nodes.firstWhere((n) => n.name == 'Home');
    expect(
      (node.count, node.sensitive, node.level),
      (2, true, GeoLevel.GEO_LEVEL_USER),
    );
  });

  test('the time zone at a position, and at sea', () async {
    final geo = await GeoIndex.load(call, pack('places.bin'));
    expect(await geo.timezone(35.68, 139.69), (
      timezone: 'Asia/Tokyo',
      country: 'JP',
    ));
    expect(await geo.timezone(0, -30), (timezone: 'Etc/GMT+2', country: ''));
  });

  test('a damaged pack and a closed index are refused', () async {
    await expectLater(
      GeoIndex.load(call, Uint8List.fromList([1, 2, 3])),
      throwsA(isA<StateError>()),
    );
    final geo = await GeoIndex.load(call, pack('places.bin'));
    await geo.close();
    await expectLater(geo.resolve(points([paris])), throwsStateError);
    await geo.close(); // closing twice is harmless
  });

  test('one million positions resolve to exact counts', () async {
    final geo = await GeoIndex.load(call, pack('places.bin'));
    const cities = [paris, lyon, berlin];
    final many = points([
      for (var i = 0; i < 1000000; i++)
        (
          cities[i % 3].$1 + (i % 7) * 0.001,
          cities[i % 3].$2 + (i % 5) * 0.001,
        ),
    ]);
    final places = await geo.resolve(many);
    expect(places.placed, 1000000);
  });

  test('placeNamesFile picks the names pack of a locale', () {
    expect(placeNamesFile('en'), isNull);
    expect(placeNamesFile('xx'), isNull);
    expect(placeNamesFile('de'), 'names-de.bin');
    expect(placeNamesFile('zh'), 'names-zh.bin');
    expect(placeNamesFile('zh', scriptCode: 'Hant'), 'names-zh_Hant.bin');
    expect(placeNamesFile('zh', countryCode: 'TW'), 'names-zh_Hant.bin');
    expect(
      placeNamesFile('zh', scriptCode: 'Hans', countryCode: 'TW'),
      'names-zh.bin',
    );
  });

  test('a user place is stored as JSON and back', () {
    const place = UserPlace(
      id: 'a',
      name: 'Office',
      latitude: 1.5,
      longitude: -2.5,
      radiusM: 350,
      sensitive: true,
    );
    final back = UserPlace.fromJson(place.toJson());
    expect(back.toJson(), place.toJson());
    expect(
      UserPlace.fromJson({'id': 'b', 'name': 'N', 'lat': 1, 'lon': 2}).radiusM,
      UserPlace.defaultRadiusM,
    );
  });
}
