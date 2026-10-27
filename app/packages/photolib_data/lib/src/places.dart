import 'dart:typed_data';

import 'package:photolib_api/kernel.dart';
import 'package:photolib_data/src/geo.dart';
import 'package:photolib_data/src/map_index.dart'
    show AsyncKernelCall, unwrapCall;

/// A place the user named, such as a home or a holiday house: the library's
/// positions within [radiusM] metres of it are its photos (MAP-08).
class UserPlace {
  /// A place at [latitude], [longitude].
  const UserPlace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.radiusM = defaultRadiusM,
    this.sensitive = false,
  });

  /// The place stored as [json].
  factory UserPlace.fromJson(Map<String, Object?> json) => UserPlace(
    id: json['id']! as String,
    name: json['name']! as String,
    latitude: (json['lat']! as num).toDouble(),
    longitude: (json['lon']! as num).toDouble(),
    radiusM: (json['radius'] as num?)?.toInt() ?? defaultRadiusM,
    sensitive: json['sensitive'] == true,
  );

  /// The radius of a place that names none, in metres.
  static const int defaultRadiusM = 200;

  /// Its own id, unique among the user's places.
  final String id;

  /// What the user calls it.
  final String name;

  /// Degrees.
  final double latitude;

  /// Degrees.
  final double longitude;

  /// How far from the centre a photo still belongs to it, in metres.
  final int radiusM;

  /// A place that is never named, counted or listed unless the user shows
  /// sensitive places.
  final bool sensitive;

  /// The place as JSON, for the vault.
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'lat': latitude,
    'lon': longitude,
    'radius': radiusM,
    'sensitive': sensitive,
  };

  /// This place with the given fields changed.
  UserPlace copyWith({
    String? name,
    double? latitude,
    double? longitude,
    int? radiusM,
    bool? sensitive,
  }) => UserPlace(
    id: id,
    name: name ?? this.name,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    radiusM: radiusM ?? this.radiusM,
    sensitive: sensitive ?? this.sensitive,
  );
}

/// How the places of a level are ordered.
enum PlaceSort {
  /// The places with the most items first (the default).
  count,

  /// By name.
  name,
}

/// The places of a list of positions: a tree of countries, regions and cities,
/// and the user's places beside it, each with the number of items at or
/// beneath it, and the node of every position.
class Places {
  /// The places [nodes] with the node of each position in [assignment].
  Places(this.nodes, this.assignment);

  /// Parents come before their children and siblings are in the asked order.
  final List<GeoNode> nodes;

  /// For each position, the index of its deepest node, or -1 for none.
  final Int32List assignment;

  /// The indexes of the children of [parent], or of the top level for -1, in
  /// order.
  List<int> childrenOf(int parent) => [
    for (var i = 0; i < nodes.length; i++)
      if (nodes[i].parent == parent) i,
  ];

  /// The positions at [node] or beneath it, ascending.
  List<int> positionsIn(int node) {
    final inside = List<bool>.filled(nodes.length, false);
    inside[node] = true;
    for (var i = node + 1; i < nodes.length; i++) {
      final parent = nodes[i].parent;
      inside[i] = parent >= 0 && inside[parent];
    }
    return [
      for (var p = 0; p < assignment.length; p++)
        if (assignment[p] >= 0 && inside[assignment[p]]) p,
    ];
  }

  /// How many positions are in some place.
  int get placed =>
      nodes.where((n) => n.parent < 0).fold(0, (n, p) => n + p.count);
}

/// The file in `assets/geo/` that names places in [languageCode] (with the
/// script and country of the locale), or null where English is the base: the
/// language has no names pack or is English.
String? placeNamesFile(
  String languageCode, {
  String? scriptCode,
  String? countryCode,
}) {
  const known = {
    'ar', 'de', 'es', 'fr', 'he', 'hi', 'id', 'it', 'ja', 'ko', 'nl', 'pl', //
    'pt', 'ru', 'sv', 'tr', 'uk', 'vi', 'zh',
  };
  if (!known.contains(languageCode)) return null;
  final traditional =
      languageCode == 'zh' &&
      (scriptCode == 'Hant' ||
          (scriptCode == null &&
              const {'TW', 'HK', 'MO'}.contains(countryCode)));
  return 'names-${traditional ? 'zh_Hant' : languageCode}.bin';
}

/// The kernel's places pack (METHOD_GEO_*), held in the keyring whose call
/// loaded it; closed, it refuses every call. Nothing here touches a network:
/// the pack is bytes the app ships.
final class GeoIndex {
  GeoIndex._(this._call, this._handle, this.cities);

  /// Loads `places.bin` as [core] and the names of one language as [names]
  /// (none for English) through [call], a keyring's.
  static Future<GeoIndex> load(
    AsyncKernelCall call,
    Uint8List core, {
    Uint8List? names,
  }) async {
    final request = GeoLoadRequest(core: core, names: names);
    final loaded = GeoLoadResponse.fromBuffer(
      unwrapCall(
        Method.METHOD_GEO_LOAD,
        await call(Method.METHOD_GEO_LOAD.value, request.writeToBuffer()),
      ),
    );
    return GeoIndex._(call, loaded.pack, loaded.cities);
  }

  final AsyncKernelCall _call;
  final int _handle;
  var _open = true;

  /// How many cities the pack knows.
  final int cities;

  /// The places of [points], ordered by [sort]. Sensitive places of the user
  /// are named and counted only when [includeSensitive].
  Future<Places> resolve(
    GeoPoints points, {
    List<UserPlace> userPlaces = const [],
    bool includeSensitive = false,
    PlaceSort sort = PlaceSort.count,
  }) async {
    final request = GeoResolveRequest(
      pack: _handle,
      userPlaces: [
        for (final p in userPlaces)
          GeoUserPlace(
            id: p.id,
            name: p.name,
            latitude: p.latitude,
            longitude: p.longitude,
            radiusM: p.radiusM,
            sensitive: p.sensitive,
          ),
      ],
      includeSensitive: includeSensitive,
      sort: sort == PlaceSort.name
          ? GeoSort.GEO_SORT_NAME
          : GeoSort.GEO_SORT_COUNT,
    );
    // The two lists of doubles are written by hand, as the map's are.
    final body = BytesBuilder(copy: false)
      ..add(_packedDoubles(0x12, points.latitudes))
      ..add(_packedDoubles(0x1a, points.longitudes))
      ..add(request.writeToBuffer());
    final response = GeoResolveResponse.fromBuffer(
      await _use(Method.METHOD_GEO_RESOLVE, body.takeBytes()),
    );
    return Places(response.nodes, Int32List.fromList(response.assignment));
  }

  /// The IANA time zone at a position, and the country's code when it lies
  /// in one, for resolving a capture time that has none.
  Future<({String timezone, String country})> timezone(
    double latitude,
    double longitude,
  ) async {
    final response = GeoTimezoneResponse.fromBuffer(
      await _use(
        Method.METHOD_GEO_TIMEZONE,
        GeoTimezoneRequest(
          pack: _handle,
          latitude: latitude,
          longitude: longitude,
        ).writeToBuffer(),
      ),
    );
    return (timezone: response.timezone, country: response.country);
  }

  /// Frees the pack in the kernel.
  Future<void> close() async {
    if (!_open) return;
    await _use(
      Method.METHOD_GEO_DROP,
      GeoDropRequest(pack: _handle).writeToBuffer(),
    );
    _open = false;
  }

  Future<Uint8List> _use(Method method, Uint8List request) async {
    if (!_open) throw StateError('the places pack is closed');
    return unwrapCall(method, await _call(method.value, request));
  }
}

/// The field [tag] holding [values] as packed little-endian doubles.
Uint8List _packedDoubles(int tag, Float64List values) {
  if (values.isEmpty) return Uint8List(0);
  final out = BytesBuilder(copy: false)..addByte(tag);
  for (var n = values.lengthInBytes; ; n ~/= 128) {
    out.addByte(n > 127 ? n % 128 + 128 : n);
    if (n <= 127) break;
  }
  out.add(
    Uint8List.view(values.buffer, values.offsetInBytes, values.lengthInBytes),
  );
  return out.takeBytes();
}
