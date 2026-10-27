import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/viewer/sphere.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

/// How media_kit_video shows a player's pictures: in software on Windows,
/// where the app ships no ANGLE for its hardware path (ADR-0229).
VideoControllerConfiguration mpvVideoConfiguration() =>
    VideoControllerConfiguration(
      enableHardwareAcceleration:
          defaultTargetPlatform != TargetPlatform.windows,
    );

/// The licences of the libraries in [file], in Flutter's NOTICES format, as
/// tools/video/libmpv.sh writes them; none without the file.
Stream<LicenseEntry> bundledNotices(File file) async* {
  final String text;
  try {
    text = await file.readAsString();
  } on PathNotFoundException {
    return;
  }
  for (final entry in text.split('\n${'-' * 80}\n')) {
    final split = entry.indexOf('\n\n');
    yield LicenseEntryWithLineBreaks(
      entry.substring(0, split).split('\n'),
      entry.substring(split + 2),
    );
  }
}

/// What `--self-test-play <video> <result>` asks of the app: play the video
/// with the libmpv it bundles, write what happened to the result file, and
/// exit.
typedef SelfTest = ({String video, String result});

/// The self-test [args] ask for, or null when they are files to open.
SelfTest? selfTestOf(List<String> args) {
  if (args.isEmpty || args.first != '--self-test-play') return null;
  if (args.length != 3) {
    throw ArgumentError('usage: --self-test-play <video> <result file>');
  }
  return (video: args[1], result: args[2]);
}

/// Plays [test]'s video, headless (no picture out, no audio), until its first
/// second or its end, and writes `played ...` or `failed: ...` and the
/// libmpv and FFmpeg versions it ran with to its result file. Returns the
/// exit code: 0 when a picture decoded and nothing failed. The release
/// pipeline runs it on a clean Windows machine (tools/windows/smoke.sh).
Future<int> runSelfTest(SelfTest test) async {
  var report = '';
  var code = 1;
  try {
    // Asynchronous already; the lint prefers the synchronous call.
    // ignore: avoid_slow_async_io
    if (!await File(test.video).exists()) {
      report = 'failed: ${test.video} does not exist';
    } else {
      MediaKit.ensureInitialized();
      final player = Player();
      try {
        final native = player.native;
        // media_kit leaves video off until a controller turns it on.
        await native.setProperty('vid', 'auto');
        await native.setProperty('ao', 'null');
        final errors = <String>[];
        final logs = <String>[];
        final listening = [
          player.stream.error.listen(errors.add),
          player.stream.log.listen((l) => logs.add('${l.prefix}: ${l.text}')),
        ];
        await player.open(Media(test.video));
        await Future.any([
          player.stream.position.firstWhere((p) => p.inSeconds >= 1),
          player.stream.completed.firstWhere((done) => done),
          player.stream.error.first,
          Future<void>.delayed(const Duration(seconds: 60)),
        ]);
        for (final l in listening) {
          await l.cancel();
        }
        final state = player.state;
        final (w, h) = (state.width ?? 0, state.height ?? 0);
        final versions =
            '${await native.getProperty('mpv-version')}, '
            'ffmpeg ${await native.getProperty('ffmpeg-version')}';
        if (errors.isNotEmpty) {
          report = 'failed: ${errors.join('; ')}';
        } else if (w == 0 || h == 0 || state.position == Duration.zero) {
          report =
              'failed: no picture decoded (${w}x$h at ${state.position}, '
              'completed ${state.completed})\n${logs.join('\n')}';
        } else {
          code = 0;
          report =
              'played ${state.position.inMilliseconds} ms of '
              '${state.duration.inMilliseconds} ms, ${w}x$h';
        }
        report = '$report\n$versions';
      } finally {
        await player.dispose();
      }
    }
  } on Object catch (e) {
    report = 'failed: $e';
  }
  await File(test.result).writeAsString('$report\n');
  return code;
}

/// Never called: only the web has `folder:` items.
Future<VideoPlayerController> folderVideo(ThumbnailItem item) =>
    throw UnsupportedError('no folder: items natively');

// A file name's extension.
final _type = RegExp(r'\.[^./]*$');

/// The first [limit] bytes of [item]'s file, or all of them, or of the file
/// beside it of its name with [extension]: a file's, or a MediaStore or
/// PhotoKit item's own through the viewer's channel; null for anything else.
Future<Uint8List?> bytesOf(
  ThumbnailItem item, {
  int? limit,
  String? extension,
}) async {
  final uri = item.uri;
  if (extension == null && (uri.isScheme('content') || uri.isScheme('ph'))) {
    return await const MethodChannel('org.photolib/viewer')
        .invokeMethod<Uint8List>('read', ['$uri', ?limit]);
  }
  if (!uri.isScheme('file')) return null;
  final path = uri.toFilePath();
  final file = File(
    extension == null ? path : path.replaceFirst(_type, '.$extension'),
  );
  // The root isolate does no synchronous I/O (tool/root_isolate_lint.dart).
  // ignore: avoid_slow_async_io
  if (!await file.exists()) return null;
  final opened = await file.open();
  try {
    return await opened.read(limit ?? await opened.length());
  } finally {
    await opened.close();
  }
}

/// video_player on libmpv through media_kit, for Windows and Linux
/// (docs/10 §4.2, ADR-0112). Unlike media_kit's own adapter, a file that
/// ends before its first picture, failing to open or with none that decodes,
/// fails the player's initialisation instead of leaving it waiting; errors
/// libmpv logs and gets past, such as a decoder it falls back from or a
/// damaged frame, do not.
/// libmpv draws the stored picture and Flutter turns it: libmpv's software
/// renderer, Linux's under Impeller, aborts on a turned video. A disposed
/// player is stopped and kept for the next video, never torn down: on Linux
/// media_kit_video frees its output while GTK and the raster thread still
/// use it, which hangs or crashes the app after a few dozen, and media_kit
/// destroys a player on the UI thread 5 s after its disposal.
/// On Linux media_kit_video renders libmpv's frames on GTK's main thread,
/// Flutter's UI thread, where libmpv's render waits for the frame's time:
/// asked for 50 ms early (video-timing-offset), it held the thread most of
/// every frame, and the screen showed a third of them.
class MpvPlayers extends VideoPlayerPlatform implements ProjectingPlayers {
  final _players = <int, _Mpv>{};
  final _kept = <_Mpv>[];
  var _ids = 0;

  /// Makes this the players' platform. libmpv loads with the first video,
  /// not at start; without it, every video says it cannot play. On Windows
  /// the licences of the libmpv and FFmpeg the app bundles join the others.
  static void register() {
    VideoPlayerPlatform.instance = MpvPlayers();
    if (defaultTargetPlatform == TargetPlatform.windows) {
      final dir = File(Platform.resolvedExecutable).parent.path;
      LicenseRegistry.addLicense(
        () => bundledNotices(File('$dir/libmpv-notices.txt')),
      );
    }
  }

  @override
  Future<void> init() async {}

  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async {
    MediaKit.ensureInitialized();
    final uri = Uri.parse(
      options.dataSource.uri ?? (throw ArgumentError('a player without a URI')),
    );
    final mpv = _kept.isEmpty ? _Mpv(Player()) : _kept.removeLast();
    final id = _ids++;
    _players[id] = mpv..listen();
    await mpv.player.native.setProperty('video-rotate', 'no');
    if (Platform.isLinux) {
      await mpv.player.native.setProperty('video-timing-offset', '0');
    }
    // The viewer shows a sidecar's captions itself (captionsOf).
    await mpv.player.native.setProperty('sub-auto', 'no');
    await mpv.player.open(
      Media(uri.isScheme('file') ? uri.toFilePath() : '$uri'),
      play: false,
    );
    await mpv.ended(opened: true);
    return id;
  }

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) =>
      _players[playerId]!.events.stream;

  @override
  Future<void> dispose(int playerId) async {
    final mpv = _players.remove(playerId);
    if (mpv == null) return;
    await mpv.stop();
    _kept.add(mpv);
  }

  Player _player(int id) => _players[id]!.player;

  @override
  Future<void> setLooping(int playerId, bool looping) =>
      _player(playerId)
          .setPlaylistMode(looping ? PlaylistMode.single : PlaylistMode.none);

  @override
  Future<void> play(int playerId) => _player(playerId).play();

  @override
  Future<void> pause(int playerId) => _player(playerId).pause();

  @override
  Future<void> setVolume(int playerId, double volume) =>
      _player(playerId).setVolume(volume * 100);

  @override
  Future<void> seekTo(int playerId, Duration position) =>
      _player(playerId).seek(position);

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) =>
      _player(playerId).setRate(speed);

  @override
  Future<Duration> getPosition(int playerId) async =>
      _player(playerId).state.position;

  @override
  Widget buildViewWithOptions(VideoViewOptions options) =>
      _MpvView(_players[options.playerId]!);

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {}
}

/// A player's pictures, turned as its file asks; a 360° video's projected by
/// libmpv through the filter of the [SphereProjection] above (ADR-0146), at
/// the size the filter says, and shown only once they are, never flat.
class _MpvView extends StatefulWidget {
  const new(this.mpv);

  final _Mpv mpv;

  @override
  State<_MpvView> createState() => _MpvViewState();
}

class _MpvViewState extends State<_MpvView> {
  @override
  Widget build(BuildContext context) {
    final mpv = widget.mpv;
    final filter = SphereProjection.of(context)?.filter ?? '';
    if (filter != mpv.filter) unawaited(mpv.project(filter));
    final video = RotatedBox(
      quarterTurns: mpv.turns,
      child: Video(
        controller: mpv.video,
        // media_kit_video's NoVideoControls, which is an untyped null.
        controls: null,
        // Filtered, the output is the size asked for, and fills the view.
        fit: filter.isEmpty ? BoxFit.contain : BoxFit.fill,
        fill: const Color(0x00000000),
        wakelock: false,
        pauseUponEnteringBackgroundMode: false,
      ),
    );
    return ValueListenableBuilder(
      valueListenable: mpv.filtered,
      builder: (context, filtered, _) =>
          filter.isEmpty || filtered ? video : const SizedBox.shrink(),
    );
  }
}

extension on Player {
  NativePlayer get native => switch (platform) {
    final NativePlayer native => native,
    _ => throw StateError('media_kit has no libmpv player'),
  };
}

class _Mpv {
  new(this.player)
    : video = VideoController(player, configuration: mpvVideoConfiguration()) {
    video.rect.addListener(_fit);
  }

  final Player player;
  final VideoController video;
  late StreamController<VideoEvent> events;
  var _subscriptions = <StreamSubscription<Object?>>[];
  bool initialized = false;

  /// Clockwise quarter turns the file asks for.
  int turns = 0;

  /// The video filter asked for, and the one libmpv has.
  String filter = '';
  String _applied = '';
  Future<void>? _projecting;

  /// Whether the pictures out are filtered: from the first after a filter
  /// is applied until there is none.
  final ValueNotifier<bool> filtered = ValueNotifier(false);

  /// Projects the pictures through [next], FFmpeg's v360 filter of a
  /// sphere's view, or none; once they are, the future completes. While
  /// libmpv changes its filters, only the newest asked for is applied next.
  /// Paused, libmpv filters the frame shown again.
  Future<void> project(String next) async {
    filter = next;
    if (_projecting case final projecting?) return await projecting;
    final done = Completer<void>();
    _projecting = done.future;
    try {
      while (_applied != filter) {
        final applying = filter;
        await player.native.setProperty(
          'vf',
          applying.isEmpty ? '' : '@sphere:$applying',
        );
        // media_kit_video sizes its output as the decoded picture, not the
        // filtered one.
        int? size(String name) => int.tryParse(
          RegExp('\\b$name=(\\d+)').firstMatch(applying)?.group(1) ?? '',
        );
        await video.setSize(width: size('w'), height: size('h'));
        _applied = applying;
      }
      // The first projected picture is out once its size is the filter's.
      final width = RegExp(r'\bw=(\d+)').firstMatch(filter)?.group(1);
      for (var i = 0; width != null && i < 100; i++) {
        final out = await player.native.getProperty('video-out-params/w');
        if (out == width) break;
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      filtered.value = _applied.isNotEmpty;
    } finally {
      _projecting = null;
      done.complete();
    }
  }

  var _fitted = false;

  /// Gives a picture larger than media_kit_video's software output, which
  /// takes at most 1920 × 1080 each way, an output of its own shape: libmpv
  /// letterboxed it in the clamped one, drawn small in its box.
  void _fit() {
    final (rect, p) = (video.rect.value, player.state.videoParams);
    final (w, h) = (p.dw ?? 0, p.dh ?? 0);
    if (rect == null || w == 0 || h == 0 || filter.isNotEmpty) return;
    final (cw, ch) = (min(w, 1920), min(h, 1080));
    if (rect.width != cw || rect.height != ch || w * ch == h * cw) return;
    final scale = min(1920 / w, 1080 / h);
    _fitted = true;
    unawaited(
      video.setSize(width: (w * scale).round(), height: (h * scale).round()),
    );
  }

  var _watching = false;

  /// Reports the events of the next file the player opens.
  void listen() {
    // The output attaches after the next frame, which an idle screen would
    // never draw; until it does, the player opens nothing.
    WidgetsBinding.instance.scheduleFrame();
    events = StreamController<VideoEvent>();
    initialized = _opened = false;
    _error = null;
    _watch();
    turns = 0;
    final s = player.stream;
    var size = Size.zero;
    var duration = Duration.zero;
    var video = true;
    void ready() {
      if (initialized || duration == Duration.zero) return;
      if (video && size == Size.zero) return;
      initialized = true;
      events.add(
        VideoEvent(
          eventType: VideoEventType.initialized,
          size: size,
          duration: duration,
        ),
      );
    }

    void after(VideoEvent event) {
      if (initialized) events.add(event);
    }

    _subscriptions = [
      s.duration.listen((d) {
        duration = d;
        ready();
      }),
      s.videoParams.listen((p) async {
        final (w, h) = ((p.dw ?? 0).toDouble(), (p.dh ?? 0).toDouble());
        if (w == 0 || h == 0 || size != Size.zero) return;
        final rotate = await player.native.getProperty(
          'video-dec-params/rotate',
        );
        turns = (int.tryParse(rotate) ?? 0) ~/ 90;
        size = turns.isOdd ? Size(h, w) : Size(w, h);
        ready();
      }),
      s.videoParams.listen((_) => _fit()),
      // Sound, and of pictures only "auto" and "no": the file has none.
      s.tracks.listen((t) {
        video = t.video.length > 2 || t.audio.length <= 2;
        ready();
      }),
      s.playing.listen(
        (playing) => after(
          VideoEvent(
            eventType: VideoEventType.isPlayingStateUpdate,
            isPlaying: playing,
          ),
        ),
      ),
      s.completed.listen((completed) {
        if (completed) after(VideoEvent(eventType: VideoEventType.completed));
      }),
      s.error.listen((error) => _error = error),
    ];
  }

  /// Whether the file being opened has been asked to play, and the last
  /// error libmpv logged since: also one it recovers from, such as a decoder
  /// it falls back from or a sound it plays without.
  var _opened = false;
  String? _error;

  /// Fails the file being opened once [opened] if it has ended before its
  /// first picture: with an error, which leaves libmpv idle, or at its end
  /// paused with no picture, as one none of whose pictures decodes does.
  Future<void> ended({bool opened = false}) async {
    _opened |= opened;
    if (!_opened || initialized || events.isClosed) return;
    final native = player.native;
    final ended =
        await native.getProperty('idle-active') == 'yes' ||
        await native.getProperty('eof-reached') == 'yes' &&
            (await native.getProperty('video-params/dw')).isEmpty;
    if (!ended || !_opened || initialized || events.isClosed) return;
    _opened = false;
    events.addError(
      // i18n-ok: video_player needs a message; it is logged, not shown
      PlatformException(code: 'mpv', message: _error ?? 'no picture decodes'),
    );
  }

  void _watch() {
    if (_watching) return;
    _watching = true;
    for (final property in ['idle-active', 'eof-reached']) {
      unawaited(player.native.observeProperty(property, (_) => ended()));
    }
  }

  /// Stops reporting and playing, for the player to be kept.
  Future<void> stop() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    await events.close();
    await player.stop();
    await project('');
    if (_fitted) {
      _fitted = false;
      await video.setSize();
    }
  }
}

/// Whether the browser can stream the server's HLS ladder, with its own player
/// or hls.js: never off the web.
bool get streamsHls => false;
