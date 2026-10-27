import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import '../../../core/logging.dart';
import '../../../core/memory.dart';

const _log = Logger('photolib.thumbnails');

/// One thumbnail on its way to the screen (docs/10 §3.4): whether a cell
/// still wants it, where a stand-in goes until it arrives, and how long each
/// stage took, for the debug log.
class Tile {
  Tile([Completer<void>? cancel]) : _cancel = cancel ?? Completer();

  final Completer<void> _cancel;

  Future<void> get cancelled => _cancel.future;
  bool get isCancelled => _cancel.isCompleted;

  /// Milliseconds per stage, in the order they ran: `queue`, `cache`,
  /// `embedded`, `decode` and `upload`.
  final stages = <String, double>{};

  /// Shows a smaller image of the item until its own: one at that tier, or
  /// at 0 the file's embedded preview. Null when a stand-in is shown already.
  void Function(ui.Image image, int tier)? show;

  /// Runs [stage], adding its time to [stages].
  Future<T> time<T>(String stage, Future<T> Function() run) async {
    final watch = Stopwatch()..start();
    try {
      return await run();
    } finally {
      stages[stage] = (stages[stage] ?? 0) + watch.elapsedMicroseconds / 1000;
    }
  }
}

/// Decodes the thumbnail of an item at a tier's size, off the UI thread
/// (ADR-0040).
typedef ThumbnailSource = Future<ui.Image> Function(
  Object item,
  int tier,
  Tile tile,
);

/// Why an item has no thumbnail: its format is refused, or it is a video
/// with no poster frame, for the [cause]. Its cell shows a mark.
class NoThumbnail implements Exception {
  const NoThumbnail({
    this.video = false,
    required this.cause,
    this.unplayable = false,
    this.duration,
    this.noHevc = false,
  });

  final bool video;
  final String cause;

  /// A video the platform cannot play, and its duration when known.
  final bool unplayable;
  final Duration? duration;

  /// A HEIC no decoder took on a desktop with no HEVC decoder to install
  /// (ADR-0214): its mark says to connect a server or open it on a Mac.
  final bool noHevc;

  @override
  String toString() => 'NoThumbnail(video: $video, cause: $cause)';
}

/// Whether a refused file at [uri] is a HEIC on Windows or Linux outside the
/// browser: no codec ships there and none is to be installed (ADR-0214), so
/// its cell names connected mode or a Mac. The web says its own reason.
bool noHevcDecoder(Uri uri, {required bool video}) =>
    !kIsWeb &&
    !video &&
    const {
      'heic',
      'heif',
      'hif',
    }.contains(uri.path.split('.').last.toLowerCase()) &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux);

/// The source has no thumbnail of an item yet but will, for the [cause]: a
/// rendition the server still makes, or a server out of reach. Its cells keep
/// their ThumbHash, unmarked, and it is asked for again after a backoff.
class Pending implements Exception {
  /// Not there yet, for [cause].
  const new(this.cause);

  /// Why, in a few words.
  final String cause;

  @override
  String toString() => 'Pending($cause)';
}

/// The decode size for a cell of [pixels] physical pixels: a power of two from
/// 128 to 1024, so a density change finds the other tier in memory (docs/10
/// §3.2).
int tierFor(double pixels) {
  var tier = 128;
  while (tier < pixels && tier < 1024) {
    tier *= 2;
  }
  return tier;
}

/// T1's size from the device's RAM (docs/10 §3.4): a 32nd of it, from 128 MiB
/// up to 256 MiB on phones and 512 MiB elsewhere.
int memoryCacheBytes(int? ram, {required bool phone}) =>
    ((ram ?? 0) ~/ 32).clamp(128 << 20, (phone ? 256 : 512) << 20);

typedef _Key = (Object, int);

/// A waiting request in the window, how far from the visible cells.
typedef _Wanted = (int, _Request, _Key);

/// A thumbnail's cells, where the first of them is, how recently one asked,
/// since when it waits, whether the source has it [Thumbnails.cached] and
/// whether it is a [Thumbnails.video]; while running, its cancellation and
/// whether its cell was on screen; whether it was cancelled as its cell left
/// the screen, to wait until the cell is back; while it rests after a
/// [Pending], the timer that ends the rest.
class _Request {
  _Request(this.at);

  final cells = <void Function()>[];
  // Those of views of their own, on screen wherever the grid looks.
  final own = <void Function()>{};
  int at;
  var order = 0, since = 0;
  Completer<void>? cancel;
  Timer? rest;
  var hit = false, video = false, seen = false, left = false;
}

/// The most wanted waiting requests of one kind, best first: at most [size],
/// the first [started] of them started, and whether [more] wait.
class _Ranking {
  _Ranking(this.size);

  final int size;
  final wanted = <_Wanted>[];
  var started = 0, more = false;

  _Wanted? get next => started < wanted.length ? wanted[started] : null;

  /// Whether more wait once these have started.
  bool get spent => more && next == null;

  void offer(int distance, _Request request, _Key key) {
    if (wanted.length == size) {
      more = true;
      if (!_before(distance, request, wanted.last)) return;
      wanted.removeLast();
    }
    var at = wanted.length;
    while (at > 0 && _before(distance, request, wanted[at - 1])) {
      at--;
    }
    wanted.insert(at, (distance, request, key));
  }
}

// The nearest first, then the newest, then the first in the timeline.
bool _before(int distance, _Request request, _Wanted other) =>
    distance != other.$1
    ? distance < other.$1
    : request.order != other.$2.order
    ? request.order > other.$2.order
    : request.at < other.$2.at;

/// Decoded thumbnails (docs/10 §3.4, T1) by item and tier, and the queue that
/// fills them (§3.5) by timeline position. Decoding never waits for the
/// scroll: the visible cells come first, the newest requests first (those of
/// one frame from the top), then two screens ahead in the scroll direction
/// and one behind, where one cell behind counts as two ahead. Tiles the
/// source has [cached] are read beside the [concurrency] decodes, half as
/// many while the user scrolls. A decode
/// whose cell leaves the screen, or that leaves the window, is cancelled; one
/// that takes longer than [timeout] gives up its slot. A failed decode marks
/// its cells and is retried once, when its row is next shown; one [Pending]
/// rests, unmarked, 1 s, then twice as long each time up to a minute, and is
/// asked for again while wanted. By default as
/// many decode at once as native decoder pools have threads, cores − 1, and
/// four on the web (ADR-0040).
class Thumbnails {
  Thumbnails(
    this.source, {
    int? concurrency,
    this.video,
    int? maxBytes,
    this.timeout = const Duration(seconds: 10),
    this.cached,
    this.onError,
    this.onTile,
  }) : concurrency = concurrency ?? (kIsWeb ? 4 : max(1, processors() - 1)),
       maxBytes =
           maxBytes ??
           memoryCacheBytes(
             physicalMemory(),
             phone:
                 defaultTargetPlatform == TargetPlatform.android ||
                 defaultTargetPlatform == TargetPlatform.iOS,
           );

  /// The cores the default [concurrency] counts. A test whose expectations
  /// assume a number of decodes at once sets it to a machine it names (four, as
  /// the gate's) instead of the one it runs on; it puts it back.
  @visibleForTesting
  static int Function() processors = _processors;
  static int _processors() => Platform.numberOfProcessors;

  final ThumbnailSource source;
  final int concurrency;

  /// Whether an item is a video, of which at most two decode at once, so that
  /// long files leave the other slots to photos.
  final bool Function(Object item)? video;

  /// The memory cache's size, which always keeps three screens of images.
  final int maxBytes;
  final Duration timeout;

  /// Whether the source has the tile at hand, as in its disk cache (T2).
  final bool Function(Object item, int tier)? cached;

  /// Hears of every failed decode, which is logged.
  final void Function(Object item, int tier, Object error)? onError;

  /// Hears of every tile that arrives, with the time of each stage.
  final void Function(Object item, int tier, Tile tile)? onTile;

  final _images = <_Key, ui.Image>{}; // least recently used first
  var _bytes = 0;
  // Requests waiting, running, or shown, which clear() sends back to waiting.
  final _waiting = <_Key, _Request>{};
  final _running = <_Key, _Request>{};
  final _shown = <_Key, _Request>{};
  // Why each failed decode failed, and whether it was retried.
  final _failed = <_Key, (Object, bool)>{};
  // How many times in a row each was pending.
  final _pending = <_Key, int>{};
  // The most wanted waiting requests in the window, photos and videos to
  // decode and tiles to read, two rounds of slots of each, ranked in one pass
  // after a change to the queue or once used up: a decode that finishes
  // starts the next, so that a long queue costs no sort per decode.
  ({_Ranking photos, _Ranking videos, _Ranking reads})? _ranked;
  var _first = 0, _last = -1, _forward = true, _scrolling = false;
  var _paused = false, _scheduled = false, _order = 0;
  final _clock = Stopwatch()..start();

  /// Whether the user scrolls, the scrubber outruns the decodes, or a cell in
  /// view or the window waits for its decode or has one running: background
  /// work waits.
  final busy = ValueNotifier(false);

  /// The tier cells last asked for.
  int get tier => _tier;
  var _tier = 256;

  /// While the scrubber moves faster than a decode finishes: cached tiles are
  /// still read, decodes wait.
  bool get paused => _paused;
  set paused(bool value) {
    _paused = value;
    _schedule();
  }

  /// Requests waiting for a decode or running one.
  int get pending => _waiting.length + _running.length;

  /// The visible assets, the scroll direction, and whether the user scrolls.
  void focus(
    int first,
    int last, {
    required bool forward,
    bool scrolling = false,
  }) {
    _first = first;
    _last = last;
    _forward = forward;
    _scrolling = scrolling;
    _ranked = null;
    for (final MapEntry(:key, value: request) in [..._running.entries]) {
      final distance = _near(request);
      if (distance == 0) {
        request.seen = true;
      } else if (request.seen || distance == null) {
        _cancel(key);
        request.left = request.seen;
      }
    }
    _schedule();
  }

  /// Drops every image, as under memory pressure (§3.4); the cells still shown
  /// decode again.
  void clear() {
    for (final image in _images.values) {
      image.dispose();
    }
    _images.clear();
    _bytes = 0;
    _shown.forEach(_wait);
    _shown.clear();
    _ranked = null;
    _schedule();
  }

  /// Why the thumbnail of [item] failed, while it has none.
  Object? failure(Object item, int tier) => _failed[(item, tier)]?.$1;

  /// The thumbnail of [item] at [tier], if decoded.
  ui.Image? get(Object item, int tier) {
    final image = _images.remove((item, tier));
    if (image != null) _images[(item, tier)] = image;
    return image;
  }

  /// What a cell of [item] at [tier] shows: its thumbnail, else another tier
  /// in memory, scaled, else the file's embedded preview.
  ui.Image? shown(Object item, int tier) {
    var image = get(item, tier);
    for (var t = tier ~/ 2; image == null && t >= 128; t ~/= 2) {
      image = get(item, t);
    }
    for (var t = tier * 2; image == null && t <= 1024; t *= 2) {
      image = get(item, t);
    }
    return image ?? get(item, 0);
  }

  /// Calls [ready] once the thumbnail of [item], at timeline position [at],
  /// is decoded or a stand-in arrives, unless [unwant]ed first. The cell of
  /// a view of its [own], as the viewer's filmstrip, which builds only the
  /// cells it shows, is on screen wherever the grid looks.
  void want(
    Object item,
    int tier,
    void Function() ready, {
    required int at,
    bool own = false,
  }) {
    final key = (item, tier);
    _tier = tier;
    final request =
        _waiting[key] ?? _running[key] ?? _shown.remove(key) ?? _Request(at);
    request
      ..cells.add(ready)
      ..at = at
      ..order = _order;
    if (own) request.own.add(ready);
    if (_running.containsKey(key)) return;
    if (_images.containsKey(key) || _failed[key]?.$2 == true) {
      _shown[key] = request;
      return;
    }
    if (_failed[key] case (final error, false)) {
      _failed[key] = (error, true);
      _log.debug('retry', fields: {'file': '$item', 'tier': tier});
    }
    if (!_waiting.containsKey(key)) _wait(key, request);
    _ranked = null;
    _schedule();
  }

  void unwant(Object item, int tier, void Function() ready) {
    final key = (item, tier);
    (_waiting[key] ?? _shown[key] ?? _running[key])?.own.remove(ready);
    for (final requests in [_waiting, _shown]) {
      if (requests[key]?.cells case final cells?) {
        cells.remove(ready);
        if (cells.isEmpty) requests.remove(key)?.rest?.cancel();
      }
    }
    if (_running[key] case final request?) {
      request.cells.remove(ready);
      if (request.cells.isEmpty) _cancel(key);
    }
    _ranked = null;
    _schedule();
  }

  // Its cells wait again; a result that arrives anyway still shows.
  void _cancel(_Key key) {
    final request = _running.remove(key)!;
    if (!request.cancel!.isCompleted) request.cancel!.complete();
    _log.debug('cancelled', fields: {'file': '${key.$1}', 'tier': key.$2});
    if (request.cells.isNotEmpty) _wait(key, request);
  }

  void _wait(_Key key, _Request request) => _waiting[key] = request
    ..since = _clock.elapsedMicroseconds
    ..hit = cached?.call(key.$1, key.$2) ?? false
    ..video = video?.call(key.$1) ?? false;

  void _schedule() {
    if (_scheduled) return;
    _scheduled = true;
    scheduleMicrotask(() {
      _scheduled = false;
      _order++;
      final decoding = _running.values.where((r) => !r.hit);
      // Half as many decodes while the user scrolls, whose frames come first;
      // cached tiles are read beside them, a few rows at a time; at most two
      // videos decode at once, so that long files leave the rest to photos.
      final slots = _scrolling ? (concurrency + 1) ~/ 2 : concurrency;
      var decodes = _paused ? 0 : slots - decoding.length;
      var videos = 2 - decoding.where((r) => r.video).length;
      var reads = 8 * concurrency - _running.length + decoding.length;
      for (;;) {
        final ranked = _ranked ??= _rank();
        final started = <_Wanted>[];
        void take(_Ranking ranking) =>
            started.add(ranking.wanted[ranking.started++]);
        for (; decodes > 0; decodes--) {
          final photo = ranked.photos.next;
          final video = videos > 0 ? ranked.videos.next : null;
          if (video != null &&
              (photo == null || _before(video.$1, video.$2, photo))) {
            take(ranked.videos);
            videos--;
          } else if (photo != null) {
            take(ranked.photos);
          } else {
            break;
          }
        }
        for (; reads > 0 && ranked.reads.next != null; reads--) {
          take(ranked.reads);
        }
        started.sort(
          (a, b) =>
              _before(a.$1, a.$2, b) ? -1 : (_before(b.$1, b.$2, a) ? 1 : 0),
        );
        for (final (_, _, key) in started) {
          _start(key);
        }
        if (!(decodes > 0 &&
                (ranked.photos.spent || videos > 0 && ranked.videos.spent) ||
            reads > 0 && ranked.reads.spent)) {
          break;
        }
        _ranked = null;
      }
      final ranked = _ranked ??= _rank();
      busy.value =
          _scrolling ||
          _paused ||
          _running.isNotEmpty ||
          [
            ranked.photos,
            ranked.videos,
            ranked.reads,
          ].any((r) => r.more || r.next != null);
    });
  }

  ({_Ranking photos, _Ranking videos, _Ranking reads}) _rank() {
    final ranked = (
      photos: _Ranking(2 * concurrency),
      videos: _Ranking(4),
      reads: _Ranking(16 * concurrency),
    );
    _waiting.forEach((key, request) {
      if (request.rest?.isActive ?? false) return;
      if (_wanted(request) case final distance?) {
        (request.hit
                ? ranked.reads
                : request.video
                ? ranked.videos
                : ranked.photos)
            .offer(distance, request, key);
      }
    });
    return ranked;
  }

  // How far a request is from the visible cells, or null while it waits.
  int? _wanted(_Request request) {
    final distance = _near(request);
    return request.left && distance != 0 ? null : distance;
  }

  int? _near(_Request request) =>
      request.own.isEmpty ? _distance(request.at) : 0;

  // How far the asset is from the visible ones, or null outside the window.
  int? _distance(int asset) {
    if (_last < _first) return 0;
    final screen = _last - _first + 1;
    final ahead = _forward ? asset - _last : _first - asset;
    final behind = _forward ? _first - asset : asset - _last;
    if (ahead > 2 * screen || behind > screen) return null;
    return ahead > 0 ? ahead : (behind > 0 ? 2 * behind : 0);
  }

  void _start(_Key key) {
    final request = _waiting.remove(key)!;
    final cancel = request.cancel = Completer<void>();
    request
      ..seen = _near(request) == 0
      ..left = false;
    _running[key] = request;
    final tile = Tile(cancel)
      ..stages['queue'] = (_clock.elapsedMicroseconds - request.since) / 1000
      ..show = shown(key.$1, key.$2) == null
          ? (image, tier) => _stand(key, image, tier)
          : null;
    final fields = {'file': '${key.$1}', 'tier': key.$2};
    _log.debug(
      'decode',
      fields: {
        ...fields,
        'slots': '${_running.length}/$concurrency',
        'waiting': _waiting.length,
      },
    );
    final took = Stopwatch()..start();
    bool current() => identical(_running[key]?.cancel, cancel);
    final timer = Timer(timeout, () {
      if (current()) _fail(key, TimeoutException('no thumbnail', timeout));
    });
    cancel.future.then((_) => timer.cancel());
    source(key.$1, key.$2, tile).then(
      (image) {
        timer.cancel();
        _log.debug(
          'decoded',
          fields: {
            ...fields,
            'ms': took.elapsedMilliseconds,
            if (!current()) 'late': true,
          },
        );
        _keep(key, image);
        _failed.remove(key);
        _pending.remove(key);
        // Late, after a timeout or a cancel, it still shows where its cells
        // are, and spares another run.
        var shown = _running.remove(key);
        if (shown == null && (shown = _waiting.remove(key)) != null) {
          _ranked = null;
        }
        if (shown?.cancel case final other? when !other.isCompleted) {
          other.complete();
        }
        final request = shown ?? _shown[key];
        if (request != null) {
          _shown[key] = request;
          for (final ready in [...request.cells]) {
            ready();
          }
        }
        onTile?.call(key.$1, key.$2, tile);
        _schedule();
      },
      onError: (Object error) {
        timer.cancel();
        if (!current()) return;
        error is Pending ? _rest(key, error) : _fail(key, error);
      },
    );
  }

  // Waits, unmarked, for the rest of its backoff before it runs again.
  void _rest(_Key key, Pending pending) {
    final request = _running.remove(key);
    if (request == null) return;
    if (request.cancel case final cancel? when !cancel.isCompleted) {
      cancel.complete();
    }
    final times = _pending[key] = (_pending[key] ?? 0) + 1;
    final rest = Duration(seconds: min(60, 1 << min(times - 1, 6)));
    _log.debug(
      'pending',
      fields: {
        'file': '${key.$1}',
        'tier': key.$2,
        'cause': pending.cause,
        'ms': rest.inMilliseconds,
      },
    );
    final marked = _failed.remove(key) != null;
    if (request.cells.isNotEmpty) {
      _wait(key, request);
      request.rest = Timer(rest, () {
        _ranked = null;
        _schedule();
      });
    }
    if (marked) {
      for (final ready in [...request.cells]) {
        ready();
      }
    }
    _ranked = null;
    _schedule();
  }

  // A smaller image the source has at hand, until the tile itself arrives.
  void _stand(_Key key, ui.Image image, int tier) {
    final stand = (key.$1, tier);
    if (_images.containsKey(key) || _images.containsKey(stand)) {
      return image.dispose();
    }
    _keep(stand, image);
    for (final ready in [...?(_running[key] ?? _waiting[key])?.cells]) {
      ready();
    }
  }

  void _keep(_Key key, ui.Image image) {
    int size(ui.Image image) => image.width * image.height * 4;
    if (_images.remove(key) case final old?) {
      _bytes -= size(old);
      old.dispose();
    }
    _images[key] = image;
    _bytes += size(image);
    final screens = 3 * max(1, _last - _first + 1);
    while (_bytes > maxBytes && _images.length > screens) {
      final evicted = _images.remove(_images.keys.first)!;
      _bytes -= size(evicted);
      evicted.dispose();
    }
  }

  void _fail(_Key key, Object error) {
    final request = _running.remove(key)!;
    if (!request.cancel!.isCompleted) request.cancel!.complete();
    final retried = _failed[key]?.$2 ?? false;
    _failed[key] = (error, retried);
    _log.warning(
      'no thumbnail',
      fields: {'file': '${key.$1}', 'tier': key.$2, 'retried': retried},
      error: error,
    );
    onError?.call(key.$1, key.$2, error);
    _shown[key] = request;
    for (final ready in [...request.cells]) {
      ready();
    }
    _schedule();
  }
}
