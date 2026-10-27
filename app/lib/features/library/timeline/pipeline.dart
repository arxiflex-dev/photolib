import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:photolib/core/logging.dart';
import 'package:photolib/features/library/timeline/availability.dart';
import 'package:photolib/features/library/timeline/browser_thumbnails_native.dart'
    if (dart.library.js_interop) 'package:photolib/features/library/timeline/browser_thumbnails.dart'
    show browserImage;
import 'package:photolib/features/library/timeline/thumb_hash.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/viewer/sphere.dart';
import 'package:photolib_api/photolib_api.dart' show ServerError, Unreachable;
import 'package:photolib_data/photolib_data.dart';

export 'package:photolib/features/library/timeline/availability.dart';

const _log = Logger('photolib.thumbnails');

/// A file of a server's media as fetched: 200 with its bytes or 304, and its
/// ETag.
typedef MediaFile = ({int status, String? etag, Uint8List bytes});

/// Fetches `media/<asset>/<role>` of the signed-in server with these headers,
/// through the app's network stack (design 10 §9), as photolib_api's
/// `Server.get` does: [ServerError] `not_found` for a 404, [Unreachable] for
/// no answer.
typedef MediaFetch = Future<MediaFile> Function(
  String path,
  Map<String, String> headers,
);

String _hex(Uint8List bytes) =>
    [for (final b in bytes) b.toRadixString(16).padLeft(2, '0')].join();

/// What the pipeline needs of a media item; items with the same [key] are
/// equal.
@immutable
class ThumbnailItem {
  /// An item by its [key] and the [uri] of its original.
  const new(
    this.key,
    this.uri, {
    this.id,
    this.video = false,
    this.hash,
    this.folder = 0,
    this.excluded = false,
    this.animated = false,
    this.taken,
    this.sphere = false,
    this.renditions,
    this.marks = const {},
    this.asset,
    this.backup = Availability.notBackedUp,
    this.bytes = 0,
  });

  /// A tile of the replica's timeline: a device or folder item, of a folder
  /// the user keeps out of the library if [excluded], or an asset only the
  /// server has, whose tiles are its renditions (T5).
  factory local(TimelineItemData item, {bool excluded = false}) {
    final hex = _hex(item.id);
    final server = item.source == 'server';
    final extension = item.path?.split('.').last.toLowerCase();
    final video =
        (item.mime ?? '').startsWith('video/') ||
        videoExtensions.contains(extension);
    return ThumbnailItem(
      '$hex-${item.size.toRadixString(36)}-${item.mtime.toRadixString(36)}',
      switch (item.source) {
        'server' => Uri(path: 'media/${uuidOf(item.id)}'),
        'mediastore' => Uri.parse(
          'content://media/${item.volume}/${video ? 'video' : 'images'}/media/${item.sourceId}',
        ),
        'photokit' => Uri(scheme: 'ph', path: item.sourceId),
        // A browser's folder is a directory handle kept by its name.
        _ when kIsWeb => Uri(
          scheme: 'folder',
          pathSegments: [item.volume, ...?item.path?.split('/')],
        ),
        _ => Uri.file('${item.volume}/${item.path}'),
      },
      id: server ? null : item.id,
      video: video,
      hash: item.thumbhash,
      folder: item.folder,
      excluded: excluded,
      animated: switch (item.facets) {
        final facets? => facets.split(',').contains('animated'),
        null => item.mime == 'image/gif' || extension == 'gif',
      },
      taken: DateTime.fromMillisecondsSinceEpoch(item.sortKey, isUtc: true),
      sphere: Sphere.projections.contains(item.projection),
      marks: {
        if (item.favorite == 1) Mark.favourite,
        if (item.hidden == 1) Mark.hidden,
        if (item.archived == 1) Mark.archived,
      },
      renditions: server
          ? {
              if (item.thumbS case final h?) 'thumb_s': _hex(h),
              if (item.thumbM case final h?) 'thumb_m': _hex(h),
            }
          : null,
      asset: item.assetId,
      backup: Availability.values.firstWhere((b) => b.sql == item.backup),
      bytes: item.size,
    );
  }

  /// An asset of a server library (T5) by its [id] and current [version], as
  /// the replica has them: its ThumbHash, and the content hashes of its
  /// `asset_file`s by role, whose `thumb_s` and `thumb_m` its tiles are.
  factory remote(
    Uint8List id, {
    Uint8List? version,
    bool video = false,
    Uint8List? hash,
    Map<String, Uint8List> renditions = const {},
  }) {
    return ThumbnailItem(
      '${_hex(id)}-${version == null ? 0 : _hex(version)}',
      Uri(path: 'media/${uuidOf(id)}'),
      video: video,
      hash: hash,
      renditions: {
        for (final MapEntry(:key, :value) in renditions.entries)
          key: _hex(value),
      },
    );
  }

  /// The item and its content version, safe in a file name: an edit keeps
  /// the item but changes its key (docs/10-client-app.md §3.4).
  final String key;

  /// The original: a file, a MediaStore item, a PhotoKit asset by local
  /// identifier, a file in a browser's folder, or a server's asset by its
  /// path under the server's media.
  final Uri uri;

  /// The `local_asset` id of a device item.
  final Uint8List? id;

  /// A video, or a Live Photo's motion file: its thumbnail is a poster frame.
  final bool video;

  /// Its ThumbHash in the device index, once the warm-up kept one; a server
  /// item's from sync.
  final Uint8List? hash;

  /// Its device folder, 0 for none, and whether the user keeps that out of
  /// the library, which shows it for now (ADR-0210).
  final int folder;

  /// See [folder].
  final bool excluded;

  /// An animated image, as extraction or PhotoKit says, a GIF until one
  /// has: its cell has a badge.
  final bool animated;

  /// When it was taken, as the timeline sorts it: its capture time, else its
  /// file's.
  final DateTime? taken;

  /// A photo sphere or 360° video, which the viewer projects.
  final bool sphere;

  /// A server item's renditions the replica knows, their hashes in hex by
  /// role; null for an item on this device.
  final Map<String, String>? renditions;

  /// What its cell marks it as; no part of its [key], so that marking it
  /// keeps its tiles.
  final Set<Mark> marks;

  /// The asset the item is a copy of, or the asset itself, once the server has
  /// it.
  final Uint8List? asset;

  /// Where its photo is.
  final Availability backup;

  /// The size of its original: the device's copy, else the server's.
  final int bytes;

  /// [hash], parsed.
  ThumbHash? get thumbHash => switch (hash) {
    final hash? => ThumbHash.tryParse(hash),
    null => null,
  };

  /// The file, or the URI of anything else.
  @override
  String toString() => uri.isScheme('file') ? uri.toFilePath() : '$uri';

  @override
  bool operator ==(Object other) => other is ThumbnailItem && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// The user's marks on an item that its cells show (ADR-0245).
enum Mark {
  /// Among the favourites.
  favourite,

  /// Out of every view.
  hidden,

  /// Out of the timeline.
  archived,
}

/// A thumbnail as a platform hands it over: encoded, with a video's
/// [duration] when known; pixels in the platform's order, RGBA or BGRA
/// (ADR-0040); or an image a browser decoded, which nothing caches.
class Pixels {
  /// A JPEG or PNG.
  const new encoded(this.bytes, {this.duration})
    : width = 0,
      height = 0,
      format = ui.PixelFormat.rgba8888,
      image = null;

  /// RGBA pixels.
  const new rgba(this.bytes, this.width, this.height)
    : format = ui.PixelFormat.rgba8888,
      image = null,
      duration = null;

  /// BGRA pixels.
  const new bgra(this.bytes, this.width, this.height)
    : format = ui.PixelFormat.bgra8888,
      image = null,
      duration = null;

  /// An image the browser decoded.
  new decoded(ui.Image this.image)
    : bytes = Uint8List(0),
      width = 0,
      height = 0,
      format = ui.PixelFormat.rgba8888,
      duration = null;

  /// The encoded image or its pixels; empty when decoded.
  final Uint8List bytes;

  /// The size of pixels; 0 when encoded or decoded.
  final int width;

  /// See [width].
  final int height;

  /// The order of pixels' channels.
  final ui.PixelFormat format;

  /// What the browser decoded.
  final ui.Image? image;

  /// A video's duration, with its poster.
  final Duration? duration;
}

/// A source of thumbnails, named in the cause of an item none has: the
/// thumbnail of an item at a tier; null, or [Declined] saying why, when the
/// item is not its kind; [NoThumbnail] when it refuses the format.
class Thumbnailer {
  /// A source by its [name] and how it loads.
  const new(this.name, this._load);

  /// Its name in a cause.
  final String name;
  final Future<Pixels?> Function(
    ThumbnailItem item,
    int tier,
    Future<void> cancelled,
  )
  _load;

  /// The thumbnail of [item] at [tier], until [cancelled].
  Future<Pixels?> call(ThumbnailItem item, int tier, Future<void> cancelled) =>
      _load(item, tier, cancelled);
}

/// Why a [Thumbnailer] declines an item, as `no scheme` or `video`.
class Declined implements Exception {
  /// A refusal by its [reason].
  const new(this.reason);

  /// Why, in a few words.
  final String reason;

  @override
  String toString() => reason;
}

/// The tiers of docs/10-client-app.md §3.4 below memory: the disk cache (T2),
/// meanwhile a smaller tier there or the file's [embedded] preview (T2.5),
/// the platform's thumbnailers (T3), then the [decoders] of the originals at
/// the tier (T4) in turn, each taking what the one before refused, whose
/// tiles the disk cache keeps; last, with [originals], a file decoded with
/// Flutter's codecs, kept nowhere. Tiles reach the disk cache as the decoders
/// hand them over, never read back from an image, and are at most the
/// source's size with their short side at the tier. An item none has fails
/// with what each said, in order. A server item's tile is the server's
/// rendition (T5) from [media] instead, which the disk cache keeps too.
class ThumbnailPipeline {
  /// The tiers of this platform; none by default.
  new({
    this.cache,
    this.thumbnailers = const [],
    this.decoders = const [],
    this.originals = false,
    this.embedded,
    this.thumbHash,
    this.workers = 1,
    this.media,
  });

  /// The disk tier (T2).
  final TileCache? cache;

  /// The signed-in server's media (T5).
  final MediaFetch? media;

  /// The JPEG a file holds as a picture of itself, if any, or its largest.
  final Future<Uint8List?> Function(ThumbnailItem item, {bool largest})?
  embedded;

  /// The ThumbHash of an encoded tile, which [warm] returns.
  final Future<Uint8List> Function(Uint8List tile)? thumbHash;

  /// How many tiles [warm] makes at once: on desktops the cores but one
  /// (docs/10-client-app.md §3.4); the timeline's own decodes are fewer, so
  /// that scrolling keeps its frames.
  final int workers;

  /// The platform's thumbnailers (T3), whose thumbnails it keeps.
  final List<Thumbnailer> thumbnailers;

  /// The decoders of the originals (T4).
  final List<Thumbnailer> decoders;

  /// Whether Flutter's codecs decode a file last.
  final bool originals;

  Future<void> _writes = Future.value();
  var _backlog = 0;
  final _durations = <String, Duration>{};

  /// Complete once the decoded tiles are in the disk cache.
  Future<void> get idle => _writes;

  /// The duration of a video whose poster was loaded or refused.
  Duration? duration(ThumbnailItem item) => _durations[item.key];

  /// Whether the disk cache has the tile of [item] at [tier].
  bool cached(ThumbnailItem item, int tier) =>
      cache?.contains('${item.key}-$tier') ?? false;

  /// Drops the tiles of [item], whose file is deleted for good (docs/10
  /// §5.4).
  Future<void> forget(ThumbnailItem item) async {
    for (var tier = 128; tier <= 1024; tier *= 2) {
      await cache?.remove('${item.key}-$tier');
    }
  }

  /// The tile of [item] at [tier], timing each stage in [tile]; until it
  /// arrives, a smaller tier the disk cache has, else the embedded preview,
  /// goes to [Tile.show].
  Future<ui.Image> load(ThumbnailItem item, int tier, Tile tile) async {
    if (item.renditions case final renditions?) {
      return await _remote(item, renditions, tier, tile);
    }
    final key = '${item.key}-$tier';
    final fields = {'file': '$item', 'tier': tier};
    if (cache case final cache?) {
      final entry = cache.contains(key)
          ? await tile.time('cache', () => cache.get(key))
          : null;
      _log.debug(entry == null ? 'cache miss' : 'cache hit', fields: fields);
      if (entry != null) {
        try {
          final (bytes, duration, _) = _unwrap(entry);
          if (duration != null) _durations[item.key] = duration;
          return await tile.time(
            'upload',
            () => _decode(Pixels.encoded(bytes), tier),
          );
        } on Exception catch (e) {
          _log.warning('cached tile undecodable', fields: fields, error: e);
          await cache.remove(key);
        }
      }
    }
    if (tile.show != null) unawaited(_standIn(item, tier, tile));
    final misses = <(String, Object?)>[];
    for (final (i, source) in [...thumbnailers, ...decoders].indexed) {
      if (tile.isCancelled) break;
      final took = Stopwatch()..start();
      final decoder = {...fields, 'decoder': source.name};
      final pixels = await tile.time(
        'decode',
        () => _try(source, item, tier, tile.cancelled, misses),
      );
      if (pixels == null) {
        if (misses.last.$2 case final Object e when e is! Declined) {
          _log.debug(
            e is NoThumbnail ? 'refused' : 'decoder failed',
            fields: {...decoder, 'ms': took.elapsedMilliseconds, 'cause': '$e'},
          );
        }
        continue;
      }
      try {
        final image = await tile.time('upload', () => _decode(pixels, tier));
        final kept = i >= thumbnailers.length && _keep(key, pixels);
        _log.debug(
          'decoded',
          fields: {
            ...decoder,
            'ms': took.elapsedMilliseconds,
            'size': '${image.width}x${image.height}',
            'cached': kept,
          },
        );
        return image;
      } on Exception catch (e) {
        _log.debug('undecodable', fields: {...decoder, 'cause': '$e'});
        misses.add((source.name, e));
      }
    }
    if (!tile.isCancelled && originals) {
      if (await _original(item, tier, tile, misses) case final image?) {
        _log.debug('decoded', fields: {...fields, 'decoder': 'flutter'});
        return image;
      }
    }
    throw _missed(item, misses, cancelled: tile.isCancelled);
  }

  // The file decoded with Flutter's codecs, else null and why in [misses].
  Future<ui.Image?> _original(
    ThumbnailItem item,
    int tier,
    Tile tile,
    List<(String, Object?)> misses,
  ) async {
    if (item.video || !item.uri.isScheme('file')) {
      misses.add(('flutter', Declined(item.video ? 'video' : 'no scheme')));
      return null;
    }
    try {
      return await tile.time(
        'decode',
        () async => await _instantiate(
          await ui.ImmutableBuffer.fromFilePath(item.uri.toFilePath()),
          tier,
        ),
      );
    } on Exception catch (e) {
      misses.add(('flutter', e));
      return null;
    }
  }

  // T5: the server's thumb_s or thumb_m for the tier, kept in the disk cache
  // with its ETag. One whose ETag is the hash the replica has is current; any
  // other is revalidated, and a 304 keeps it.
  Future<ui.Image> _remote(
    ThumbnailItem item,
    Map<String, String> renditions,
    int tier,
    Tile tile,
  ) async {
    final key = '${item.key}-$tier';
    final role = tier <= 256 ? 'thumb_s' : 'thumb_m';
    final hash = renditions[role];
    var (cached, _, etag) = await _read(key, tile);
    if (cached != null && etag == '"$hash"') {
      try {
        return await _upload(cached, tier, tile);
      } on Exception {
        await cache?.remove(key);
        cached = null;
      }
    }
    if (cached == null && tile.show != null) {
      unawaited(_standIn(item, tier, tile));
    }
    final file = await tile.time(
      'fetch',
      () => _fetch(
        '${item.uri.path}/$role${hash == null ? '' : '?h=$hash'}',
        cached == null ? null : etag,
      ),
    );
    final fetched = file.status != 304 || cached == null;
    final bytes = fetched ? file.bytes : cached;
    try {
      final image = await _upload(bytes, tier, tile);
      if (fetched) _queue(key, () async => _tagged(bytes, file.etag));
      return image;
    } on Exception {
      if (!fetched) await cache?.remove(key);
      rethrow;
    }
  }

  // The entry under [key] in the disk cache, if any: its tile, and the
  // duration or ETag before it.
  Future<(Uint8List?, Duration?, String?)> _read(String key, Tile tile) async {
    if (cache case final cache? when cache.contains(key)) {
      if (await tile.time('cache', () => cache.get(key)) case final entry?) {
        return _unwrap(entry);
      }
    }
    return (null, null, null);
  }

  // The server's media at [path], revalidating [etag]: Pending while it is
  // not rendered yet (404), the server is out of reach or nobody signed in.
  Future<MediaFile> _fetch(String path, String? etag) async {
    final media = this.media ?? (throw const Pending('signed out'));
    try {
      return await media(path, {'if-none-match': ?etag});
    } on ServerError catch (e) {
      if (e.code != 'not_found') rethrow;
      throw const Pending('not rendered yet');
    } on Unreachable catch (e) {
      throw Pending('$e');
    }
  }

  static Future<ui.Image> _upload(Uint8List bytes, int tier, Tile tile) =>
      tile.time('upload', () => _decode(Pixels.encoded(bytes), tier));

  Future<void> _standIn(ThumbnailItem item, int tier, Tile tile) async {
    for (var t = tier ~/ 2; t >= 128; t ~/= 2) {
      if (await cache?.get('${item.key}-$t') case final entry?) {
        try {
          return tile.show?.call(
            await _decode(Pixels.encoded(_unwrap(entry).$1), t),
            t,
          );
        } on Exception {
          // The next tier down.
        }
      }
    }
    if (embedded case final embedded? when item.renditions == null) {
      try {
        final image = await tile.time('embedded', () async {
          final bytes = await embedded(item);
          return bytes == null
              ? null
              : await _decode(Pixels.encoded(bytes), tier);
        });
        if (image != null) tile.show?.call(image, 0);
      } on Exception {
        // No preview, then.
      }
    }
  }

  /// [item]'s largest embedded preview at [tier], which the viewer shows of
  /// a RAW at once (docs/10-client-app.md §4.1); null when it has none.
  Future<ui.Image?> preview(ThumbnailItem item, int tier) async {
    final bytes = await embedded?.call(item, largest: true);
    return bytes == null ? null : await _decode(Pixels.encoded(bytes), tier);
  }

  /// Puts the tile of [item] at [tier] in the disk cache, made by the
  /// decoders unless it is there, and returns its ThumbHash if the item has
  /// none yet; [NoThumbnail] when no decoder made it.
  Future<Uint8List?> warm(ThumbnailItem item, int tier) async {
    final key = '${item.key}-$tier';
    final cached = cache?.contains(key) ?? false;
    if (cached && item.hash != null) return null;
    final entry = cached ? await cache?.get(key) : await _make(item, tier);
    if (entry == null) return null;
    if (!cached) await cache?.put(key, entry);
    final tile = _unwrap(entry).$1;
    return item.hash == null ? await thumbHash?.call(tile) : null;
  }

  Future<Uint8List> _make(ThumbnailItem item, int tier) async {
    final misses = <(String, Object?)>[];
    for (final decoder in decoders) {
      final pixels = await _try(decoder, item, tier, _never, misses);
      if (pixels == null) continue;
      if (pixels.image == null) return await _entry(pixels);
      misses.add((decoder.name, const Declined('decoded, not encoded')));
    }
    throw _missed(item, misses);
  }

  static final Future<void> _never = Completer<void>().future;

  // What [source] hands over, else null and, in [misses], its name and its
  // answer: null when it declined without saying why, or what it threw.
  Future<Pixels?> _try(
    Thumbnailer source,
    ThumbnailItem item,
    int tier,
    Future<void> cancelled,
    List<(String, Object?)> misses,
  ) async {
    try {
      final pixels = await source(item, tier, cancelled);
      if (pixels == null) misses.add((source.name, null));
      if (pixels?.duration case final duration?) {
        _durations[item.key] = duration;
      }
      return pixels;
    } on Object catch (e) {
      if (e case NoThumbnail(:final duration?)) _durations[item.key] = duration;
      misses.add((source.name, e));
      return null;
    }
  }

  NoThumbnail _missed(
    ThumbnailItem item,
    List<(String, Object?)> misses, {
    bool cancelled = false,
  }) => NoThumbnail(
    video: item.video,
    unplayable: misses
        .map((m) => m.$2)
        .whereType<NoThumbnail>()
        .any((e) => e.unplayable),
    duration: _durations[item.key],
    noHevc: noHevcDecoder(item.uri, video: item.video),
    cause: [
      for (final (name, answer) in misses)
        '$name: ${switch (answer) {
          null => 'declined',
          Declined(:final reason) => reason,
          NoThumbnail(:final cause) => 'refused $cause',
          _ => 'threw $answer',
        }}',
      if (cancelled) 'cancelled',
      if (misses.isEmpty && !cancelled) 'no decoder',
    ].join('; '),
  );

  // Encoding waits its turn, so a fling past uncached items drops some.
  bool _keep(String key, Pixels pixels) =>
      pixels.image == null &&
      _backlog < 16 &&
      _queue(key, () => _entry(pixels));

  bool _queue(String key, Future<Uint8List> Function() entry) {
    if (cache case final cache?) {
      _backlog++;
      _writes = _writes
          .then((_) async => await cache.put(key, await entry()))
          .catchError((Object e) => _log.warning('tile not cached', error: e))
          .whenComplete(() => _backlog--);
      return true;
    }
    return false;
  }

  // A tile, after a video's duration: PLD1 and its milliseconds.
  static Future<Uint8List> _entry(Pixels pixels) async {
    final tile = pixels.width == 0
        ? pixels.bytes
        : await Isolate.run(
            () => _encode(pixels.bytes, pixels.width, pixels.height),
          );
    final ms = pixels.duration?.inMilliseconds;
    if (ms == null) return tile;
    final entry = Uint8List(8 + tile.length)
      ..setAll(0, _withDuration)
      ..setAll(8, tile);
    ByteData.sublistView(entry).setUint32(4, ms, Endian.little);
    return entry;
  }

  // A rendition, after its ETag: PLE1, the ETag's length and its bytes.
  static Uint8List _tagged(Uint8List tile, String? etag) {
    if (etag == null || etag.length > 255) return tile;
    return Uint8List.fromList([
      ..._withETag,
      etag.length,
      ...etag.codeUnits,
      ...tile,
    ]);
  }

  // The tile of an entry, and the duration or ETag before it.
  static (Uint8List, Duration?, String?) _unwrap(Uint8List entry) {
    if (entry.length >= 8 && listEquals(entry.sublist(0, 4), _withDuration)) {
      final ms = ByteData.sublistView(entry).getUint32(4, Endian.little);
      return (
        Uint8List.sublistView(entry, 8),
        Duration(milliseconds: ms),
        null,
      );
    }
    if (entry.length >= 5 &&
        listEquals(entry.sublist(0, 4), _withETag) &&
        entry.length >= 5 + entry[4]) {
      final end = 5 + entry[4];
      return (
        Uint8List.sublistView(entry, end),
        null,
        String.fromCharCodes(entry, 5, end),
      );
    }
    return (entry, null, null);
  }

  static const _withDuration = [0x50, 0x4c, 0x44, 0x31];
  static const _withETag = [0x50, 0x4c, 0x45, 0x31];

  static Future<ui.Image> _decode(Pixels pixels, int tier) async =>
      pixels.image ??
      await (pixels.width == 0 ? browserImage(pixels.bytes, tier) : null) ??
      await _instantiate(
        await ui.ImmutableBuffer.fromUint8List(pixels.bytes),
        tier,
        width: pixels.width,
        height: pixels.height,
        format: pixels.format,
      );

  // Encoded bytes, or [format] pixels of a [width] × [height] image.
  static Future<ui.Image> _instantiate(
    ui.ImmutableBuffer buffer,
    int tier, {
    int width = 0,
    int height = 0,
    ui.PixelFormat format = ui.PixelFormat.rgba8888,
  }) async {
    // Chromium's descriptors know no size; its encoded tiles are at the tier.
    if (kIsWeb && width == 0) {
      final codec = await ui.instantiateImageCodecFromBuffer(buffer);
      final frame = await codec.getNextFrame();
      codec.dispose();
      return frame.image;
    }
    ui.ImageDescriptor? descriptor;
    try {
      descriptor = width > 0
          ? ui.ImageDescriptor.raw(
              buffer,
              width: width,
              height: height,
              pixelFormat: format,
            )
          : await ui.ImageDescriptor.encoded(buffer);
      final (w, h) = (descriptor.width, descriptor.height);
      final scale = min<double>(1, tier / min(w, h));
      final codec = await descriptor.instantiateCodec(
        targetWidth: max(1, (w * scale).round()),
        targetHeight: max(1, (h * scale).round()),
      );
      final frame = await codec.getNextFrame();
      codec.dispose();
      return frame.image;
    } finally {
      descriptor?.dispose();
      buffer.dispose();
    }
  }

  // JPEG, or PNG to keep transparency. A platform channel's bytes are a view
  // into its message, so the image starts at their offset, not the buffer's.
  static Uint8List _encode(Uint8List rgba, int w, int h) {
    final image = img.Image.fromBytes(
      width: w,
      height: h,
      bytes: rgba.buffer,
      bytesOffset: rgba.offsetInBytes,
      numChannels: 4,
    );
    for (var i = 3; i < rgba.length; i += 4) {
      if (rgba[i] != 255) return img.encodePng(image);
    }
    return img.encodeJpg(image, quality: 85);
  }
}
