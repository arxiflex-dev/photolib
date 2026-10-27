import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/viewer/sphere.dart';
import 'package:photolib_data/browser.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
// video_player_web keeps the <video> elements its plugin makes to itself;
// BrowserPlayers makes them with its player, to show them to the shader.
// ignore: implementation_imports
import 'package:video_player_web/src/video_player.dart' as web_player;
import 'package:web/web.dart' as web;

/// The native app's self-test (mpv.dart); the web has none.
typedef SelfTest = ({String video, String result});

/// Never asked for on the web.
SelfTest? selfTestOf(List<String> args) => null;

/// Never called: [selfTestOf] is null on the web.
Future<int> runSelfTest(SelfTest test) =>
    throw UnsupportedError('no self-test on the web');

/// A player of [item], a file of a folder the browser lets the app read
/// (`folder:`).
Future<VideoPlayerController> folderVideo(ThumbnailItem item) async {
  final [root, ...path] = item.uri.pathSegments;
  return BlobPlayer(
    await browserFile(root, path.join('/')) ??
        (throw StateError('the browser has no file of $item')),
  );
}

/// The first [limit] bytes of [item]'s file in its browser folder, or all of
/// them, or of the file beside it of its name with [extension]; null for
/// anything else.
Future<Uint8List?> bytesOf(
  ThumbnailItem item, {
  int? limit,
  String? extension,
}) async {
  if (!item.uri.isScheme('folder')) return null;
  final [root, ...segments] = item.uri.pathSegments;
  final path = segments.join('/');
  final file = await browserFile(
    root,
    extension == null
        ? path
        : path.replaceFirst(RegExp(r'\.[^./]*$'), '.$extension'),
  );
  if (file == null) return null;
  final blob = limit == null ? file : file.slice(0, limit);
  return (await blob.arrayBuffer().toDart).toDart.asUint8List();
}

/// A player of a blob by an object URL of it, which its disposal revokes.
class BlobPlayer extends VideoPlayerController {
  /// Plays [blob].
  new(web.Blob blob) : this._(web.URL.createObjectURL(blob));
  new _(this._url) : super.networkUrl(Uri.parse(_url));

  final String _url;

  @override
  Future<void> dispose() async {
    await super.dispose();
    web.URL.revokeObjectURL(_url);
  }
}

/// The web plays through video_player's own player, the browser's.
abstract final class MpvPlayers {
  /// Makes [BrowserPlayers] the players' platform.
  static void register() => VideoPlayerPlatform.instance = BrowserPlayers();
}

/// The browser's players, as video_player_web's plugin makes them, which
/// also hand each view's `<video>` element to a [SphereProjection] above,
/// for the sphere shader (ADR-0146): the element, kept here, needs no view
/// created first.
class BrowserPlayers extends VideoPlayerPlatform {
  final _players = <int, (web.HTMLVideoElement, web_player.VideoPlayer)>{};
  final _streams = <int, _Hls>{};
  var _ids = 0;

  web_player.VideoPlayer _player(int id) =>
      _players[id]?.$2 ?? (throw StateError('no player $id'));

  @override
  Future<void> init() async {}

  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async {
    final uri =
        options.dataSource.uri ?? (throw ArgumentError('a player without URI'));
    final id = _ids++;
    final element = web.HTMLVideoElement()
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%';
    ui_web.platformViewRegistry.registerViewFactory(
      'videoPlayer-$id',
      (int _) => element,
    );
    final player = web_player.VideoPlayer(videoElement: element);
    _players[id] = (element, player);
    if (uri.endsWith('.m3u8') || uri.contains('.m3u8?')) {
      if (!nativeHls && await _loadHls()) {
        _streams[id] = _newHls();
        player.initialize();
        _streams[id]!
          ..loadSource(uri)
          ..attachMedia(element);
        return id;
      }
    }
    player.initialize(src: uri);
    return id;
  }

  @override
  Future<void> dispose(int playerId) async {
    _streams.remove(playerId)?.destroy();
    _players.remove(playerId)?.$2.dispose();
  }

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) => _player(playerId).events;

  @override
  Future<void> setLooping(int playerId, bool looping) async =>
      _player(playerId).setLooping(looping);

  @override
  Future<void> play(int playerId) => _player(playerId).play();

  @override
  Future<void> pause(int playerId) async => _player(playerId).pause();

  @override
  Future<void> setVolume(int playerId, double volume) async =>
      _player(playerId).setVolume(volume);

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async =>
      _player(playerId).setPlaybackSpeed(speed);

  @override
  Future<void> seekTo(int playerId, Duration position) async =>
      _player(playerId).seekTo(position);

  @override
  Future<Duration> getPosition(int playerId) async =>
      _player(playerId).getPosition();

  @override
  Future<void> setWebOptions(int playerId, VideoPlayerWebOptions options) =>
      _player(playerId).setOptions(options);

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {}

  @override
  Widget buildViewWithOptions(VideoViewOptions options) {
    final element = _players[options.playerId]?.$1;
    return Builder(
      builder: (context) {
        final take = SphereProjection.of(context)?.onElement;
        if (element != null && take != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => take(element));
        }
        return HtmlElementView(viewType: 'videoPlayer-${options.playerId}');
      },
    );
  }
}

/// Whether the browser's HLS is Safari's, which has played it for years and
/// needs no script; Chrome's is too new to rely on, and Firefox has none.
bool get nativeHls =>
    web.HTMLVideoElement().canPlayType('application/vnd.apple.mpegurl') != '' &&
    !web.window.navigator.userAgent.contains('Chrome') &&
    // WebKit's GTK build, which Playwright drives, plays HLS through
    // GStreamer and crashes: only Apple's Safari is native.
    web.window.navigator.userAgent.contains('Mac OS X');

/// Whether the browser streams the server's ladder: Safari by itself, any
/// other with Media Source Extensions through hls.js.
bool get streamsHls => nativeHls || globalContext.has('MediaSource');

/// hls.js's player, which feeds a `<video>` from a playlist through MSE.
@JS('Hls')
extension type _Hls(JSObject _) implements JSObject {
  external static bool isSupported();
  external void loadSource(String url);
  external void attachMedia(web.HTMLMediaElement element);
  external void destroy();
}

Future<void>? _hlsScript;

/// Loads hls.js (tools/hls/web.sh) once, when a video first needs it; whether
/// this browser can run it.
Future<bool> _loadHls() async {
  if (!globalContext.has('Hls')) {
    final loaded = Completer<void>();
    web.document.head?.append(
      web.HTMLScriptElement()
        ..src = 'hls.min.js'
        ..onload = ((web.Event _) => loaded.complete()).toJS
        ..onerror = ((web.Event _) => loaded.completeError('no hls.js')).toJS,
    );
    await (_hlsScript ??= loaded.future);
  }
  return _Hls.isSupported();
}

/// A player, made with the script's `new Hls()`.
_Hls _newHls() => _Hls(
  globalContext
      .getProperty<JSFunction>('Hls'.toJS)
      .callAsConstructor<JSObject>(),
);
