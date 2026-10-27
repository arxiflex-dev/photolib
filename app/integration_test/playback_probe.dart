// Plays every video of the media corpus and the video of every motion photo
// with the app's players on this target (docs/10 §4.2, §4.3), and every 360°
// video projected, at its golden frame (§4.4): `bash tools/video/app_play.sh`. The corpus' payloads do not decode, so each
// plays as a twin, as the server's video test makes them
// (server/crates/photolib-server/tests/video.rs): a decodable clip of the same
// container, codec, picture size, rotation, frame rate class, HDR signalling
// and audio, which needs FFmpeg. Where FFmpeg does not run (Android, iOS,
// macOS, Windows), tools/smoke.sh makes the 360° twins and their golden frames
// and serves them at SPHERE_TWINS.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/viewer/info_panel.dart';
import 'package:photolib/features/viewer/mpv.dart';
import 'package:photolib/features/viewer/sphere.dart';
import 'package:photolib/features/viewer/sphere_frame.dart';
import 'package:photolib/features/viewer/sphere_player.dart';
import 'package:photolib/features/viewer/video.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib_data/photolib_data.dart' show LocalAssetData;
import 'package:video_player/video_player.dart';

import '../test/support/sphere_goldens.dart';
import '../test/support/sphere_twins.dart';

part 'playback_twins.dart';

const _corpus = String.fromEnvironment('PLAYBACK_CORPUS');
const _ffmpeg = String.fromEnvironment('PLAYBACK_FFMPEG');
const _served = String.fromEnvironment('SPHERE_TWINS');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    MpvPlayers.register();
  }

  testWidgets('every corpus video and motion photo plays', (tester) async {
    final dir = await Directory.systemTemp.createTemp('playback-');
    addTearDown(() => dir.delete(recursive: true));
    final playable = await _playable(dir);
    final wrong = <String>[];
    for (final path in [...playable.keys]..sort()) {
      final (file, size) = playable[path]!;
      if (await _wrong(tester, path, file, size) case final why?) {
        wrong.add(why);
      }
    }
    expect(wrong, isEmpty, reason: '${wrong.length} of ${playable.length}');
  });

  // On screen, as the X server has it: textures are in no Flutter snapshot.
  testWidgets('every corpus 360° video plays projected by libmpv, and the '
      'shader filters its frame as on Android and Apple, at its golden frame '
      'within the tolerance', (tester) async {
    final dir = await Directory.systemTemp.createTemp('spheres-');
    addTearDown(() => dir.delete(recursive: true));
    final twins = await _twins(dir);
    await sphereProgram;
    expect(twins, hasLength(6));
    final differences = <String, Object>{};
    final wrong = <String>[];
    for (final t in twins) {
      for (final (name, difference, tolerance) in [
        (t.path, await _projected(tester, t), goldenTolerance),
        ('${t.path} filtered', await _filtered(tester, t), goldenTolerance),
      ]) {
        differences[name] = difference;
        if (difference is! double || difference > tolerance) wrong.add(name);
      }
    }
    expect(wrong, isEmpty, reason: '$differences');
  });

  // media_kit_video's software output, as under Xvfb, is at most 1920 × 1080
  // each way, so a larger picture of another shape was drawn small in its box.
  testWidgets(
    'a flat video larger than 1080p and not 16:9 fills its box',
    _shapes,
  );

  // libmpv loaded a sidecar of the video's name itself and drew it into the
  // picture, under the viewer's own captions and past their toggle.
  testWidgets(
    'a video with captions beside it draws none into its picture: the viewer '
    'shows them',
    _captions,
  );

  // libmpv opens them and reaches their end paused, with no picture and no
  // error: the viewer showed black, never that they cannot play.
  testWidgets(
    'every corpus 360° video, none of which decodes, fails its player, so '
    'the viewer says that it cannot play',
    _undecodable,
  );

  // media_kit_video's Linux output, torn down, hung or crashed the app
  // within a few dozen players (ADR-0112).
  testWidgets(
    'players made and disposed one after another as they play never stop '
    'the app',
    _oneAfterAnother,
  );

  // libmpv logs an error for each decoder it then does without: Ubuntu
  // 24.04's libmpv 0.37 "Could not open codec." for every H.264 video, whose
  // hardware decoder fails before software takes over.
  testWidgets(
    'a video plays whatever errors libmpv logs on the way, and '
    'one that ends before its first picture fails its player',
    _errors,
  );

  // The Windows release pipeline runs the same on its package (ADR-0404).
  testWidgets(
    'the self-test plays a clip headless with the bundled libmpv and says so, '
    'and fails for a file libmpv cannot decode',
    _selfTest,
  );
}

Future<void> _selfTest(WidgetTester tester) async {
  final dir = await Directory.systemTemp.createTemp('self-test-');
  addTearDown(() => dir.delete(recursive: true));
  final clip = '${dir.path}/clip.mp4';
  await _run([
    ...['-f', 'lavfi', '-i', 'testsrc2=s=320x240:r=30:d=3'],
    ...['-c:v', 'libopenh264', '-movflags', '+faststart'],
    clip,
  ]);
  final broken = File('${dir.path}/broken.mp4')
    ..writeAsBytesSync(List.filled(4096, 7));
  for (final (video, code, report) in [
    (clip, 0, startsWith('played ')),
    ('$_corpus/files/video/mjpeg.mov', 0, startsWith('played ')),
    (broken.path, 1, startsWith('failed: ')),
  ]) {
    final result = '${dir.path}/${video.split('/').last}.txt';
    final got = await runSelfTest((video: video, result: result));
    expect(got, code, reason: File(result).readAsStringSync());
    final lines = File(result).readAsLinesSync();
    expect(lines.first, report, reason: '$lines');
    expect(lines.last, startsWith('mpv '), reason: 'the versions it ran with');
  }
}

/// Plays 40 players of an H.264 clip, each disposed as the next is made.
Future<void> _oneAfterAnother(WidgetTester tester) async {
  final dir = await Directory.systemTemp.createTemp('players-');
  addTearDown(() => dir.delete(recursive: true));
  final clip = '${dir.path}/clip.mp4';
  await _run([
    ...['-f', 'lavfi', '-i', 'testsrc2=s=1920x1080:r=30:d=4'],
    ...['-c:v', 'libopenh264', '-b:v', '8M', '-movflags', '+faststart'],
    clip,
  ]);
  for (var i = 0; i < 40; i++) {
    final player = VideoPlayerController.file(File(clip));
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(width: 320, height: 240, child: VideoPlayer(player)),
      ),
    );
    var opened = false;
    player.initialize().then((_) => opened = true);
    await _until(tester, () => opened);
    expect(opened, isTrue, reason: 'player $i');
    await player.play();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpWidget(const SizedBox());
    await player.dispose();
  }
}

/// Opens an H.264 clip with sound, the same with sound no decoder reads, the
/// same with pictures none reads, random bytes and a missing file.
Future<void> _errors(WidgetTester tester) async {
  final dir = await Directory.systemTemp.createTemp('errors-');
  addTearDown(() => dir.delete(recursive: true));
  final clip = File('${dir.path}/clip.mkv');
  await _run([
    ...['-f', 'lavfi', '-i', 'testsrc2=s=640x360:r=30:d=2'],
    ...['-f', 'lavfi', '-i', 'sine=d=2'],
    ...['-c:v', 'libopenh264', '-c:a', 'aac', clip.path],
  ]);
  // Matroska names codecs in text: one of the same length no decoder knows.
  File unknown(String codec) {
    final bytes = latin1.decode(clip.readAsBytesSync());
    return File(
      '${dir.path}/${codec.replaceAll('/', '_')}.mkv',
    )..writeAsBytesSync(
      latin1.encode(bytes.replaceFirst(codec, codec.replaceRange(2, 5, 'XYZ'))),
    );
  }

  final random = Random(1);
  final files = {
    'h264': clip,
    'no sound': unknown('A_AAC'),
    'no picture': unknown('V_MPEG4/ISO/AVC'),
    'random': File('${dir.path}/random.mp4')
      ..writeAsBytesSync([
        for (var i = 0; i < 1 << 16; i++) random.nextInt(256),
      ]),
    'missing': File('${dir.path}/missing.mp4'),
  };
  final opened = <String, Object>{};
  for (final MapEntry(:key, value: file) in files.entries) {
    final player = VideoPlayerController.file(file);
    Object? result;
    unawaited(
      player.initialize().then<void>(
        (_) => result = player.value.size,
        onError: (Object e) => result = e is PlatformException ? 'fails' : e,
      ),
    );
    await _until(tester, () => result != null);
    opened[key] = result ?? 'waits';
    await player.dispose();
  }
  expect(opened, {
    'h264': const Size(640, 360),
    'no sound': const Size(640, 360),
    'no picture': 'fails',
    'random': 'fails',
    'missing': 'fails',
  });
}

/// What to play, as shown, by corpus path, made four at a time in [dir].
Future<Map<String, (File, Size)>> _playable(Directory dir) async {
  final records = [
    for (final f in Directory('$_corpus/golden').listSync(recursive: true))
      if (f is File) jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  ]..sort((a, b) => '${a['path']}'.compareTo('${b['path']}'));
  final videos = [
    for (final r in records)
      if (r['media']['kind'] == 'video') r,
  ];
  final motion = [
    for (final r in records)
      if (r['metadata']['motion'] != null) r,
  ];
  expect(videos.length, greaterThan(70), reason: 'the corpus: $_corpus');
  expect(motion.length, greaterThanOrEqualTo(4));

  final playable = <String, (File, Size)>{};
  final queue = [...videos, ...motion];
  var made = 0;
  await Future.wait([
    for (var i = 0; i < 4; i++)
      () async {
        while (queue.isNotEmpty) {
          final r = queue.removeLast();
          final path = r['path'] as String;
          final scratch = Directory('${dir.path}/${made++}')..createSync();
          playable[path] = r['media']['kind'] == 'video'
              ? (
                  await _twin(r, scratch),
                  _shown(r['metadata'] as Map<String, dynamic>),
                )
              : (await _motion(r, scratch), const Size(1280, 960));
        }
      }(),
  ]);
  return playable;
}

/// What is wrong when [file] plays, or null when it opens, plays and shows
/// as [size].
Future<String?> _wrong(
  WidgetTester tester,
  String path,
  File file,
  Size size,
) async {
  final player = VideoPlayerController.file(file);
  try {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(width: 320, height: 240, child: VideoPlayer(player)),
        ),
      ),
    );
    Object? opened;
    player.initialize().then<void>(
      (_) => opened = true,
      onError: (Object e) => opened = e,
    );
    await _until(tester, () => opened != null);
    if (opened != true) throw StateError('not open: ${opened ?? '20 s'}');
    await player.play();
    final truncated = path.contains('truncated');
    await _until(
      tester,
      () =>
          player.value.position >= const Duration(milliseconds: 500) ||
          truncated && player.value.position > Duration.zero,
    );
    final v = player.value;
    if (v.size != size || v.position == Duration.zero || v.hasError) {
      return '$path: ${v.size}, at ${v.position}, ${v.errorDescription ?? ''}';
    }
    return null;
  } on Object catch (e) {
    return '$path: $e';
  } finally {
    await player.dispose();
  }
}

/// Plays a white picture taller and one wider than 1080p as the viewer
/// shows a video, in a box of its shape, and expects white to fill the box.
Future<void> _shapes(WidgetTester tester) async {
  final dir = await Directory.systemTemp.createTemp('shapes-');
  addTearDown(() => dir.delete(recursive: true));
  final filled = <String, double>{};
  for (final (w, h) in [(1080, 1920), (3840, 1920)]) {
    final clip = File('${dir.path}/$w.mp4');
    await _run([
      ...['-f', 'lavfi', '-i', 'color=c=white:s=${w}x$h:r=30:d=4'],
      ...['-c:v', 'libopenh264', '-b:v', '2M', clip.path],
    ]);
    final player = VideoPlayerController.file(clip);
    try {
      var opened = false;
      unawaited(player.initialize().then((_) => opened = true));
      await _until(tester, () => opened);
      await _blank(tester);
      await tester.pumpWidget(
        _at(
          Center(
            child: AspectRatio(
              aspectRatio: player.value.aspectRatio,
              child: VideoPlayer(player),
            ),
          ),
        ),
      );
      await player.play();
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final shown = await _screen();
      var white = 0;
      for (var i = 0; i < shown.length; i += 4) {
        if (shown[i] > 200 && shown[i + 1] > 200 && shown[i + 2] > 200) {
          white++;
        }
      }
      final box = tester.getSize(find.byType(AspectRatio));
      filled['${w}x$h'] = white / (box.width * box.height);
    } finally {
      await tester.pumpWidget(const SizedBox());
      await player.dispose();
    }
  }
  expect(
    filled.values.every((f) => (f - 1).abs() < 0.03),
    isTrue,
    reason: '$filled',
  );
}

/// Plays a black clip whose sidecar captions are white, and expects the
/// picture to stay black.
Future<void> _captions(WidgetTester tester) async {
  final dir = await Directory.systemTemp.createTemp('captions-');
  addTearDown(() => dir.delete(recursive: true));
  final clip = File('${dir.path}/clip.mp4');
  await _run([
    ...['-f', 'lavfi', '-i', 'color=c=black:s=1280x720:r=30:d=4'],
    ...['-c:v', 'libopenh264', '-b:v', '2M', clip.path],
  ]);
  File('${dir.path}/clip.srt').writeAsStringSync(
    '1\n00:00:00,000 --> 00:00:04,000\nWWWWWWWWWWWWWWWWWWWW\n',
  );
  final player = VideoPlayerController.file(clip);
  try {
    var opened = false;
    unawaited(player.initialize().then((_) => opened = true));
    await _until(tester, () => opened);
    await _blank(tester);
    await tester.pumpWidget(_at(VideoPlayer(player)));
    await player.play();
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    final shown = await _screen();
    expect(
      [for (var i = 0; i < shown.length; i += 4) shown[i]].reduce(max),
      lessThan(64),
    );
  } finally {
    await tester.pumpWidget(const SizedBox());
    await player.dispose();
  }
}

/// Opens each corpus 360° video, none of which decodes, as the viewer does,
/// and expects each player to fail rather than wait.
Future<void> _undecodable(WidgetTester tester) async {
  final files = [
    for (final f in Directory('$_corpus/files/compound/sphere').listSync())
      if (f is File) f.path,
  ]..sort();
  expect(files, hasLength(6));
  final players = VideoPlayers()..still = true;
  addTearDown(players.dispose);
  final waiting = <String>[];
  for (final f in files) {
    players.want({
      f: (options) async =>
          VideoPlayerController.file(File(f), videoPlayerOptions: options),
    }, f);
    await _until(tester, () => players.failed(f) || players[f] != null);
    if (!players.failed(f)) waiting.add(f);
  }
  expect(waiting, isEmpty);
}

/// How far what the viewer shows on screen of [t] at [goldenAt], projected
/// by libmpv, is from its golden frame, or what went wrong.
Future<Object> _projected(WidgetTester tester, SphereTwin t) async {
  final player = VideoPlayerController.file(t.twin);
  final sphere = sphereOf(cube: t.cube, stereo: t.stereo, crop: t.crop);
  final view = ValueNotifier(goldenViewOf(sphere));
  try {
    Object? opened;
    player.initialize().then<void>(
      (_) => opened = true,
      onError: (Object e) => opened = e,
    );
    await _until(tester, () => opened != null);
    if (opened != true) return 'not open: ${opened ?? '20 s'}';
    await _blank(tester);
    await tester.pumpWidget(
      _at(
        SphereVideo(player: player, poster: null, sphere: sphere, view: view),
      ),
    );
    // libmpv's filter first: paused, a seek under way may keep the last.
    await tester.pump(const Duration(seconds: 2));
    unawaited(player.seekTo(goldenAt));
    await _until(tester, () => player.value.position == goldenAt);
    return await _fromGolden(tester, t);
  } on Object catch (e) {
    return '$e';
  } finally {
    await tester.pumpWidget(const SizedBox());
    view.dispose();
    await player.dispose();
  }
}

/// How far what [SphereFilter] shows on screen of [t]'s frame at [goldenAt],
/// laid out as it lays out a player's view on Android and Apple, is from its
/// golden frame. A picture rather than libmpv's texture, which Linux draws
/// once a frame, so never as the eye's next copy.
Future<Object> _filtered(WidgetTester tester, SphereTwin t) async {
  final frame = File('${t.twin.path}.frame.png');
  final sphere = sphereOf(cube: t.cube, stereo: t.stereo, crop: t.crop);
  final view = ValueNotifier(goldenViewOf(sphere));
  try {
    if (!frame.existsSync()) {
      await _run([
        ...['-ss', '${goldenAt.inMilliseconds / 1000}', '-i', t.twin.path],
        ...['-frames:v', '1', frame.path],
      ]);
    }
    final codec = await ui.instantiateImageCodec(frame.readAsBytesSync());
    final image = (await codec.getNextFrame()).image;
    await _blank(tester);
    await tester.pumpWidget(
      _at(
        SphereFilter(
          picture: RawImage(image: image, fit: BoxFit.fill),
          frame: Size(image.width.toDouble(), image.height.toDouble()),
          sphere: sphere,
          view: view,
        ),
      ),
    );
    return await _fromGolden(tester, t);
  } on Object catch (e) {
    return '$e';
  } finally {
    await tester.pumpWidget(const SizedBox());
    view.dispose();
  }
}

/// [child] in the top left corner, the golden frame's size in pixels.
Widget _at(Widget child) {
  final ratio =
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  return Localizations(
    locale: const Locale('en'),
    delegates: AppLocalizations.localizationsDelegates,
    child: MediaQuery(
      data: MediaQueryData(devicePixelRatio: ratio),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox.fromSize(size: goldenSize / ratio, child: child),
      ),
    ),
  );
}

/// Pumps a blank screen until the screen shows it, so that no grab is of what
/// was shown before; the first finds where the view is on a whole screen's
/// grab.
Future<void> _blank(WidgetTester tester) async {
  await tester.pumpWidget(const ColoredBox(color: Color(0xffff00ff)));
  for (var i = 0; i < 50; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (!Platform.isLinux) _origin ??= _magenta(await _rgbaOf(await _grab()));
    if ((await _screen()).take(4).join(',') == '255,0,255,255') return;
  }
}

/// The 360° twins and golden frames, made with FFmpeg in [dir], or those
/// tools/smoke.sh serves at [_served], with the frames that the shader filter
/// is fed, fetched into [dir].
Future<List<SphereTwin>> _twins(Directory dir) async {
  if (_served.isEmpty) return await goldenTwins(_corpus, _ffmpeg, dir);
  final client = HttpClient();
  try {
    Future<File> fetch(String name) async {
      final file = File('${dir.path}/$name');
      final response = await (await client.getUrl(Uri.parse('$_served/$name')))
          .close();
      if (response.statusCode != 200) throw StateError('$name: no twin');
      await response.pipe(file.openWrite());
      return file;
    }

    final served = <SphereTwin>[];
    final twins = jsonDecode(await (await fetch('twins.json')).readAsString());
    for (final t in (twins as List).cast<Map<String, dynamic>>()) {
      // The frame the filter is fed, beside its twin, as _filtered finds it.
      await fetch(t['frame'] as String);
      served.add((
        path: t['path'] as String,
        cube: t['cube'] as bool,
        stereo: t['stereo'] as String?,
        crop: t['crop'] as String?,
        twin: await fetch(t['twin'] as String),
        golden: await fetch(t['golden'] as String),
      ));
    }
    return served;
  } finally {
    client.close();
  }
}

// Where the view's top left is in a grab of the whole screen, off Linux.
(int, int)? _origin;

/// Where in [screen], RGBA and its width, the first box of magenta the golden
/// frame's size starts, as [_blank] shows it.
(int, int)? _magenta((Uint8List, int) screen) {
  final (rgba, width) = screen;
  final (w, h) = (goldenSize.width.toInt(), goldenSize.height.toInt());
  bool magenta(int x, int y) {
    final i = (y * width + x) * 4;
    return i + 3 < rgba.length &&
        rgba[i] == 255 &&
        rgba[i + 1] == 0 &&
        rgba[i + 2] == 255;
  }

  final height = rgba.length ~/ 4 ~/ width;
  for (var y = 0; y + h <= height; y++) {
    for (var x = 0; x + w <= width; x++) {
      if (magenta(x, y) &&
          magenta(x + w - 1, y) &&
          magenta(x, y + h - 1) &&
          magenta(x + w - 1, y + h - 1)) {
        return (x, y);
      }
    }
  }
  return null;
}

/// The whole screen as PNG: a phone's through the integration test's
/// screenshot, a Mac's through screencapture, Windows' through .NET.
Future<Uint8List> _grab() async {
  final binding = IntegrationTestWidgetsFlutterBinding.instance;
  if (Platform.isAndroid || Platform.isIOS) {
    if (Platform.isAndroid && !_converted) {
      await binding.convertFlutterSurfaceToImage();
      _converted = true;
    }
    return Uint8List.fromList(await binding.takeScreenshot('probe'));
  }
  final png = '${Directory.systemTemp.path}/playback-probe-screen.png';
  final r = Platform.isMacOS
      ? await Process.run('screencapture', ['-x', '-t', 'png', png])
      : await Process.run('powershell', [
          '-NoProfile',
          '-Command',
          _copyScreen(png),
        ]);
  if (r.exitCode != 0) throw StateError('screen grab: ${r.stderr}');
  return File(png).readAsBytesSync();
}

var _converted = false;

/// PowerShell that saves the primary screen to [png].
String _copyScreen(String png) =>
    'Add-Type -AssemblyName System.Windows.Forms, System.Drawing; '
    r'$s = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds; '
    r'$b = New-Object System.Drawing.Bitmap $s.Width, $s.Height; '
    r'[System.Drawing.Graphics]::FromImage($b).CopyFromScreen('
    r'$s.Location, [System.Drawing.Point]::Empty, $s.Size); '
    "\$b.Save('$png')";

Future<(Uint8List, int)> _rgbaOf(Uint8List png) async {
  final codec = await ui.instantiateImageCodec(png);
  final image = (await codec.getNextFrame()).image;
  final rgba = (await image.toByteData())?.buffer.asUint8List();
  return (rgba ?? Uint8List(0), image.width);
}

/// How far the screen is from [t]'s golden frame: the least of five grabs
/// once it holds the same picture twice, as a frame can show a moment late.
/// No golden frame is of one colour.
Future<double> _fromGolden(WidgetTester tester, SphereTwin t) async {
  var shown = await _screen();
  for (var i = 0; i < 50; i++) {
    await tester.pump(const Duration(milliseconds: 200));
    final next = await _screen();
    final still = frameDifference(next, shown) == 0;
    shown = next;
    if (still && shown.any((b) => b != shown.first)) break;
  }
  final golden = await _rgba(t.golden.readAsBytesSync());
  var least = frameDifference(shown, golden);
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 300));
    least = min(least, frameDifference(await _screen(), golden));
  }
  return least;
}

/// What the screen shows at the view's top left corner, the golden frame's
/// size, as RGBA: the X server's top left on Linux.
Future<Uint8List> _screen() async {
  final (w, h) = (goldenSize.width.toInt(), goldenSize.height.toInt());
  if (!Platform.isLinux) {
    final (rgba, width) = await _rgbaOf(await _grab());
    final (x, y) = _origin ?? (0, 0);
    return Uint8List.fromList([
      for (var r = y; r < y + h; r++)
        ...rgba.sublist((r * width + x) * 4, (r * width + x + w) * 4),
    ]);
  }
  final r = await Process.run('$_ffmpeg/ffmpeg', [
    ...['-loglevel', 'error', '-f', 'x11grab', '-video_size', '${w}x$h'],
    ...['-i', '${Platform.environment['DISPLAY']}+0,0', '-frames:v', '1'],
    ...['-c:v', 'png', '-f', 'image2pipe', '-'],
  ], stdoutEncoding: null);
  if (r.exitCode != 0) throw StateError('x11grab: ${r.stderr}');
  return await _rgba(Uint8List.fromList(r.stdout as List<int>));
}

Future<Uint8List> _rgba(Uint8List png) async {
  final codec = await ui.instantiateImageCodec(png);
  final image = (await codec.getNextFrame()).image;
  return (await image.toByteData())?.buffer.asUint8List() ?? Uint8List(0);
}

/// Pumps frames until [done] or 20 s have passed.
Future<void> _until(WidgetTester tester, bool Function() done) async {
  final end = DateTime.now().add(const Duration(seconds: 20));
  while (!done() && DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Size _shown(Map<String, dynamic> m) {
  final (w, h) = (
    (m['width'] as int).toDouble(),
    (m['height'] as int).toDouble(),
  );
  return m['orientation'] == 6 ? Size(h, w) : Size(w, h);
}

Future<void> _run(List<String> args) async {
  // Few threads: they are a limit shared with everything else running.
  final r = await Process.run('$_ffmpeg/ffmpeg', [
    ...['-nostdin', '-hide_banner', '-loglevel', 'error', '-y'],
    ...args.take(args.length - 1),
    ...['-threads', '2', args.last],
  ]);
  if (r.exitCode != 0) throw StateError('ffmpeg $args: ${r.stderr}');
}
