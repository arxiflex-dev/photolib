import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photolib/core/memory.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ui.Image image(int side) {
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawPaint(ui.Paint());
    return recorder.endRecording().toImageSync(side, side);
  }

  // A source whose decodes finish when the test says so.
  final started = <int>[];
  final decodes = <int, Completer<ui.Image>>{};
  final cancelled = <int>[];
  Future<ui.Image> source(Object item, int tier, Tile tile) {
    final asset = item as int;
    started.add(asset);
    tile.cancelled.then((_) => cancelled.add(asset));
    return (decodes[asset] = Completer()).future;
  }

  setUp(() {
    started.clear();
    decodes.clear();
    cancelled.clear();
  });

  test('tiers are the powers of two from 128 to 1024 px', () {
    expect(
      [
        for (final px in <double>[1, 128, 129, 300, 512, 900, 4000])
          tierFor(px),
      ],
      [128, 128, 256, 512, 512, 1024, 1024],
    );
  });

  test('the defaults are the design\'s: cores − 1 (two at least) decodes at once, and '
      'memory for images by RAM', () {
    List<int> mib(List<int> gib, {required bool phone}) => [
      for (final g in gib) memoryCacheBytes(g << 30, phone: phone) >> 20,
    ];
    expect(mib([3, 6, 12], phone: true), [128, 192, 256]);
    expect(mib([4, 8, 16, 64], phone: false), [128, 256, 512, 512]);
    expect(memoryCacheBytes(null, phone: false), 128 << 20);
    final thumbnails = Thumbnails(source);
    expect(thumbnails.concurrency, max(2, Platform.numberOfProcessors - 1));
    expect(
      thumbnails.maxBytes,
      memoryCacheBytes(physicalMemory(), phone: true),
      reason: 'tests run as Android',
    );
  });

  test('a machine of one or two cores still decodes two at once, so that '
      'one slow decode does not hold every cell', () async {
    final cores = Thumbnails.processors;
    addTearDown(() => Thumbnails.processors = cores);
    Thumbnails.processors = () => 4;
    expect(Thumbnails(source).concurrency, 3);
    for (final count in [1, 2, 3]) {
      Thumbnails.processors = () => count;
      expect(Thumbnails(source).concurrency, 2, reason: '$count cores');
    }
    Thumbnails.processors = () => 2;
    final thumbnails = Thumbnails(source)..focus(0, 3, forward: true);
    for (final asset in [0, 1]) {
      thumbnails.want(asset, 256, () {}, at: asset);
    }
    await pumpEventQueue();
    expect(started, [0, 1], reason: 'the first decode never ends');
    decodes[1]!.complete(image(256));
    await pumpEventQueue();
    expect(thumbnails.get(1, 256), isNotNull);
  });

  test('decodes the visible cells, the newest requests first, then two '
      'screens ahead and one behind', () async {
    final thumbnails = Thumbnails(source, concurrency: 2)
      ..focus(100, 103, forward: true);
    for (final asset in [90, 109, 100, 99, 112, 102, 96, 95, 113]) {
      thumbnails.want(asset, 256, () {}, at: asset);
    }
    await pumpEventQueue();
    expect(started, [100, 102], reason: 'visible, two at once');
    thumbnails.want(103, 256, () {}, at: 103);
    await pumpEventQueue();
    thumbnails.want(101, 256, () {}, at: 101);
    await pumpEventQueue();
    for (final asset in [100, 102]) {
      decodes[asset]!.complete(image(256));
    }
    await pumpEventQueue();
    expect(started.skip(2), [101, 103], reason: 'the newest first');
    for (final asset in [101, 103]) {
      decodes[asset]!.complete(image(256));
    }
    await pumpEventQueue();
    expect(started.skip(4), [99, 109], reason: '1 behind counts as 2 ahead');
    decodes[99]!.complete(image(256));
    decodes[109]!.complete(image(256));
    await pumpEventQueue();
    expect(started.skip(6), [96], reason: 'not 112 or 113, nor 95 or 90');
    thumbnails.focus(104, 107, forward: true);
    await pumpEventQueue();
    expect(started.skip(7), [112, 113]);
  });

  test('a decode whose cell leaves the screen is cancelled at once, until '
      'it is back; a prefetch once it leaves the window; a result still '
      'shows', () async {
    final thumbnails = Thumbnails(source, concurrency: 2)
      ..focus(0, 3, forward: true);
    var ready = 0;
    thumbnails
      ..want(2, 256, () => ready++, at: 2)
      ..want(9, 256, () {}, at: 9);
    await pumpEventQueue();
    expect(started, [2, 9], reason: 'on screen, and two screens ahead');
    thumbnails.focus(6, 9, forward: true);
    await pumpEventQueue();
    expect(cancelled, [2], reason: 'scrolled past: 9 is in view now');
    expect(started, [2, 9], reason: 'not again while behind');
    thumbnails.focus(30, 33, forward: true);
    await pumpEventQueue();
    expect(cancelled, [2, 9]);
    decodes[2]!.complete(image(256));
    await pumpEventQueue();
    expect(thumbnails.get(2, 256), isNotNull);
    expect(ready, 1);
    thumbnails.focus(8, 11, forward: false);
    await pumpEventQueue();
    expect(started, [2, 9, 9], reason: 'back in view');
  });

  test(
    'a cell of a view of its own, as the filmstrip, is on screen '
    'wherever the grid looks, until only a grid cell wants its tile',
    () async {
      final thumbnails = Thumbnails(source, concurrency: 1)
        ..focus(0, 3, forward: true);
      void strip() {}
      void grid() {}
      thumbnails
        ..want(50, 256, strip, at: 50, own: true)
        ..want(51, 256, strip, at: 51, own: true)
        ..want(51, 256, grid, at: 51);
      await pumpEventQueue();
      expect(started, [50], reason: 'far from the grid, one slot');
      thumbnails.focus(100, 103, forward: true);
      await pumpEventQueue();
      expect(cancelled, isEmpty, reason: 'the grid moving cancels none');
      thumbnails.unwant(51, 256, strip);
      decodes[50]!.complete(image(256));
      await pumpEventQueue();
      expect(started, [50], reason: "51 is off the grid's window");
      thumbnails.focus(48, 51, forward: true);
      await pumpEventQueue();
      expect(started, [50, 51], reason: 'in view of the grid');
    },
  );

  test('reads cached tiles at once, beside the decodes, and while paused, '
      'as the scrubber outruns them', () async {
    final thumbnails = Thumbnails(
      source,
      concurrency: 1,
      cached: (item, _) => (item as int) >= 10,
    )..focus(0, 20, forward: true);
    for (final asset in [1, 2, 10, 11, 12]) {
      thumbnails.want(asset, 256, () {}, at: asset);
    }
    await pumpEventQueue();
    expect(started, [1, 10, 11, 12], reason: 'one decode, every read');
    thumbnails
      ..paused = true
      ..want(13, 256, () {}, at: 13)
      ..want(3, 256, () {}, at: 3);
    decodes[1]!.complete(image(256));
    await pumpEventQueue();
    expect(started.skip(4), [13], reason: 'paused: no decode');
    thumbnails.paused = false;
    await pumpEventQueue();
    expect(started.skip(5), [3]);
  });

  test(
    'at most two videos decode at once: photos take the other slots',
    () async {
      // Four slots, whatever cores this machine has (the gate's four give
      // three).
      final thumbnails = Thumbnails(
        source,
        concurrency: 4,
        video: (item) => (item as int).isOdd,
      );
      for (final asset in [1, 3, 5, 2, 4]) {
        thumbnails.want(asset, 256, () {}, at: asset);
      }
      await pumpEventQueue();
      expect(started, [1, 2, 3, 4], reason: 'video 5 waits for a slot');
      decodes[1]!.complete(image(256));
      await pumpEventQueue();
      expect(started.skip(4), [5]);
    },
  );

  test('while the user scrolls, half as many decodes, and cached tiles '
      'eight times as many as decodes', () async {
    final thumbnails = Thumbnails(
      source,
      concurrency: 2,
      cached: (item, _) => (item as int) >= 10,
    )..focus(0, 40, forward: true, scrolling: true);
    for (final asset in [1, 2, for (var a = 10; a < 30; a++) a]) {
      thumbnails.want(asset, 256, () {}, at: asset);
    }
    await pumpEventQueue();
    expect(started, [1, for (var a = 10; a < 26; a++) a]);
    thumbnails.focus(0, 40, forward: true);
    await pumpEventQueue();
    expect(started.skip(17), [2]);
  });

  test('an image belongs to its item, wherever the item moves', () async {
    final names = <Object>[];
    final thumbnails = Thumbnails((item, tier, _) async {
      names.add(item);
      return image(tier);
    });
    thumbnails.want('a', 128, () {}, at: 5);
    await pumpEventQueue();
    thumbnails.want('a', 128, () {}, at: 9);
    thumbnails.want('b', 128, () {}, at: 5);
    await pumpEventQueue();
    expect(names, ['a', 'b']);
    expect(thumbnails.get('a', 128), isNotNull);
  });

  test('tells the cell when its thumbnail is ready', () async {
    final thumbnails = Thumbnails(source);
    var ready = 0;
    thumbnails.want(7, 256, () => ready++, at: 7);
    await pumpEventQueue();
    expect(thumbnails.get(7, 256), isNull);
    decodes[7]!.complete(image(256));
    await pumpEventQueue();
    expect(ready, 1);
    expect(thumbnails.get(7, 256)!.width, 256);
    thumbnails.want(7, 256, () => ready++, at: 7);
    await pumpEventQueue();
    expect(started, [7], reason: 'cached');
  });

  test('a request nobody wants any more is never decoded', () async {
    final thumbnails = Thumbnails(source, concurrency: 1);
    void cell() {}
    thumbnails.want(1, 256, () {}, at: 1);
    thumbnails.want(2, 256, cell, at: 2);
    thumbnails.unwant(2, 256, cell);
    await pumpEventQueue();
    decodes[1]!.complete(image(256));
    await pumpEventQueue();
    expect(started, [1]);
    expect(thumbnails.pending, 0);
  });

  test('cancels a running decode nobody wants any more', () async {
    final thumbnails = Thumbnails(source, concurrency: 1);
    void cell() {}
    thumbnails.want(1, 256, cell, at: 1);
    thumbnails.want(2, 256, () {}, at: 2);
    await pumpEventQueue();
    thumbnails.unwant(1, 256, cell);
    await pumpEventQueue();
    expect(cancelled, [1]);
    expect(started, [1, 2], reason: 'its place goes to the next');
  });

  test(
    'a memory warning drops the images and decodes the wanted again',
    () async {
      final thumbnails = Thumbnails(source);
      var ready = 0;
      thumbnails.want(7, 256, () => ready++, at: 7);
      await pumpEventQueue();
      final decoded = image(256);
      decodes[7]!.complete(decoded);
      await pumpEventQueue();
      thumbnails.clear();
      expect(thumbnails.get(7, 256), isNull);
      expect(decoded.debugDisposed, isTrue);
      await pumpEventQueue();
      expect(started, [7, 7]);
      decodes[7]!.complete(image(256));
      await pumpEventQueue();
      expect(ready, 2);
    },
  );

  test('a failed decode marks its cells, is logged, and is retried once when '
      'its row is next shown', () async {
    final errors = <(Object, int, Object)>[];
    final thumbnails = Thumbnails(
      source,
      onError: (item, tier, error) => errors.add((item, tier, error)),
    );
    var ready = 0;
    void cell() => ready++;
    thumbnails.want(7, 256, cell, at: 7);
    await pumpEventQueue();
    decodes[7]!.completeError(
      const NoThumbnail(video: true, cause: 'ffmpeg: refused'),
    );
    await pumpEventQueue();
    expect(ready, 1, reason: 'the cell repaints with its mark');
    expect(thumbnails.failure(7, 256), isA<NoThumbnail>());
    expect(errors.single.$1, 7);
    expect(errors.single.$3, isA<NoThumbnail>());
    expect(thumbnails.pending, 0);
    thumbnails.unwant(7, 256, cell);
    thumbnails.want(7, 256, cell, at: 7);
    await pumpEventQueue();
    expect(started, [7, 7], reason: 'shown again: retried');
    expect(thumbnails.failure(7, 256), isNotNull, reason: 'marked meanwhile');
    decodes[7]!.completeError(StateError('still broken'));
    await pumpEventQueue();
    thumbnails.unwant(7, 256, cell);
    thumbnails.want(7, 256, cell, at: 7);
    await pumpEventQueue();
    expect(started, [7, 7], reason: 'retried once only');
    expect(errors.length, 2);
  });

  test('a retried decode that succeeds clears its mark', () async {
    final thumbnails = Thumbnails(source);
    void cell() {}
    thumbnails.want(1, 128, cell, at: 1);
    await pumpEventQueue();
    decodes[1]!.completeError(StateError('busy disk'));
    await pumpEventQueue();
    thumbnails
      ..unwant(1, 128, cell)
      ..want(1, 128, cell, at: 1);
    await pumpEventQueue();
    decodes[1]!.complete(image(128));
    await pumpEventQueue();
    expect(thumbnails.failure(1, 128), isNull);
    expect(thumbnails.get(1, 128), isNotNull);
  });

  test('a decode that hangs times out of its slot, cancelled and marked, and '
      'shows if it ends later', () {
    fakeAsync((async) {
      final errors = <Object>[];
      final thumbnails = Thumbnails(
        source,
        concurrency: 1,
        timeout: const Duration(seconds: 5),
        onError: (_, _, error) => errors.add(error),
      );
      var ready = 0;
      thumbnails.want(1, 256, () => ready++, at: 1);
      thumbnails.want(2, 256, () {}, at: 2);
      async.elapse(const Duration(milliseconds: 4999));
      expect(started, [1]);
      async.elapse(const Duration(milliseconds: 1));
      expect(cancelled, [1]);
      expect(errors.single, isA<TimeoutException>());
      expect(thumbnails.failure(1, 256), isA<TimeoutException>());
      expect(started, [1, 2], reason: 'its slot goes to the next');
      expect(ready, 1);
      decodes[1]!.complete(image(256));
      async.flushMicrotasks();
      expect(thumbnails.get(1, 256), isNotNull);
      expect(thumbnails.failure(1, 256), isNull);
      expect(ready, 2);
    });
  });

  test('a thumbnail not there yet leaves its cells unmarked and is asked for '
      'again after 1, 2, 4 s, up to a minute apart, while wanted', () {
    fakeAsync((async) {
      final thumbnails = Thumbnails(source)..focus(0, 3, forward: true);
      var ready = 0;
      thumbnails.want(1, 256, () => ready++, at: 1);
      async.flushMicrotasks();
      final waits = <int>[];
      for (var i = 0; i < 8; i++) {
        decodes[1]!.completeError(const Pending('not rendered yet'));
        async.flushMicrotasks();
        expect(thumbnails.failure(1, 256), isNull);
        expect(thumbnails.busy.value, isFalse, reason: 'background work goes');
        final before = started.length;
        var waited = 0;
        while (started.length == before && waited < 600000) {
          async.elapse(const Duration(milliseconds: 100));
          waited += 100;
        }
        waits.add(waited);
      }
      expect(waits, [1000, 2000, 4000, 8000, 16000, 32000, 60000, 60000]);
      expect(ready, 0, reason: 'its ThumbHash stays as it is');
      decodes[1]!.complete(image(256));
      async.flushMicrotasks();
      expect(thumbnails.get(1, 256), isNotNull);
      expect(ready, 1);
    });
  });

  test('a thumbnail not there yet that nobody wants any more is not asked '
      'for again, and one that was marked loses its mark', () {
    fakeAsync((async) {
      final thumbnails = Thumbnails(source);
      var ready = 0;
      void cell() => ready++;
      thumbnails.want(1, 256, cell, at: 1);
      async.flushMicrotasks();
      decodes[1]!.completeError(StateError('timeout'));
      async.flushMicrotasks();
      thumbnails
        ..unwant(1, 256, cell)
        ..want(1, 256, cell, at: 1);
      async.flushMicrotasks();
      decodes[1]!.completeError(const Pending('unreachable'));
      async.flushMicrotasks();
      expect(thumbnails.failure(1, 256), isNull);
      expect(ready, 2, reason: 'repainted without its mark');
      thumbnails.unwant(1, 256, cell);
      async.elapse(const Duration(minutes: 5));
      expect(started, [1, 1]);
      expect(async.pendingTimers, isEmpty);
    });
  });

  test('is busy while a visible cell waits or decodes, paused or scrolled, '
      'and knows the tier cells last wanted', () async {
    final thumbnails = Thumbnails(source)..focus(0, 3, forward: true);
    expect(thumbnails.busy.value, isFalse);
    thumbnails.want(1, 512, () {}, at: 1);
    await pumpEventQueue();
    expect(thumbnails.busy.value, isTrue);
    expect(thumbnails.tier, 512);
    decodes[1]!.complete(image(512));
    await pumpEventQueue();
    expect(thumbnails.busy.value, isFalse);
    thumbnails.want(40, 512, () {}, at: 40);
    await pumpEventQueue();
    expect(thumbnails.busy.value, isFalse, reason: 'out of the window');
    thumbnails.paused = true;
    await pumpEventQueue();
    expect(thumbnails.busy.value, isTrue);
    thumbnails
      ..paused = false
      ..focus(0, 3, forward: true, scrolling: true);
    await pumpEventQueue();
    expect(thumbnails.busy.value, isTrue);
    thumbnails.focus(0, 3, forward: true);
    await pumpEventQueue();
    expect(thumbnails.busy.value, isFalse);
  });

  test('keeps the most recently used images within its bytes', () async {
    // 128 x 128 RGBA is 64 KiB; three fit.
    final thumbnails = Thumbnails(source, maxBytes: 3 * 65536);
    for (final asset in [1, 2, 3]) {
      thumbnails.want(asset, 128, () {}, at: asset);
      await pumpEventQueue();
      decodes[asset]!.complete(image(128));
      await pumpEventQueue();
    }
    thumbnails.get(1, 128);
    thumbnails.want(4, 128, () {}, at: 4);
    await pumpEventQueue();
    decodes[4]!.complete(image(128));
    await pumpEventQueue();
    expect(
      [
        for (final a in [1, 2, 3, 4]) thumbnails.get(a, 128) != null,
      ],
      [true, false, true, true],
    );
  });

  test('keeps three screens of images, whatever its bytes', () async {
    final thumbnails = Thumbnails(source, maxBytes: 1)
      ..focus(0, 1, forward: true);
    for (var asset = 0; asset < 8; asset++) {
      thumbnails.want(asset, 128, () {}, at: 0);
      await pumpEventQueue();
      decodes[asset]!.complete(image(128));
      await pumpEventQueue();
    }
    expect(
      [for (var a = 0; a < 8; a++) thumbnails.get(a, 128) != null],
      [false, false, true, true, true, true, true, true],
    );
  });

  test('shows another tier, or a stand-in the source hands over, until its '
      'own arrives, which then replaces it', () async {
    final stands = <Tile>[];
    final thumbnails = Thumbnails((item, tier, tile) {
      stands.add(tile);
      return source(item, tier, tile);
    });
    var ready = 0;
    thumbnails.want(1, 128, () {}, at: 1);
    await pumpEventQueue();
    final small = image(128);
    decodes[1]!.complete(small);
    await pumpEventQueue();
    thumbnails.want(1, 256, () => ready++, at: 1);
    await pumpEventQueue();
    expect(thumbnails.get(1, 256), isNull);
    expect(thumbnails.shown(1, 256), same(small), reason: 'scaled up');
    expect(stands.last.show, isNull, reason: 'one stand-in is enough');
    final large = image(256);
    decodes[1]!.complete(large);
    await pumpEventQueue();
    expect(thumbnails.shown(1, 256), same(large));
    expect(thumbnails.shown(1, 128), same(small));

    thumbnails.want(2, 256, () => ready++, at: 2);
    await pumpEventQueue();
    expect(thumbnails.shown(2, 256), isNull);
    final embedded = image(64);
    stands.last.show!(embedded, 0);
    expect(ready, 2, reason: 'the cell repaints with it');
    expect(thumbnails.shown(2, 256), same(embedded));
    stands.last.show!(image(64), 0);
    expect(ready, 2, reason: 'the first stand-in stays');
    decodes[2]!.complete(image(256));
    await pumpEventQueue();
    expect(thumbnails.shown(2, 256)!.width, 256);
  });

  test("times each tile's way: its wait in the queue, then the source's "
      'stages', () {
    fakeAsync((async) {
      final tiles = <(Object, int, Tile)>[];
      final thumbnails = Thumbnails(
        concurrency: 1,
        (item, tier, tile) =>
            tile.time('decode', () => source(item, tier, tile)),
        onTile: (item, tier, tile) => tiles.add((item, tier, tile)),
      );
      thumbnails
        ..want(2, 256, () {}, at: 2)
        ..want(3, 256, () {}, at: 3);
      async.flushMicrotasks();
      decodes[2]!.complete(image(256));
      async.flushMicrotasks();
      final (item, tier, tile) = tiles.single;
      expect((item, tier), (2, 256));
      expect(tile.stages.keys, ['queue', 'decode']);
      expect(tile.stages['queue'], greaterThanOrEqualTo(0));
      expect(tile.stages['decode'], greaterThanOrEqualTo(0));
    });
  });
}
