import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:photolib/features/library/timeline/disk_cache.dart';
import 'package:photolib/features/library/timeline/native_pipeline.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/thumb_hash.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/library/timeline/vips.dart';
import 'package:photolib_data/photolib_data.dart';
import 'package:photolib_data/testing.dart';
import 'package:photolib_kernel/photolib_kernel.dart';

import '../../../support/real_time.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  late DiskCache cache;
  late ThumbnailItem photo;
  final never = Tile();

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('pipeline');
    final (vault, cipher) = await scratchVault(
      '${dir.path}/store',
      Kernel().keyring,
    );
    addTearDown(vault.lock);
    cache = await DiskCache.open('${dir.path}/cache', cipher);
    final original = img.Image(width: 600, height: 400);
    for (final p in original) {
      p.setRgb(p.x * 255 ~/ 600, p.y * 255 ~/ 400, 90);
    }
    await File('${dir.path}/photo.jpg').writeAsBytes(img.encodeJpg(original));
    photo = ThumbnailItem('a1-b2', Uri.file('${dir.path}/photo.jpg'));
  });
  tearDown(() async {
    await cache.close(); // Tiles and its index may still be being written.
    await dir.delete(recursive: true);
  });

  (int, int) size(ui.Image image) => (image.width, image.height);

  // A decoder of the originals that hands over RGBA at the tier, as the
  // platforms' do, and counts its calls.
  var decoded = 0;
  final rgba = Thumbnailer('rgba', (item, tier, _) async {
    decoded++;
    final (w, h) = (tier * 3 ~/ 2, tier);
    return Pixels.rgba(
      Uint8List(w * h * 4)..fillRange(0, w * h * 4, 255),
      w,
      h,
    );
  });
  final refuses = Thumbnailer(
    'refuses',
    (_, _, _) => Future.error(const NoThumbnail(cause: 'not its format')),
  );
  Thumbnailer gives(Pixels pixels) =>
      Thumbnailer('gives', (_, _, _) async => pixels);

  setUp(() => decoded = 0);

  test('decodes the original with a decoder at the tier and keeps the tile '
      'in the disk cache', () async {
    final pipeline = ThumbnailPipeline(cache: cache, decoders: [rgba]);
    expect(size(await pipeline.load(photo, 256, never)), (384, 256));
    await pipeline.idle;
    expect(size(await pipeline.load(photo, 256, never)), (384, 256));
    expect(decoded, 1, reason: 'the second from the disk cache');
    final tile = img.decodeJpg((await cache.get('a1-b2-256'))!)!;
    expect((tile.width, tile.height), (384, 256));
    await pipeline.load(photo, 512, never);
    expect(decoded, 2, reason: 'another tier is another entry');
  });

  test('times each stage, and until the decode shows the largest smaller '
      'tier the disk cache has', () async {
    final slow = Completer<Pixels?>();
    final pipeline = ThumbnailPipeline(
      cache: cache,
      decoders: [
        Thumbnailer(
          'rgba',
          (item, tier, cancel) =>
              tier == 512 ? slow.future : rgba(item, tier, cancel),
        ),
      ],
    );
    for (final tier in [128, 256]) {
      await pipeline.load(photo, tier, Tile());
    }
    await pipeline.idle;
    final shown = <(int, int)>[];
    final tile = Tile()
      ..show = (image, tier) => shown.add((image.height, tier));
    final load = pipeline.load(photo, 512, tile);
    await realUntil(() => shown.isNotEmpty);
    expect(shown, [(256, 256)]);
    slow.complete(await rgba(photo, 512, never.cancelled));
    expect(size(await load), (768, 512));
    expect(tile.stages.keys, ['decode', 'upload']);
    await pipeline.idle;
    final again = Tile();
    await pipeline.load(photo, 512, again);
    expect(again.stages.keys, ['cache', 'upload']);
  });

  test('caches RGBA that is a view into a larger buffer, as a platform '
      "channel's, from its own start", () async {
    // 3 × 2 pixels of distinct colours, one translucent so the tile is PNG,
    // 5 bytes into a buffer that starts with something else.
    final (w, h) = (3, 2);
    final message = Uint8List(5 + w * h * 4)..fillRange(0, 5, 0xEE);
    final pixels = Uint8List.view(message.buffer, 5, w * h * 4);
    for (var i = 0; i < w * h; i++) {
      pixels.setRange(i * 4, i * 4 + 4, [10 + i, 100 + i, 200 + i, 255]);
    }
    pixels[3] = 254;
    final pipeline = ThumbnailPipeline(
      cache: cache,
      decoders: [gives(Pixels.rgba(pixels, w, h))],
    );
    await pipeline.load(photo, 128, never);
    await pipeline.idle;
    final tile = img.decodePng((await cache.get('a1-b2-128'))!)!;
    for (final p in tile) {
      final i = p.y * w + p.x;
      expect((p.r, p.g, p.b), (10 + i, 100 + i, 200 + i), reason: 'pixel $i');
    }
    expect(tile.getPixel(0, 0).a, 254);
  });

  test('keeps an encoded tile as it is, and RGBA with alpha as PNG', () async {
    final png = img.encodePng(img.Image(width: 4, height: 3));
    final pipeline = ThumbnailPipeline(
      cache: cache,
      decoders: [gives(Pixels.encoded(png))],
    );
    await pipeline.load(photo, 128, never);
    await pipeline.idle;
    expect(await cache.get('a1-b2-128'), png);
    final clear = Uint8List(2 * 2 * 4);
    final alpha = ThumbnailPipeline(
      cache: cache,
      decoders: [gives(Pixels.rgba(clear, 2, 2))],
    );
    await alpha.load(ThumbnailItem('c', photo.uri), 128, never);
    await alpha.idle;
    expect(img.decodePng((await cache.get('c-128'))!)!.numChannels, 4);
  });

  test('a decoder that refuses the format passes it to the next, as the '
      'platform passes HEIC to libvips on Linux', () async {
    final pipeline = ThumbnailPipeline(decoders: [refuses, rgba]);
    expect(size(await pipeline.load(photo, 128, never)), (192, 128));
    expect(decoded, 1);
  });

  test('a format every decoder refuses fails as such, a video with its own '
      'mark, and the error says why', () async {
    final pipeline = ThumbnailPipeline(
      decoders: [
        refuses,
        Thumbnailer('vips', (_, _, _) => Future.error(StateError('corrupt'))),
      ],
    );
    await expectLater(
      pipeline.load(photo, 128, never),
      throwsA(
        isA<NoThumbnail>()
            .having((e) => e.video, 'video', false)
            .having((e) => '$e', 'text', contains('corrupt')),
      ),
    );
    final movie = ThumbnailItem(
      'm',
      Uri.file('${dir.path}/a.mov'),
      video: true,
    );
    await expectLater(
      ThumbnailPipeline(originals: true).load(movie, 128, never),
      throwsA(isA<NoThumbnail>().having((e) => e.video, 'video', true)),
      reason: "never read whole into Flutter's codecs",
    );
  });

  test("a video's duration comes with its poster, from the decoder and, "
      'after a reload, from the disk cache', () async {
    final movie = ThumbnailItem('v', photo.uri, video: true);
    final jpeg = img.encodeJpg(img.Image(width: 4, height: 3));
    var posters = 0;
    final poster = Thumbnailer('poster', (_, _, _) async {
      posters++;
      return Pixels.encoded(jpeg, duration: const Duration(seconds: 83));
    });

    final pipeline = ThumbnailPipeline(cache: cache, decoders: [poster]);
    expect(pipeline.duration(movie), isNull);
    await pipeline.load(movie, 128, never);
    expect(pipeline.duration(movie), const Duration(seconds: 83));
    await pipeline.idle;
    final reloaded = ThumbnailPipeline(cache: cache, decoders: [poster]);
    expect(size(await reloaded.load(movie, 128, never)), (4, 3));
    expect(posters, 1, reason: 'the poster from the disk cache');
    expect(reloaded.duration(movie), const Duration(seconds: 83));
  });

  test('a video the platform cannot play is marked so, with its duration '
      'when known', () async {
    final movie = ThumbnailItem('v', photo.uri, video: true);
    const cannot = NoThumbnail(
      video: true,
      cause: 'no decoder for HEVC',
      unplayable: true,
      duration: Duration(seconds: 5),
    );
    final pipeline = ThumbnailPipeline(
      decoders: [
        refuses,
        Thumbnailer('player', (_, _, _) => Future.error(cannot)),
        refuses,
      ],
    );
    await expectLater(
      pipeline.load(movie, 128, never),
      throwsA(
        isA<NoThumbnail>().having((e) => e.unplayable, 'unplayable', true),
      ),
    );
    expect(pipeline.duration(movie), const Duration(seconds: 5));
  });

  // M1-49 (ADR-0214): a HEIC nothing decodes names the way out, on the
  // desktops where no codec ships; any other format keeps its own cause.
  for (final (name, uri, noHevc) in [
    ('IMG_1.HEIC', 'file:///p/IMG_1.HEIC', true),
    ('a heif', 'file:///p/a.heif', true),
    ('a JPEG', 'file:///p/a.jpg', false),
  ]) {
    test(
      '$name that every decoder refused is marked '
      '${noHevc ? 'as lacking an HEVC decoder' : 'as any refused file'}',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        final pipeline = ThumbnailPipeline(decoders: [refuses]);
        try {
          await expectLater(
            pipeline.load(ThumbnailItem('k', Uri.parse(uri)), 128, never),
            throwsA(
              isA<NoThumbnail>().having((e) => e.noHevc, 'noHevc', noHevc),
            ),
          );
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );
  }

  test("the cause names, in order, each decoder's answer: declined, with "
      'why when it says, refused with its message, or threw', () async {
    Thumbnailer fails(String name, Object error) =>
        Thumbnailer(name, (_, _, _) => Future.error(error));
    final pipeline = ThumbnailPipeline(
      thumbnailers: [Thumbnailer('os', (_, _, _) async => null)],
      decoders: [
        fails('macos', const Declined('nil reply')),
        fails('ffmpeg', const NoThumbnail(cause: 'moov atom not found')),
        fails('vips', StateError('corrupt')),
      ],
      originals: true,
    );
    final movie = ThumbnailItem('m', photo.uri, video: true);
    await expectLater(
      pipeline.load(movie, 128, never),
      throwsA(
        isA<NoThumbnail>().having(
          (e) => e.cause,
          'cause',
          'os: declined; macos: nil reply; '
              'ffmpeg: refused moov atom not found; '
              'vips: threw Bad state: corrupt; flutter: video',
        ),
      ),
    );
    await expectLater(
      ThumbnailPipeline().load(photo, 128, never),
      throwsA(isA<NoThumbnail>().having((e) => e.cause, 'cause', 'no decoder')),
    );
  });

  test(
    "Flutter's codecs decode a file no decoder took, which is not kept",
    () async {
      final pipeline = ThumbnailPipeline(cache: cache, originals: true);
      expect(size(await pipeline.load(photo, 256, never)), (384, 256));
      expect(size(await pipeline.load(photo, 1024, never)), (
        600,
        400,
      ), reason: 'never larger than the original');
      await pipeline.idle;
      expect(await cache.get('a1-b2-256'), isNull);
    },
  );

  test('takes the platform thumbnail first, which the OS keeps', () async {
    final asked = <String>[];
    final none = Thumbnailer('none', (_, _, _) async {
      asked.add('none');
      return null;
    });
    final os = Thumbnailer('os', (_, tier, _) async {
      asked.add('os $tier');
      return Pixels.rgba(Uint8List(300 * 200 * 4), 300, 200);
    });

    final pipeline = ThumbnailPipeline(
      cache: cache,
      thumbnailers: [none, os],
      decoders: [rgba],
    );
    final missing = ThumbnailItem('gone', Uri.file('${dir.path}/gone.jpg'));
    expect(size(await pipeline.load(missing, 128, never)), (192, 128));
    expect(asked, ['none', 'os 128']);
    expect(decoded, 0);
    await pipeline.idle;
    expect(await cache.get('gone-128'), isNull);
  });

  test(
    'decodes the original when the platform thumbnail does not decode',
    () async {
      final pipeline = ThumbnailPipeline(
        thumbnailers: [
          gives(Pixels.encoded(Uint8List.fromList([1, 2, 3]))),
        ],
        originals: true,
      );
      expect(size(await pipeline.load(photo, 256, never)), (384, 256));
    },
  );

  test('replaces a cached thumbnail that does not decode', () async {
    await cache.put('a1-b2-256', Uint8List.fromList([1, 2, 3]));
    final pipeline = ThumbnailPipeline(cache: cache, decoders: [rgba]);
    expect(size(await pipeline.load(photo, 256, never)), (384, 256));
    await pipeline.idle;
    expect((await cache.get('a1-b2-256'))!.length, greaterThan(3));
  });

  test(
    'stops once cancelled, and fails when nothing has a thumbnail',
    () async {
      final pipeline = ThumbnailPipeline(cache: cache, decoders: [rgba]);
      final cancel = Completer<void>()..complete();
      await expectLater(
        pipeline.load(photo, 256, Tile(cancel)),
        throwsA(anything),
      );
      await pipeline.idle;
      expect(await cache.get('a1-b2-256'), isNull);
      expect(decoded, 0);
      final elsewhere = ThumbnailItem('x', Uri.parse('content://media/1'));
      await expectLater(
        ThumbnailPipeline(originals: true).load(elsewhere, 256, never),
        throwsA(isA<NoThumbnail>()),
      );
    },
  );

  test('warms the disk cache with the decoders, once, makes no image, and '
      "returns the tile's ThumbHash while the item has none", () async {
    final pipeline = ThumbnailPipeline(
      cache: cache,
      decoders: [rgba],
      thumbHash: tileThumbHash,
    );
    final hash = ThumbHash.tryParse((await pipeline.warm(photo, 256))!)!;
    final (r, g, b, _) = hash.at(0.5, 0.5);
    expect([r, g, b], everyElement(closeTo(1, 0.02)), reason: 'white');
    expect(hash.aspect, closeTo(1.5, 0.2));
    expect(await pipeline.warm(photo, 256), isNotNull, reason: 'from cache');
    final hashed = ThumbnailItem(photo.key, photo.uri, hash: Uint8List(5));
    expect(await pipeline.warm(hashed, 256), isNull);
    expect(decoded, 1);
    expect(await cache.get('a1-b2-256'), isNotNull);
    await expectLater(
      ThumbnailPipeline(
        cache: cache,
        decoders: [refuses],
      ).warm(ThumbnailItem('r', photo.uri), 256),
      throwsA(
        isA<NoThumbnail>().having(
          (e) => e.cause,
          'cause',
          'refuses: refused not its format',
        ),
      ),
    );
  });

  // ADR-0040: cells show upright sRGB pixels, from the original (T4) and again
  // from the disk cache (T2).
  group('golden pixels', () {
    // The file at full size as a cell draws it: from the original with
    // Flutter's codecs, which keep nothing, and, with [vips], with libvips
    // (ADR-0107), then its tile from the disk cache alone. libvips converts
    // CMYK through its own fallback profile and keeps P3's values as they
    // are, which these goldens do not hold it to.
    Future<List<(int, int, ByteData)>> shown(
      File file, {
      bool vips = true,
    }) async {
      final item = ThumbnailItem(file.uri.pathSegments.last, file.uri);
      final images = [
        await ThumbnailPipeline(originals: true).load(item, 1024, never),
      ];
      if (vips) {
        final decoded = ThumbnailPipeline(
          cache: cache,
          decoders: [(await vipsDecoder())!],
        );
        images.add(await decoded.load(item, 1024, never));
        await decoded.idle;
        images.add(
          await ThumbnailPipeline(cache: cache).load(item, 1024, never),
        );
      }
      return [
        for (final image in images)
          (image.width, image.height, await _drawn(image)),
      ];
    }

    // tools/corpus/picture.py's bars, sampled at the bottom of the picture.
    List<(int, int, List<int>)> bars(String path, int width, int height) {
      const colours = [
        [192, 192, 192], [192, 192, 0], [0, 192, 192], [0, 192, 0], //
        [192, 0, 192], [192, 0, 0], [0, 0, 192], [96, 96, 96],
      ];
      final shift = sha256.convert(utf8.encode(path)).bytes[0];
      return [
        for (var i = 0; i < 8; i++)
          (i * width ~/ 128 * 16 + 8, height - 8, colours[(shift + i) % 8]),
      ];
    }

    // Where EXIF orientation [o] shows the stored pixel (x, y) of w × h.
    (int, int) display(int o, int x, int y, int w, int h) => switch (o) {
      2 => (w - 1 - x, y),
      3 => (w - 1 - x, h - 1 - y),
      4 => (x, h - 1 - y),
      5 => (y, x),
      6 => (h - 1 - y, x),
      7 => (h - 1 - y, w - 1 - x),
      8 => (y, w - 1 - x),
      _ => (x, y),
    };

    for (final (path, o, w, h) in [
      for (var o = 2; o <= 8; o++)
        ('compound/orientation/orientation-$o.jpg', o, 640, 480),
      ('stills/cmyk.jpg', 1, 320, 240),
    ]) {
      test(path, () async {
        final file = File('../testdata/corpus/files/$path').absolute;
        for (final (width, _, pixels) in await shown(file, vips: o > 1)) {
          expect(width, o < 5 ? w : h);
          for (final (x, y, colour) in bars(path, w, h)) {
            final (dx, dy) = display(o, x, y, w, h);
            expect(_rgb(pixels, width, dx, dy), _near(colour), reason: '$x');
          }
        }
      });
    }

    test('a platform thumbnail in BGRA, as PhotoKit hands it over', () async {
      final photoKit = gives(
        Pixels.bgra(
          Uint8List.fromList([
            for (var i = 0; i < 16; i++) ...[0, 64, 200, 255],
          ]),
          4,
          4,
        ),
      );
      final image = await ThumbnailPipeline(thumbnailers: [photoKit])
          .load(photo, 128, never);
      expect(_rgb(await _drawn(image), image.width, 1, 1), [200, 64, 0]);
    });

    test('Display P3, in a PNG and a JPEG', () async {
      // P3's (200, 150, 100) is sRGB's (209, 147, 91).
      final icc = _displayP3();
      final picture = img.Image(
        width: 64,
        height: 64,
      )..iccProfile = img.IccProfile('P3', img.IccProfileCompression.none, icc);
      for (final p in picture) {
        p.setRgb(200, 150, 100);
      }
      final png = img.encodePng(picture);
      // package:image writes the APP2 marker without its sequence number.
      final jpeg = img.encodeJpg(picture..iccProfile = null);
      final n = icc.length + 16;
      final app2 = [0xff, 0xe2, n >> 8, n & 255, ...'ICC_PROFILE'.codeUnits];
      for (final (name, bytes) in [
        ('p3.png', png),
        (
          'p3.jpg',
          [...jpeg.take(2), ...app2, 0, 1, 1, ...icc, ...jpeg.skip(2)],
        ),
      ]) {
        final file = File('${dir.path}/$name')..writeAsBytesSync(bytes);
        for (final (width, _, pixels) in await shown(file, vips: false)) {
          expect(
            _rgb(pixels, width, 32, 32),
            _near([209, 147, 91]),
            reason: name,
          );
        }
      }
    });
  });

  test('an edit changes the key, and items have their URIs', () {
    TimelineItemData asset(
      String source, {
      int mtime = 5,
      String? mime,
      String path = 'Trips/a b.jpg',
      String? projection,
      int favorite = 0,
    }) => TimelineItemData(
      id: Uint8List.fromList([0xab, 0x01]),
      source: source,
      volume: source == 'folder' ? '/home/me/Photos' : 'external_primary',
      sourceId: '42',
      size: 1000,
      mtime: mtime,
      path: source == 'folder' ? path : 'DCIM/',
      mime: mime,
      favorite: favorite,
      hidden: 0,
      archived: 1,
      added: 0,
      day: 19700101,
      sortKey: mtime,
      folder: 0,
      projection: projection,
      backup: 'not_backed_up',
    );
    final folder = ThumbnailItem.local(asset('folder'));
    expect(folder.sphere, isFalse);
    expect(
      [
        for (final p in ['equirectangular', 'cubemap', 'mesh'])
          ThumbnailItem.local(asset('folder', projection: p)).sphere,
      ],
      [true, true, false],
      reason: 'spheres that the viewer projects',
    );
    final favourite = ThumbnailItem.local(asset('folder', favorite: 1));
    expect(folder.marks, {Mark.archived});
    expect(favourite.marks, {Mark.favourite, Mark.archived});
    expect(favourite.key, folder.key, reason: 'marks keep its tiles');
    expect(folder.uri, Uri.file('/home/me/Photos/Trips/a b.jpg'));
    expect(folder.video, isFalse);
    expect(
      ThumbnailItem.local(asset('folder', mime: 'video/quicktime')).video,
      isTrue,
    );
    expect(
      ThumbnailItem.local(asset('folder', path: 'IMG_1.MOV')).video,
      isTrue,
      reason: 'a Live Photo motion file, before its metadata is read',
    );
    expect(
      folder.key,
      isNot(ThumbnailItem.local(asset('folder', mtime: 6)).key),
    );
    expect(
      ThumbnailItem.local(asset('mediastore', mime: 'video/mp4')).uri,
      Uri.parse('content://media/external_primary/video/media/42'),
    );
    expect(
      ThumbnailItem.local(asset('mediastore', mime: 'image/jpeg')).uri,
      Uri.parse('content://media/external_primary/images/media/42'),
    );
    expect(
      ThumbnailItem.local(asset('photokit', mime: 'video/*')).uri,
      Uri.parse('ph:42'),
    );
    final asset7 = Uint8List(16)..[15] = 7;
    final cloud = ThumbnailItem.local(
      TimelineItemData(
        id: asset7,
        source: 'server',
        volume: '',
        sourceId: '',
        size: 300,
        mtime: 0,
        mime: 'video/*',
        favorite: 0,
        hidden: 0,
        archived: 0,
        added: 0,
        day: 0,
        sortKey: 0,
        folder: 0,
        assetId: asset7,
        backup: 'cloud_only',
        thumbS: Uint8List.fromList([0xab, 0x01]),
      ),
    );
    expect(cloud.uri, Uri(path: 'media/00000000-0000-0000-0000-000000000007'));
    expect(cloud.renditions, {
      'thumb_s': 'ab01',
    }, reason: "the server's renditions (T5), by their hashes");
    expect(folder.renditions, isNull);
    expect(
      (cloud.id, cloud.asset, cloud.video, cloud.backup, cloud.bytes),
      (null, asset7, true, Availability.cloudOnly, 300),
      reason: 'no device item: nothing to extract, open or drag from here',
    );
    expect(folder.backup, Availability.notBackedUp);
  });
}

Future<ByteData> _drawn(ui.Image image) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawImage(image, ui.Offset.zero, ui.Paint());
  final srgb = await recorder.endRecording().toImage(image.width, image.height);
  return (await srgb.toByteData())!;
}

List<int> _rgb(ByteData pixels, int width, int x, int y) => [
  for (var c = 0; c < 3; c++) pixels.getUint8((y * width + x) * 4 + c),
];

Matcher _near(List<int> rgb) =>
    pairwiseCompare<int, int>(rgb, (a, b) => (a - b).abs() <= 6, 'within 6 of');

// Display P3 as Apple's profile has it (D50-adapted primaries, sRGB's curve).
Uint8List _displayP3() {
  int sig(String s) => s.codeUnits.fold(0, (a, c) => a << 8 | c);
  int s15(double v) => (v * 65536).round();
  List<int> xyz(double x, double y, double z) => [
    sig('XYZ '),
    0,
    s15(x),
    s15(y),
    s15(z),
  ];
  final curve = [
    sig('para'), 0, 3 << 16, s15(2.4), s15(1 / 1.055), //
    s15(0.055 / 1.055), s15(1 / 12.92), s15(0.04045),
  ];
  final tags = {
    'rXYZ': xyz(0.515102, 0.241196, -0.001053),
    'gXYZ': xyz(0.291965, 0.692230, 0.041884),
    'bXYZ': xyz(0.157153, 0.066574, 0.784073),
    'wtpt': xyz(0.9642, 1, 0.8249),
    'rTRC': curve,
    'gTRC': curve,
    'bTRC': curve,
  };
  final words = [for (final data in tags.values) ...data];
  var at = 132 + 12 * tags.length;
  final out = ByteData(at + 4 * words.length);
  for (final (offset, value) in [
    (8, 0x02100000),
    (12, sig('mntr')),
    (16, sig('RGB ')),
    (20, sig('XYZ ')),
    (36, sig('acsp')),
    (68, s15(0.9642)),
    (72, s15(1)),
    (76, s15(0.8249)),
    (128, tags.length),
  ]) {
    out.setInt32(offset, value);
  }
  var entry = 132;
  for (final MapEntry(key: name, value: data) in tags.entries) {
    out
      ..setInt32(entry, sig(name))
      ..setInt32(entry + 4, at)
      ..setInt32(entry + 8, 4 * data.length);
    entry += 12;
    for (final word in data) {
      out.setInt32(at, word);
      at += 4;
    }
  }
  out.setInt32(0, out.lengthInBytes);
  return out.buffer.asUint8List();
}
