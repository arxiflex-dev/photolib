import 'dart:typed_data';

import 'package:photolib_api/kernel.dart';
import 'package:photolib_data/src/geo.dart';
import 'package:photolib_data/src/read_metadata.dart' show KernelCall;
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

/// A kernel call that may take a while, as an isolate's or a worker's does.
typedef AsyncKernelCall = Future<Uint8List> Function(int method, Uint8List r);

/// A keyring's synchronous [call] as an [AsyncKernelCall].
AsyncKernelCall asAsync(KernelCall call) =>
    (method, request) async => call(method, request);

/// The kernel's map index of some [GeoPoints] (METHOD_MAP_*), held in the
/// keyring whose call built it; closed, it refuses every call.
final class MapIndex {
  MapIndex._(this._call, this._handle, this.mapped);

  /// Builds an index of [points] through [call], a keyring's.
  static Future<MapIndex> build(AsyncKernelCall call, GeoPoints points) async {
    final built = MapIndexBuildResponse.fromBuffer(
      _unwrap(
        Method.METHOD_MAP_INDEX_BUILD,
        await call(Method.METHOD_MAP_INDEX_BUILD.value, encodeMapBuild(points)),
      ),
    );
    return MapIndex._(call, built.index, built.mapped);
  }

  final AsyncKernelCall _call;
  final int _handle;
  var _open = true;

  /// How many of the points are on the map (those with a valid position).
  final int mapped;

  /// The clusters of the viewport, at integer [zoom], among the items that
  /// pass [filter]; west > east crosses the antimeridian.
  Future<List<MapCluster>> query(
    double west,
    double south,
    double east,
    double north,
    int zoom, {
    MapFilter? filter,
  }) async => MapQueryResponse.fromBuffer(
    await _use(
      Method.METHOD_MAP_QUERY,
      MapQueryRequest(
        index: _handle,
        west: west,
        south: south,
        east: east,
        north: north,
        zoom: zoom,
        filter: filter,
      ),
    ),
  ).clusters;

  /// The positions (in the points) of the items in the viewport that pass
  /// [filter], at most [limit] of them (0 for all), and how many pass.
  Future<MapAssetsResponse> assets(
    double west,
    double south,
    double east,
    double north, {
    MapFilter? filter,
    int limit = 0,
  }) async => MapAssetsResponse.fromBuffer(
    await _use(
      Method.METHOD_MAP_ASSETS,
      MapAssetsRequest(
        index: _handle,
        west: west,
        south: south,
        east: east,
        north: north,
        filter: filter,
        limit: limit,
      ),
    ),
  );

  /// Frees the index in the kernel.
  Future<void> close() async {
    if (!_open) return;
    await _use(
      Method.METHOD_MAP_INDEX_DROP,
      MapIndexDropRequest(index: _handle),
    );
    _open = false;
  }

  Future<Uint8List> _use(Method method, GeneratedMessage request) async {
    if (!_open) throw StateError('the map index is closed');
    return _unwrap(method, await _call(method.value, request.writeToBuffer()));
  }
}

/// The response bytes of a kernel call's `CallResponse`, or a [StateError]
/// naming [method] and the error the kernel gave.
Uint8List unwrapCall(Method method, Uint8List bytes) => _unwrap(method, bytes);

Uint8List _unwrap(Method method, Uint8List bytes) {
  final response = CallResponse.fromBuffer(bytes);
  if (response.hasError()) {
    throw StateError('${method.name} failed: ${response.error}');
  }
  return Uint8List.fromList(response.response);
}

/// The encoded `MapIndexBuildRequest` of [points]: the bytes of the message,
/// written by hand because a million doubles through the protobuf library cost
/// frames (little-endian hosts only, as every target is).
Uint8List encodeMapBuild(GeoPoints points) {
  if (points.length == 0) return Uint8List(0);
  final out = BytesBuilder(copy: false);
  void field(int tag, Uint8List bytes) {
    out.addByte(tag);
    for (var n = bytes.length; ; n ~/= 128) {
      out.addByte(n > 127 ? n % 128 + 128 : n);
      if (n <= 127) break;
    }
    out.add(bytes);
  }

  Uint8List raw(Float64List d) =>
      Uint8List.view(d.buffer, d.offsetInBytes, d.lengthInBytes);
  final varints = BytesBuilder(copy: false);
  for (final t in points.times) {
    // Zigzag without bit operations, which JavaScript does in 32 bits.
    for (var z = t >= 0 ? t * 2 : -t * 2 - 1; ; z ~/= 128) {
      varints.addByte(z > 127 ? z % 128 + 128 : z);
      if (z <= 127) break;
    }
  }
  field(0x0a, raw(points.latitudes));
  field(0x12, raw(points.longitudes));
  if (points.times.isNotEmpty) field(0x1a, varints.takeBytes());
  return out.takeBytes();
}
