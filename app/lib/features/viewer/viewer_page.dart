import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart'
    show ValueListenable, defaultTargetPlatform, kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/logging.dart';
import 'package:photolib/features/desktop/file_drag.dart';
import 'package:photolib/features/download/download_action.dart';
import 'package:photolib/features/editor/editor_page.dart';
import 'package:photolib/features/editor/save_copy.dart';
import 'package:photolib/features/editor/versions.dart';
import 'package:photolib/features/folders/folders_page.dart'
    show addToChosenAlbum;
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/edit_with_ui.dart';
import 'package:photolib/features/gallery/wallpaper_page.dart';
import 'package:photolib/features/library/deletion.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/offline/offline.dart';
import 'package:photolib/features/servers/servers.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib/features/settings/settings_page.dart' show ToolbarPage;
import 'package:photolib/features/trash/trash.dart';
import 'package:photolib/features/viewer/animated.dart';
import 'package:photolib/features/viewer/attitude.dart';
import 'package:photolib/features/viewer/deep_zoom.dart';
import 'package:photolib/features/viewer/gestures.dart';
import 'package:photolib/features/viewer/handoff.dart';
import 'package:photolib/features/viewer/hdr_leaf.dart';
import 'package:photolib/features/viewer/info_facts.dart';
import 'package:photolib/features/viewer/info_panel.dart';
import 'package:photolib/features/viewer/info_sections.dart' show HistoryList;
import 'package:photolib/features/viewer/photo_text.dart';
import 'package:photolib/features/viewer/regions.dart';
import 'package:photolib/features/viewer/screen.dart';
import 'package:photolib/features/viewer/slideshow.dart';
import 'package:photolib/features/viewer/sphere.dart';
import 'package:photolib/features/viewer/sphere_cues.dart';
import 'package:photolib/features/viewer/sphere_frame.dart';
import 'package:photolib/features/viewer/toolbar.dart';
import 'package:photolib/features/viewer/video.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/adaptive.dart';
import 'package:photolib/ui/commands.dart';
import 'package:photolib/ui/motion.dart';
import 'package:photolib/ui/swipe_to_dismiss.dart';
import 'package:photolib/ui/theme.dart';
import 'package:photolib_api/kernel.dart' show CaptureTime;
import 'package:photolib_data/photolib_data.dart'
    show LocalAssetData, OfflinePin, rawExtensions;
import 'package:video_player/video_player.dart';

/// Opens [items] in the viewer at [at], its photo flying in from the whole
/// screen: items another app or the file manager opened, outside the
/// library's timeline.
Future<void> openInViewer(
  BuildContext context,
  WidgetRef ref,
  List<ThumbnailItem> items, {
  int at = 0,
  bool readOnly = false,
}) {
  final thumbnails = Thumbnails((item, tier, tile) async {
    final pipeline = await ref.read(thumbnailPipelineProvider.future);
    return await pipeline.load(item as ThumbnailItem, tier, tile);
  }, video: (item) => (item as ThumbnailItem).video);
  final pages = TimelinePages(
    (first, count) async =>
        items.sublist(first, min(first + count, items.length)),
  );
  return Navigator.of(context, rootNavigator: true)
      .push(
        ViewerPage.route(
          () => Offset.zero & MediaQuery.sizeOf(context),
          ViewerPage(
            pages: pages,
            count: items.length,
            position: ValueNotifier(at),
            thumbnails: thumbnails,
            readOnly: readOnly,
          ),
        ),
      )
      .whenComplete(() {
        thumbnails.clear();
        pages.dispose();
      });
}

/// The viewer (docs/10 §4.1, VIEW-09, VIEW-12): the [count] items of a
/// timeline's [pages], from [position] on, which it moves. An item shows the
/// grid's thumbnail at once, then its screen-size image, and zooms deep into
/// tiles with pinches, double taps and the keyboard; its neighbours preload
/// at screen size, one each side on phones and two on wider windows. A video
/// plays (docs/10 §4.2), its neighbours ready, every player made and disposed
/// only once the viewer has opened and its pages rest; a motion or Live Photo
/// plays its video while pressed (§4.3). A photo sphere or 360° video, as its
/// metadata says, opens projected and rotatable, a ring and a slow turn
/// saying so: drags turn it and the arrows, keys and filmstrip page past it
/// (§4.4, §4.6); a flat panorama shows as a strip the
/// height of the screen, which drags pan. An HDR item shows through a native
/// leaf where the platform has one and HDR is on (§4.5). A swipe down closes
/// it, a swipe up shows the info, a tap hides the controls; a filmstrip is on
/// by default beyond phones.
class ViewerPage extends ConsumerStatefulWidget {
  const ViewerPage({
    super.key,
    required this.pages,
    required this.count,
    required this.position,
    required this.thumbnails,
    this.readOnly = false,
  });

  final TimelinePages pages;
  final int count;
  final ValueNotifier<int> position;

  /// The grid's, which the viewer shows first and in its filmstrip.
  final Thumbnails thumbnails;

  /// Whether the items are only looked at: no actions, no info. The camera's
  /// review over the lock screen (REVIEW_SECURE, ADR-0401) is.
  final bool readOnly;

  /// A route whose page is laid out as it ends from its first frame, the
  /// photo flying from [from], an item's cell on the screen, while the rest
  /// fades in, and back into the cell of the item shown on the way out
  /// (docs/10 §4.1: the hero flight into the viewer).
  static Route<void> route(Rect Function() from, ViewerPage page) =>
      _ViewerRoute(from, page);

  @override
  ConsumerState<ViewerPage> createState() => _ViewerPageState();
}

const _log = Logger('photolib.viewer');

/// The screen-size decode a finger's touch on a cell starts, which the
/// viewer it opens takes over, so that the decode runs while the finger is
/// still down (docs/10 §4.6).
class EarlyDecode {
  (String, int, Future<ui.Image>)? _pending;

  /// Decodes [item] at [tier] with [load], dropping the one before, which a
  /// press that opened nothing left.
  void start(ThumbnailItem item, int tier, Future<ui.Image> Function() load) {
    if (_pending case (final key, final t, _)
        when key == item.key && t == tier) {
      return;
    }
    if (_pending case (_, _, final image)) {
      image.then((i) => i.dispose(), onError: (Object _) {}).ignore();
    }
    _pending = (item.key, tier, load()..ignore());
  }

  /// The decode of [item] at [tier] under way, which the caller now owns.
  Future<ui.Image>? take(ThumbnailItem item, int tier) {
    if (_pending case (final key, final t, final image)
        when key == item.key && t == tier) {
      _pending = null;
      return image;
    }
    return null;
  }
}

/// The app's [EarlyDecode].
final Provider<EarlyDecode> earlyDecodeProvider = Provider(
  (ref) => EarlyDecode(),
);

/// Starts decoding item [at] of [pages] at screen size as a finger touches
/// its cell, for the viewer a tap opens.
void decodeOnTouch(
  BuildContext context,
  WidgetRef ref,
  TimelinePages pages,
  int at,
) {
  final tier = screenTier(context);
  if (pages[at] case final ThumbnailItem item) {
    ref
        .read(earlyDecodeProvider)
        .start(
          item,
          tier,
          () => ref
              .read(thumbnailPipelineProvider.future)
              .then((pipeline) => pipeline.load(item, tier, Tile())),
        );
  }
}

/// The tier of an image as large as the screen: its short side in pixels, in
/// steps of 256.
int screenTier(BuildContext context) =>
    (MediaQuery.sizeOf(context).shortestSide *
            MediaQuery.devicePixelRatioOf(context) /
            256)
        .ceil() *
    256;

class _ViewerRoute extends PageRoute<void> {
  new(this.from, this.page);

  final Rect Function() from;
  final ViewerPage page;

  /// How far the flight has come: eased, but as a swipe down drags it until
  /// it rests (M1-52). Unlike [animation], never complete while the route
  /// is offstage for its heroes to be measured.
  late final CurvedAnimation shown;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Motion.medium;

  @override
  AnimationController createAnimationController() {
    final controller = super.createAnimationController()
      ..addStatusListener((status) {
        if (!status.isAnimating) {
          shown
            ..curve = Motion.curve
            ..reverseCurve = Motion.curve.flipped;
        }
      });
    shown = CurvedAnimation(
      parent: controller,
      curve: Motion.curve,
      reverseCurve: Motion.curve.flipped,
    );
    return controller;
  }

  /// Holds the flight [progress] of the way back into the cell.
  void drag(double progress) {
    if (progress == 0 && shown.curve == Motion.curve) return;
    _follow();
    controller?.value = 1 - progress;
  }

  /// Has the flight follow a gesture as it goes, until it rests.
  void _follow() => shown
    ..curve = Curves.linear
    ..reverseCurve = null;

  // Android's back gesture drives the flight as a drag does.
  @override
  void handleStartBackGesture({double progress = 0}) {
    _follow();
    super.handleStartBackGesture(progress: progress);
  }

  @override
  void handleUpdateBackGestureProgress({required double progress}) {
    _follow();
    super.handleUpdateBackGestureProgress(progress: progress);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> _,
    Animation<double> _,
  ) => page;

  /// Under reduce motion, a cross-fade; else the page flies its photo.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> _,
    Widget child,
  ) => Motion.reduced(context)
      ? FadeTransition(opacity: animation, child: child)
      : child;

  @override
  void dispose() {
    shown.dispose();
    super.dispose();
  }
}

class _ViewerPageState extends ConsumerState<ViewerPage>
    with WidgetsBindingObserver {
  // The pager pages over a window of items from _base, moved to centre the
  // item shown once it rests far from there: over a whole library, a
  // fractional page width fails the fixed extent's rounding check.
  static const _span = 50;
  late var _base = _baseFor(_at);
  late final _pager = PageController(initialPage: _at - _base);
  // The best image of each item within reach, and those at screen size.
  final _images = <int, ui.Image>{};
  final _sharp = <int>{}, _loading = <int>{};
  // What cancels each load under way.
  final _cancels = <int, Completer<void>>{};
  // Why the items within reach that have no image have none.
  final _failed = <int, Object>{};
  final _photos = <int, GlobalKey<_PhotoState>>{};
  final _players = VideoPlayers();
  // Where each sphere seen is looked at, and was before its little planet
  // or fisheye.
  final _views = <String, ValueNotifier<SphereView>>{};
  final _before = <String, SphereView>{};
  // The quarter turns of each photo the user rotated, by key.
  final _turns = <String, int>{};
  // The device's motion turning the sphere shown, while asked; it reads the
  // sensors only while the app is in front and no route covers the viewer.
  SphereMotion? _motion;
  late final AppLifecycleListener _lifecycle;
  var _covered = false;
  var _zoomed = false, _chrome = true, _info = false, _scrolling = false;
  // Whether the info shows its edit history; the faces it outlines; while
  // a version is compared, what showed before it.
  final ValueNotifier<bool> _history = ValueNotifier(false);
  final ValueNotifier<List<InfoFace>> _outlined = ValueNotifier(const []);
  (ThumbnailItem?,)? _compared;
  // Presses and wheel turns on the stage, which stop a sphere's slow turn.
  final ValueNotifier<int> _touches = ValueNotifier(0);
  // Whether the item shown is a sphere, whose drags turn it.
  var _sphere = false;
  // Whether a slideshow shows instead.
  var _away = false;
  // The HDR setting, as the last build read it.
  var _showHdr = true;
  // Whether the item shown has been sharp, or failed: until then, the
  // filmstrip decodes nothing.
  final _opened = ValueNotifier(false);
  // One widget, so that the page's builds do not build the strip's cells.
  late final _strip = _Filmstrip(
    pages: widget.pages,
    count: widget.count,
    position: widget.position,
    thumbnails: widget.thumbnails,
    after: _opened,
    copies: _copies,
    onTap: _go,
  );
  Animation<double>? _opening;
  _ViewerRoute? _route;
  // Whether the flight that opened the viewer has landed: until then the
  // item shown has no neighbour, and a sphere no page.
  var _landed = false;
  // Where a mouse pressed on the item shown, until it drags the file out.
  Offset? _press;
  // The item an edge pressed last leads to: -1 before, 1 after, 0 none.
  var _edge = 0;
  // The pages' size; whether side drags set the brightness and volume of
  // the item shown, and its player; while one does, what it sets and to
  // what.
  Size _area = Size.zero;
  var _swipes = false;
  VideoPlayerController? _player;
  (IconData, double)? _level;
  // The window's brightness, where the viewer sets it: as last known, and
  // whether the viewer set it.
  late final ScreenBrightness? _screen = ref.read(screenBrightnessProvider);
  double? _bright;
  var _brightened = false;
  // Whether the viewer turned the device to landscape, or to portrait.
  bool? _landscape;
  // The copies saved by the editor, shown in place of what they copy.
  final _copies = ValueNotifier<Map<int, ThumbnailItem>>({});
  // What the viewer says for a moment, and when it stops.
  String? _notice;
  Timer? _hide;
  // Where a mouse is over the stage and whether it moved in the last 1.8 s,
  // for the arrows; and the timer of its rest.
  final _pointer = ValueNotifier<(Offset?, bool)>((null, false));
  Timer? _resting;
  // The player of the video shown and whether it plays, which hides the
  // chrome when idle (docs/10 §4.6); whether it did, whether the pointer is
  // on a control and whether a menu is open, which keep it; the idle timer.
  VideoPlayerController? _watched;
  var _playing = false;
  var _playbackHid = false;
  var _onControl = false;
  var _menuOpen = false;
  Timer? _idle;
  // The bar's `⋮` and the dial's lenses, which Escape closes before the
  // viewer.
  final _more = MenuController();
  final _lensMenu = MenuController();

  ThumbnailItem? _itemAt(int p) =>
      _copies.value[p] ?? widget.pages[p] as ThumbnailItem?;

  int get _at => widget.position.value;

  void _dragOut(PointerMoveEvent event) {
    final press = _press;
    if (press == null ||
        _zoomed ||
        (event.position - press).distance <
            computePanSlop(PointerDeviceKind.mouse, null)) {
      return;
    }
    _press = null;
    if (_itemAt(_at) case final item? when item.uri.isScheme('file')) {
      // The platform's drag takes the mouse from here.
      GestureBinding.instance.cancelPointer(event.pointer);
      unawaited(ref.read(fileDragProvider)?.call([item.uri.toFilePath()]));
    }
  }

  @override
  void initState() {
    super.initState();
    widget.pages.addListener(_changed);
    final item = _itemAt(_at);
    _log.info(
      'viewer opened',
      fields: {
        'position': _at,
        'of': widget.count,
        'file': '$item',
        // No player yet: a video shows its poster frame.
        'video': ?item?.video,
      },
    );
    _players.addListener(() => setState(() {}));
    WidgetsBinding.instance.addObserver(this);
    _lifecycle = AppLifecycleListener(onStateChange: (_) => _sense());
    ref.listenManual(
      settingsProvider.select((s) => s.isOn(Toggle.maxBrightness)),
      (_, on) => _brighten(on ? 1 : null),
      fireImmediately: true,
    );
  }

  // Android's back gesture flies the item back as a swipe down does (docs/10
  // §4.6).
  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    final route = _route;
    if (route == null ||
        backEvent.isButtonEvent ||
        !route.isCurrent ||
        !route.popGestureEnabled) {
      return false;
    }
    route.handleStartBackGesture(progress: 1 - backEvent.progress);
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) =>
      _route?.handleUpdateBackGestureProgress(progress: 1 - backEvent.progress);

  @override
  void handleCancelBackGesture() => _route?.handleCancelBackGesture();

  @override
  void handleCommitBackGesture() => _route?.handleCommitBackGesture();

  /// Sets the window's brightness, or with null gives it back.
  void _brighten(double? to) {
    if (_screen == null || to == null && !_brightened) return;
    _brightened = to != null;
    _bright = to ?? _bright;
    unawaited(_screen.set(to));
  }

  /// Turns a phone to [row]'s orientation, its width and height turned as
  /// its orientation says.
  void _orient(LocalAssetData? row) {
    final (w, h) = (row?.width, row?.height);
    if (kIsWeb ||
        w == null ||
        h == null ||
        !const {
          TargetPlatform.android,
          TargetPlatform.iOS,
        }.contains(defaultTargetPlatform)) {
      return;
    }
    final landscape =
        (w > h) != (row?.orientation == 90 || row?.orientation == 270);
    if (landscape == _landscape) return;
    _landscape = landscape;
    unawaited(
      SystemChrome.setPreferredOrientations(
        landscape
            ? [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]
            : [DeviceOrientation.portraitUp],
      ),
    );
  }

  /// Whether a vertical drag from [at] sets the brightness, from the left
  /// third of a video, or its volume, from the right third. A press where
  /// it sets the brightness reads it, which comes before the drag starts.
  bool _slides(Offset at) {
    if (!_swipes) return false;
    // i18n-ok: brightness is on the left and volume on the right in every
    // player
    if (at.dx > _area.width * 2 / 3) return _player != null;
    final screen = _screen;
    if (at.dx >= _area.width / 3 || screen == null) return false;
    if (_bright == null) unawaited(screen.get().then((b) => _bright ??= b));
    return true;
  }

  /// The side drags of a video, which set its brightness and volume.
  Map<Type, GestureRecognizerFactory> _sideDrags() => {
    SideDrag: GestureRecognizerFactoryWithHandlers<SideDrag>(
      () => SideDrag(allowed: _slides, debugOwner: this),
      (drag) => drag
        ..gestureSettings = MediaQuery.maybeGestureSettingsOf(context)
        ..onStart = _slideStart
        ..onUpdate = _slide
        ..onEnd = (_) => setState(() => _level = null),
    ),
  };

  void _slideStart(DragStartDetails details) {
    final brightness = details.localPosition.dx < _area.width / 2;
    setState(
      () => _level = brightness
          ? (Icons.brightness_6, _bright ?? 0.5)
          : (Icons.volume_up, _player?.value.volume ?? 1),
    );
  }

  void _slide(DragUpdateDetails details) {
    final (icon, value) = _level ?? (Icons.volume_up, 1.0);
    final to = (value - details.delta.dy / _area.height).clamp(0.0, 1.0);
    setState(() => _level = (icon, to));
    if (icon == Icons.volume_up) {
      unawaited(_player?.setVolume(to));
    } else {
      _brighten(to);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    final opening = route is _ViewerRoute ? route.shown : route?.animation;
    if (opening != _opening) {
      _opening?.removeStatusListener(_moved);
      _opening = opening?..addStatusListener(_moved);
      _route = route is _ViewerRoute ? route : null;
      _landed |= opening?.isCompleted ?? true;
    }
    _covered = !(route?.isCurrent ?? true);
    _sense();
    _rest();
    _preload();
  }

  @override
  void dispose() {
    _brighten(null);
    if (_landscape != null) {
      unawaited(SystemChrome.setPreferredOrientations(const []));
    }
    WidgetsBinding.instance.removeObserver(this);
    widget.pages.removeListener(_changed);
    _opening?.removeStatusListener(_moved);
    _players.dispose();
    _lifecycle.dispose();
    _motion?.dispose();
    for (final view in _views.values) {
      view.dispose();
    }
    for (final image in _images.values) {
      image.dispose();
    }
    _pager.dispose();
    _opened.dispose();
    _copies.dispose();
    _hide?.cancel();
    _resting?.cancel();
    _pointer.dispose();
    _touches.dispose();
    _history.dispose();
    _outlined.dispose();
    _idle?.cancel();
    _watched?.removeListener(_playback);
    super.dispose();
  }

  /// Follows [player], the video shown's, as it plays and pauses.
  void _watch(VideoPlayerController? player) {
    if (player == _watched) return;
    _watched?.removeListener(_playback);
    _watched = player?..addListener(_playback);
    _playing = player?.value.isPlaying ?? false;
    _idleIn(const Duration(milliseconds: 1500));
  }

  void _playback() {
    final playing = _watched?.value.isPlaying ?? false;
    if (playing == _playing) return;
    _playing = playing;
    if (playing) return _idleIn(const Duration(milliseconds: 1500));
    _idle?.cancel();
    if (_playbackHid) setState(() => _chrome = true);
  }

  /// Hides the chrome [after] this long, unless the video stops playing,
  /// the pointer moves or rests on a control, or a menu opens.
  void _idleIn(Duration after) {
    _idle?.cancel();
    if (!_playing) return;
    _idle = Timer(after, () {
      if (!mounted || !_playing || _onControl || _menuOpen || !_chrome) {
        return;
      }
      setState(() => _chrome = !(_playbackHid = true));
    });
  }

  void _hovered(PointerHoverEvent event) {
    if (_playing) {
      if (!_chrome) setState(() => _chrome = true);
      _idleIn(const Duration(milliseconds: 1500));
    }
    _pointer.value = (event.localPosition, true);
    _resting?.cancel();
    _resting = Timer(
      const Duration(milliseconds: 1800),
      () => _pointer.value = (_pointer.value.$1, false),
    );
  }

  void _left(PointerExitEvent _) {
    _idleIn(const Duration(milliseconds: 300));
    _resting?.cancel();
    _pointer.value = (null, false);
  }

  void _changed() => setState(_preload);

  /// Whether the route has grown to the screen, which a video's controls and
  /// captions wait for, as they leave when it shrinks back; no native view
  /// flies with it.
  bool get _grown => _opening?.isCompleted ?? true;

  void _moved(AnimationStatus status) {
    if (mounted) setState(() => _landed |= status.isCompleted);
    _rest();
  }

  void _rest() => _players.still = !_scrolling && _grown;

  /// Whether [row]'s item has an HDR leaf here: a sphere is projected
  /// instead, and a browser plays an HDR video in HDR by itself.
  bool _hdrItem(LocalAssetData? row) =>
      hdrLeaves &&
      isHdr(row) &&
      Sphere.of(row) == null &&
      !(kIsWeb && (row?.mime ?? '').startsWith('video/'));

  /// Whether [row]'s item shows in HDR.
  bool _hdr(LocalAssetData? row) => _showHdr && _hdrItem(row);

  /// The player of [item]'s video, another while it plays in HDR.
  String _videoKey(ThumbnailItem item, LocalAssetData? row) =>
      _hdr(row) ? '${item.key} hdr' : item.key;

  /// Keeps the images of the items within reach, loading those not yet at
  /// screen size: the viewport's short side in pixels, in steps of 256.
  void _preload() {
    final size = MediaQuery.sizeOf(context);
    final tier = screenTier(context);
    final reach = WindowSize.of(size.width) == WindowSize.compact ? 1 : 2;
    bool near(int p) => (p - _at).abs() <= reach;
    for (final p in [..._images.keys]) {
      if (!near(p)) {
        _images.remove(p)!.dispose();
        _sharp.remove(p);
      }
    }
    _photos.removeWhere((p, _) => !near(p));
    _cancels.removeWhere((p, cancel) {
      if (near(p)) return false;
      if (!cancel.isCompleted) cancel.complete();
      _loading.remove(p);
      return true;
    });
    _failed.removeWhere((p, _) => !near(p));
    for (
      var p = max(0, _at - reach);
      p <= min(widget.count - 1, _at + reach);
      p++
    ) {
      final item = _itemAt(p);
      if (item == null) continue;
      if (!_images.containsKey(p)) {
        for (final t in const [1024, 512, 256, 128]) {
          if (widget.thumbnails.get(item, t) case final thumbnail?) {
            _images[p] = thumbnail.clone();
            break;
          }
        }
      }
      if (_sharp.contains(p) || !_loading.add(p)) continue;
      _load(p, item, tier, near);
    }
    if (_sharp.contains(_at)) _opened.value = true;
  }

  /// Loads [item], at [p], at [tier], and a RAW's embedded preview meanwhile,
  /// for as long as it is [near].
  void _load(int p, ThumbnailItem item, int tier, bool Function(int) near) {
    final took = Stopwatch()..start();
    final pipeline = ref.read(thumbnailPipelineProvider.future);
    if (item.uri.isScheme('file') &&
        rawExtensions.contains(item.uri.path.split('.').last.toLowerCase())) {
      pipeline
          .then((pipeline) => pipeline.preview(item, tier))
          .then((image) => image == null ? null : _sharpen(p, image, near))
          .ignore();
    }
    // Dropped once the item is out of reach, as a fast swipe leaves it.
    final cancel = _cancels[p] = Completer<void>();
    (ref.read(earlyDecodeProvider).take(item, tier) ??
            pipeline.then(
              (pipeline) => pipeline.load(item, tier, Tile(cancel)),
            ))
        .then(
          (image) {
            _loading.remove(p);
            _log.debug(
              'screen-size image',
              fields: {
                'file': '$item',
                'tier': tier,
                'size': '${image.width}x${image.height}',
                'ms': took.elapsedMilliseconds,
              },
            );
            _sharpen(p, image, near);
          },
          onError: (Object error) {
            _log.warning(
              'no screen-size image',
              fields: {'file': '$item', 'tier': tier},
              error: error,
            );
            _loading.remove(p);
            if (!mounted) return;
            if (near(p)) setState(() => _failed[p] = error);
            if (p == _at) _opened.value = true;
          },
        );
  }

  /// Shows [image] at screen size, unless a larger one is: a RAW's embedded
  /// preview can beat its decode.
  void _sharpen(int p, ui.Image image, bool Function(int) near) {
    final kept = _images[p];
    if (!mounted ||
        !near(p) ||
        _sharp.contains(p) &&
            kept != null &&
            image.width * image.height <= kept.width * kept.height) {
      return image.dispose();
    }
    setState(() {
      _images.remove(p)?.dispose();
      _images[p] = image;
      _sharp.add(p);
    });
    if (p == _at) _opened.value = true;
  }

  int get _window => min(widget.count, 2 * _span + 1);

  int _baseFor(int at) => (at - _span).clamp(0, widget.count - _window);

  void _jump(int to) {
    setState(() => _base = _baseFor(to));
    _pager.jumpToPage(to - _base);
  }

  bool _rested(ScrollEndNotification end) {
    if (end.depth == 0 && (_baseFor(_at) - _base).abs() > _span ~/ 2) {
      // Not while the pager ends its scroll activity.
      Future.microtask(() => mounted ? _jump(_at) : null);
    }
    return false;
  }

  void _go(int to) {
    if (to < 0 || to >= widget.count || to == _at) return;
    final (duration, page) = (Motion.of(context), to - _base);
    // A neighbour slides in, unless it is past the window's end.
    if (duration == Duration.zero ||
        (to - _at).abs() > 1 ||
        page < 0 ||
        page >= _window) {
      _jump(to);
    } else {
      _pager.animateToPage(page, duration: duration, curve: Motion.curve);
    }
  }

  void _close() => Navigator.maybePop(context);

  /// Goes to the item an edge leads to, else shows or hides the controls.
  /// Goes to the item an edge leads to, else plays or pauses [key]'s video.
  void _tapVideo(String key) {
    if (_edge != 0 && ref.read(settingsProvider).isOn(Toggle.edgeTaps)) {
      return _go(_at + _edge);
    }
    _players.toggle(key);
  }

  void _tap() {
    if (_edge != 0 &&
        !_zoomed &&
        !_sphere &&
        ref.read(settingsProvider).isOn(Toggle.edgeTaps)) {
      return _go(_at + _edge);
    }
    setState(() => _chrome = !_chrome);
  }

  /// Notes the item a press at [x] of [width] leads to: the fifth at each
  /// side is an edge, before or after as the pages read.
  void _pressed(double x, double width) {
    final side = x < width / 5 ? -1 : (x > width * 4 / 5 ? 1 : 0);
    // i18n-ok: the pages run right to left in a right-to-left language
    _edge = Directionality.of(context) == TextDirection.rtl ? -side : side;
  }

  /// Plays the items from the one shown, then shows the one it played last.
  Future<void> _slideshow() async {
    setState(() => _away = true);
    final last = await SlideshowPage.show(
      context,
      SlideshowPage(pages: widget.pages, count: widget.count, start: _at),
    );
    if (!mounted) return;
    setState(() => _away = false);
    if (last != null) _jump(last);
  }

  /// Edits the item shown and, once saved, shows its copy in its place
  /// (ADR-0331).
  Future<void> _edit(ThumbnailItem item, LocalAssetData? row) async {
    final (at, image) = (_at, _images[_at]);
    if (image == null) return;
    final local = row?.takenLocal;
    final time = local == null
        ? null
        : CaptureTime(localDatetime: local, offsetMinutes: row?.tzOffsetMin);
    final asVersion = canEditVersion(
      item,
      signedIn: ref.read(sessionProvider) != null,
    );
    final copy = await Navigator.of(context).push<ThumbnailItem>(
      MaterialPageRoute(
        builder: (_) => EditorPage(
          item: item,
          image: image.clone(),
          time: time,
          asVersion: asVersion,
        ),
      ),
    );
    if (copy == null || !mounted) return;
    final strings = AppLocalizations.of(context);
    final saved = asVersion ? strings.editorVersionSaved : strings.editorSaved;
    if (asVersion) {
      // A version replaces nothing here: the server renders it and sync
      // brings the new tiles, which the viewer shows in the item's place.
      setState(() => _notice = saved);
      _hide?.cancel();
      _hide = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _notice = null);
      });
      return;
    }
    setState(() {
      _copies.value = {..._copies.value, at: copy};
      _images.remove(at)?.dispose();
      _sharp.remove(at);
      _failed.remove(at);
      _photos.remove(at);
      _notice = saved;
      _preload();
    });
    _hide?.cancel();
    _hide = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _notice = null);
    });
  }

  /// Hands the item shown to another app's editor and shows the copy it
  /// makes in the item's place (MOB-13, ADR-0401).
  Future<void> _editWith(ThumbnailItem item, LocalAssetData? row) async {
    final at = _at;
    final copy = await editWithOther(context, ref, item, row?.mime);
    if (copy == null || !mounted) return;
    setState(() {
      _copies.value = {..._copies.value, at: copy};
      _images.remove(at)?.dispose();
      _sharp.remove(at);
      _failed.remove(at);
      _photos.remove(at);
      _notice = AppLocalizations.of(context).editorSaved;
      _preload();
    });
    _hide?.cancel();
    _hide = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _notice = null);
    });
  }

  _PhotoState? get _photo => _photos[_at]?.currentState;

  /// The info of [item], whose row is [row], scrolled by [scroll] in a sheet.
  Widget _panel(
    ThumbnailItem? item,
    LocalAssetData? row,
    AppLocalizations strings, [
    ScrollController? scroll,
  ]) {
    if (row == null) {
      // A photo only the server has shows no info yet but its edit history.
      final asset = item == null ? null : serverAssetOf(item);
      if (item != null && asset != null) {
        final facts = ref.watch(infoFactsProvider).value;
        final edited = ref.watch(versionsProvider(item)).value?.isNotEmpty;
        if (facts != null && (edited ?? false)) {
          return HistoryList(
            asset,
            facts,
            onBack: () => setState(() {
              _info = false;
              _history.value = false;
            }),
          );
        }
      }
      return Semantics(
        container: true,
        label: strings.viewerInfoLoading,
        child: const SizedBox.expand(),
      );
    }
    final at = _at;
    final copied = _copies.value[at] != null && _compared == null;
    final original = widget.pages[at] as ThumbnailItem?;
    return InfoPanel(
      row,
      controller: scroll,
      hooks: (
        image: _images[at],
        copyOf: copied && original != null
            ? (
                original.uri.pathSegments.last,
                () => setState(() {
                  _copies.value = {..._copies.value}..remove(at);
                  _forget(at);
                }),
              )
            : null,
        outline: (faces) => _outlined.value = faces,
        compare: (version) {
          if (mounted) setState(() => _compare(at, version));
        },
        history: _history,
      ),
    );
  }

  /// Shows [version] at [at] instead of what shows there, or with null
  /// what showed before.
  void _compare(int at, ThumbnailItem? version) {
    final copies = {..._copies.value};
    if (version != null) {
      _compared ??= (copies[at],);
      copies[at] = version;
    } else if (_compared case (final was,)) {
      _compared = null;
      if (was == null) {
        copies.remove(at);
      } else {
        copies[at] = was;
      }
    }
    _copies.value = copies;
    _forget(at);
  }

  /// Drops what was loaded of [at], whose item changed.
  void _forget(int at) {
    _images.remove(at)?.dispose();
    _sharp.remove(at);
    _failed.remove(at);
    _photos.remove(at);
    _preload();
  }

  ValueNotifier<SphereView> _viewOf(ThumbnailItem item) =>
      _views.putIfAbsent(item.key, () => ValueNotifier(const SphereView()));

  /// Starts or stops turning [item]'s [sphere] as the device turns, once the
  /// browser allows the sensors.
  Future<void> _turn(
    ThumbnailItem item,
    Sphere sphere,
    MotionSensors Function() sensors,
  ) async {
    final strings = AppLocalizations.of(context);
    if (_motion == null && !await ref.read(motionPermissionProvider)()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.viewerMotionDenied)));
      return;
    }
    if (!mounted) return;
    setState(() {
      final motion = _motion;
      _motion = motion == null
          ? SphereMotion(
              _viewOf(item),
              sensors(),
              north: sphere.heading,
              onLost: _noGyroscope,
            )
          : null;
      motion?.dispose();
    });
  }

  /// Turns motion off where the device has no gyroscope, and says so.
  void _noGyroscope() {
    setState(() {
      _motion?.dispose();
      _motion = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).viewerMotionMissing)),
    );
  }

  void _sense() => _motion?.running =
      !_covered &&
      (WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed) ==
          AppLifecycleState.resumed;

  /// Shows [item]'s sphere through the [lens] made of its view, or as it was
  /// before when it already shows it [through] one.
  void _lens(
    ThumbnailItem item,
    bool Function(SphereView) through,
    SphereView Function(SphereView) lens,
  ) {
    final view = _viewOf(item);
    if (through(view.value)) {
      view.value = _before.remove(item.key) ?? const SphereView();
    } else {
      _before.putIfAbsent(item.key, () => view.value);
      view.value = lens(view.value);
    }
  }

  /// Zooms the photo, or narrows a sphere's lens, by [factor].
  void _zoom(ThumbnailItem? item, Sphere? sphere, double factor) {
    if (item == null || sphere == null) return _photo?.zoom(factor);
    final view = _viewOf(item);
    view.value = view.value.copyWith(fov: view.value.fov / factor);
  }

  /// The page of [item], at [p], whose replica row is [row]: projected when
  /// it is a sphere, which a video's picture waits for the row to say.
  Widget _page(int p, ThumbnailItem item, AsyncValue<LocalAssetData?> row) {
    final sphere = Sphere.of(row.value);
    if (sphere != null && !_landed) return const SizedBox.expand();
    final view = sphere == null ? null : _viewOf(item);
    if (item.video) {
      final captions = ref.watch(captionsProvider(item)).value;
      final key = _videoKey(item, row.value);
      return VideoView(
        key: ValueKey(item.key),
        poster: _images[p],
        player: _players[key],
        pending: !row.hasValue,
        failed: _players.failed(key),
        shown: p == _at,
        controls: _chrome && _grown,
        onTap: () => _tapVideo(key),
        onPlay: () => _players.toggle(key),
        onControls: (on) => _onControl = on,
        onMenu: (open) => _menuOpen = open,
        frameRate: ref.watch(frameRateProvider(item)).value,
        captions: _grown ? captions : null,
        eye: Sphere.eyeOf(row.value?.stereo),
        sphere: sphere,
        view: view,
        turning: p == _at,
      );
    }
    if ((sphere, view) case (final sphere?, final view?)) {
      return SpherePhoto(
        key: ValueKey('sphere ${item.key}'),
        item: item,
        base: _images[p],
        sphere: sphere,
        view: view,
        onTap: _tap,
        turning: p == _at,
      );
    }
    return RotatedBox(
      key: ValueKey('turned ${item.key}'),
      quarterTurns: _turns[item.key] ?? 0,
      child: _Photo(
        key: _photos.putIfAbsent(p, GlobalKey.new),
        item: item,
        image: _images[p],
        sharp: _sharp.contains(p),
        shown: p == _at,
        strip: _panorama(row.value),
        failure: _failed[p],
        motion: p == _at ? _players[_motionKey(item)] : null,
        oneFingerZoom: ref.read(settingsProvider).isOn(Toggle.oneFingerZoom),
        hdr: _hdrItem(row.value) ? p == _at && _grown && _showHdr : null,
        onZoomed: (zoomed) => setState(() => _zoomed = zoomed),
        onTap: _tap,
      ),
    );
  }

  // Keep on this device (ADR-0200 P2): pins the asset with its original, and
  // says what that adds.
  Command _keepOffline(Uint8List asset) {
    final strings = AppLocalizations.of(context);
    final pin = OfflinePin.asset(asset, '');
    final kept = ref.watch(
      offlinePinsProvider.select((pins) => pins.any((p) => p.id == pin.id)),
    );
    final hex = [for (final b in asset) b.toRadixString(16).padLeft(2, '0')]
        .join();
    final size = ref.watch(offlineKeepSizeProvider(hex)).value;
    return Command(
      kept
          ? strings.offlineKeptHere
          : size == null || size == 0
          ? strings.offlineKeep
          : strings.offlineKeepHere(Formats(strings).fileSize(size)),
      () {
        final pins = ref.read(offlinePinsProvider.notifier);
        if (kept) {
          pins.unpin(pin.id);
        } else {
          pins.pin(
            OfflinePin.asset(
              asset,
              '',
              created: DateTime.now().millisecondsSinceEpoch,
            ),
          );
        }
      },
      icon: kept ? Icons.push_pin : Icons.push_pin_outlined,
      on: kept,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final size = MediaQuery.sizeOf(context);
    final filmstrip = settings.filmstrip ?? size.width >= wideViewer;
    final item = _itemAt(_at);
    _showHdr = ref.watch(settingsProvider).hdr;
    final row = item == null ? null : ref.watch(assetRowProvider(item)).value;
    final rate = item == null ? null : ref.watch(frameRateProvider(item)).value;
    final versions = item == null
        ? const <InfoVersion>[]
        : ref.watch(versionsProvider(item)).value ?? const [];
    // The neighbours' rows too, so that a page turn finds its row ready.
    for (final p in [_at - 1, _at + 1]) {
      if (p >= 0 && p < widget.count) {
        if (_itemAt(p) case final n?) {
          ref.listen(assetRowProvider(n), (_, _) {});
        }
      }
    }
    final video = item?.video ?? false;
    final motion = item == null || video
        ? null
        : ref.watch(motionClipProvider(item)).value;
    final sphere = item == null ? null : Sphere.of(row);
    // A sphere's drags turn it.
    _sphere = sphere != null;
    final locked = _zoomed || _sphere;
    final playing = video && !_away && item != null
        ? _videoKey(item, row)
        : null;
    // The players a swipe reaches: the videos of the item and its
    // neighbours, and the item's motion video.
    _players.want({
      for (final p in [_at, _at + 1, _at - 1])
        if (p >= 0 && p < widget.count)
          if (_itemAt(p) case final v? when v.video)
            if (ref.read(assetRowProvider(v)).value case final r)
              _videoKey(v, r): (options) => videoOf(
                v,
                options,
                hdr: _hdr(r),
                server: ref.read(serverVideoUrlProvider),
                link: ref.read(sessionProvider),
              ),
      if ((item, motion) case (final item?, final motion?))
        _motionKey(item): (options) async =>
            VideoPlayerController.file(motion, videoPlayerOptions: options),
    }, playing);
    final player = playing == null ? null : _players[playing];
    _watch(player);
    _swipes = video && !_sphere && settings.isOn(Toggle.swipes);
    _player = player;
    if (settings.isOn(Toggle.autoRotate)) _orient(row);
    _players
      ..autoplay = settings.isOn(Toggle.autoplay)
      ..loop = settings.isOn(Toggle.loop)
      ..mixAudio = settings.isOn(Toggle.mixAudio)
      ..positions = settings.isOn(Toggle.resume)
          ? ref.read(videoPositionsProvider)
          : null
      ..onEnded = settings.isOn(Toggle.autoNext) ? () => _go(_at + 1) : null;
    // i18n-ok: the arrow keys follow the reading direction
    final rtl = Directionality.of(context) == TextDirection.rtl;
    void info() => setState(() => _info = !_info);
    void strip() =>
        ref.read(settingsProvider.notifier).setFilmstrip(on: !filmstrip);
    final id = item?.id;
    final liked = row?.favorite == 1;
    // What leaves the timeline closes the viewer, which shows a snapshot of it.
    BuildContext leave() {
      final library = Navigator.of(context, rootNavigator: true).context;
      _close();
      return library;
    }

    void away(
      Future<void> Function(BuildContext, WidgetRef, List<Uint8List>) change,
    ) {
      if (id != null) unawaited(change(leave(), ref, [id]));
    }

    // The actions the user arranges, as this item has them.
    final every = {
      ViewerAction.info: Command(
        strings.viewerInfo,
        info,
        shortcut: const CharacterActivator('i'),
        icon: Icons.info_outline,
        on: _info,
      ),
      ViewerAction.filmstrip: Command(
        strings.viewerFilmstrip,
        strip,
        shortcut: const CharacterActivator('f'),
        icon: Icons.view_carousel_outlined,
        on: filmstrip,
      ),
      ViewerAction.slideshow: Command(
        strings.slideshow,
        _slideshow,
        shortcut: const CharacterActivator('s'),
        icon: Icons.slideshow_outlined,
      ),
      if (item != null && sharesDownloads && canShare(item))
        ViewerAction.share: Command(
          strings.viewerShare,
          () => share(context, [item], mime: row?.mime),
          icon: Icons.share_outlined,
        ),
      if (item != null &&
          _sharp.contains(_at) &&
          (canEdit(item, row?.mime) ||
              canEditVersion(
                item,
                signedIn: ref.read(sessionProvider) != null,
              )))
        ViewerAction.edit: Command(
          strings.editorEdit,
          () => unawaited(_edit(item, row)),
          shortcut: const CharacterActivator('e'),
          icon: Icons.edit_outlined,
        ),
      if (item != null && item.uri.isScheme('content'))
        ViewerAction.copy: Command(
          strings.viewerCopy,
          () => copy(item),
          shortcut: primary(LogicalKeyboardKey.keyC),
          icon: Icons.copy_outlined,
        ),
      if (item?.asset case final asset? when ref.read(sessionProvider) != null)
        ViewerAction.keepOffline: _keepOffline(asset),
      if (item?.asset case final asset? when ref.read(sessionProvider) != null)
        ViewerAction.copyText: Command(
          strings.viewerCopyText,
          () => unawaited(showPhotoText(context, ref, asset)),
          icon: Icons.text_snippet_outlined,
        ),
      if (item != null && !sharesDownloads)
        ViewerAction.download: Command(
          strings.download,
          () =>
              download(context, ref, count: 1, items: () => Stream.value(item)),
          shortcut: primary(LogicalKeyboardKey.keyS),
          icon: Icons.download_outlined,
        ),
      if (item != null && canReveal(item))
        ViewerAction.reveal: Command(
          strings.reveal(defaultTargetPlatform.name),
          () => reveal(item.uri.toFilePath()),
          icon: Icons.folder_open_outlined,
        ),
      if (item != null && !video && sphere == null)
        ViewerAction.rotate: Command(
          strings.viewerRotate,
          () => setState(
            () => _turns.update(item.key, (n) => n + 1, ifAbsent: () => 1),
          ),
          shortcut: const CharacterActivator('r'),
          icon: Icons.rotate_90_degrees_cw_outlined,
        ),
      if ((row?.lat, row?.lon) case (final lat?, final lon?) when !kIsWeb)
        ViewerAction.map: Command(
          strings.viewerMap,
          () => openElsewhere(mapOf(lat, lon)),
          icon: Icons.map_outlined,
        ),
      if (item != null && canSetAs(item))
        ViewerAction.setAs: Command(
          strings.viewerSetAs,
          () => setAs(item, row?.mime),
          icon: Icons.wallpaper_outlined,
        ),
      if (item != null && canSetAs(item))
        ViewerAction.wallpaper: Command(
          strings.galleryWallpaper,
          () => unawaited(WallpaperPage.show(context, item)),
          icon: Icons.wallpaper,
        ),
      if (item != null && canEditWith(item))
        ViewerAction.editWith: Command(
          strings.galleryEditWith,
          () => unawaited(_editWith(item, row)),
          icon: Icons.edit_note,
        ),
      if (item != null && canOpenWith(item))
        ViewerAction.openWith: Command(
          strings.galleryOpenWith,
          () => unawaited(
            ref.read(galleryPlatformProvider).openWith(item.uri, row?.mime),
          ),
          icon: Icons.open_in_new,
        ),
      if (id != null && row != null)
        ViewerAction.favourite: Command(
          liked ? strings.actionUnfavourite : strings.actionFavourite,
          () => favourite(context, ref, [id], value: !liked),
          // F shows the filmstrip (docs/10 §4.6).
          shortcut: const CharacterActivator('l'),
          icon: liked ? Icons.favorite : Icons.favorite_border,
        ),
      if (item != null && (item.id ?? item.asset) != null)
        ViewerAction.trash: Command(
          strings.actionTrash,
          () => unawaited(deleteItems(context, ref, [item], chosen: leave)),
          shortcut: const SingleActivator(LogicalKeyboardKey.delete),
          icon: Icons.delete_outline,
        ),
      if (id != null)
        for (final (action, hide, on, label, icon) in [
          (
            ViewerAction.hide,
            true,
            row?.hidden,
            strings.actionHide,
            Icons.hide_image_outlined,
          ),
          (
            ViewerAction.archive,
            false,
            row?.archived,
            strings.actionArchive,
            Icons.archive_outlined,
          ),
        ])
          if (on == 0)
            action: Command(
              label,
              () => away((c, r, ids) => veil(c, r, ids, hide: hide)),
              icon: icon,
            )
          // Shown for a while: it stays in view.
          else if (on == 1)
            action: Command(
              hide ? strings.actionUnhide : strings.actionUnarchive,
              () => veil(context, ref, [id], hide: hide, value: false),
              icon: hide ? Icons.image_outlined : Icons.unarchive_outlined,
            ),
      if (id != null)
        ViewerAction.addToAlbum: Command(
          strings.actionAddToAlbum,
          () => unawaited(addToChosenAlbum(context, ref, [id])),
          icon: Icons.photo_album_outlined,
        ),
    };
    final actions = widget.readOnly ? <ViewerAction, Command>{} : every;
    // What one kind of item alone has, which never enters the bar.
    final lenses = [
      if (item != null && sphere != null)
        Command(
          strings.viewerPlanet,
          () => _lens(item, (v) => v.planet, (_) => const SphereView.planet()),
          shortcut: const CharacterActivator('p'),
          icon: Icons.public,
        ),
      if (item != null && sphere != null)
        Command(
          strings.viewerFisheye,
          () => _lens(
            item,
            (v) => v.fisheye,
            (v) => SphereView(
              yaw: v.yaw,
              pitch: v.planet ? 0 : v.pitch,
              fov: pi,
              fisheye: true,
            ),
          ),
          shortcut: const CharacterActivator('o'),
          icon: Icons.panorama_fish_eye,
        ),
    ];
    final turns = [
      if ((item, sphere, ref.watch(sensorsProvider)) case (
        final item?,
        final sphere?,
        final sensors?,
      ))
        Command(
          strings.viewerGyroscope,
          () => unawaited(_turn(item, sphere, sensors)),
          shortcut: const CharacterActivator('g'),
          icon: Icons.screen_rotation_alt,
        ),
      if (_motion case final motion?)
        Command(
          strings.viewerCompass,
          () => setState(() => motion.locked = !motion.locked),
          icon: Icons.explore_outlined,
        ),
    ];
    final own = [
      if (_hdrItem(row))
        Command(
          _showHdr ? strings.viewerSdr : strings.viewerHdr,
          ref.read(settingsProvider.notifier).toggleHdr,
          shortcut: const CharacterActivator('h'),
          icon: _showHdr ? Icons.hdr_on : Icons.hdr_off,
        ),
      if (motion != null)
        Command(
          strings.viewerMotion,
          () => _photo?.playMotion(),
          shortcut: const CharacterActivator('m'),
          icon: Icons.motion_photos_on_outlined,
        ),
    ];
    final commands = [
      Command(
        strings.viewerPrevious,
        () => _go(_at - 1),
        shortcut: SingleActivator(
          rtl ? LogicalKeyboardKey.arrowRight : LogicalKeyboardKey.arrowLeft,
        ),
      ),
      Command(
        strings.viewerNext,
        () => _go(_at + 1),
        shortcut: SingleActivator(
          rtl ? LogicalKeyboardKey.arrowLeft : LogicalKeyboardKey.arrowRight,
        ),
      ),
      Command(
        strings.viewerFirst,
        () => _go(0),
        shortcut: const SingleActivator(LogicalKeyboardKey.home),
      ),
      Command(
        strings.viewerLast,
        () => _go(widget.count - 1),
        shortcut: const SingleActivator(LogicalKeyboardKey.end),
      ),
      Command(
        strings.viewerZoomIn,
        () => _zoom(item, sphere, 1.5),
        shortcut: const CharacterActivator('+'),
        icon: Icons.zoom_in,
      ),
      Command(
        strings.viewerZoomOut,
        () => _zoom(item, sphere, 1 / 1.5),
        shortcut: const CharacterActivator('-'),
        icon: Icons.zoom_out,
      ),
      if (video) ...[
        Command(
          strings.viewerPlay,
          () => playing == null ? null : _players.toggle(playing),
          shortcut: const SingleActivator(LogicalKeyboardKey.space),
        ),
        Command(
          strings.viewerPreviousFrame,
          () => player?.step(-1, rate),
          shortcut: const CharacterActivator(','),
        ),
        Command(
          strings.viewerNextFrame,
          () => player?.step(1, rate),
          shortcut: const CharacterActivator('.'),
        ),
        Command(
          strings.viewerMute,
          () => player?.mute(),
          shortcut: const CharacterActivator('m'),
        ),
      ],
      ...lenses,
      ...turns,
      ...own,
      ...actions.values,
      Command(
        MaterialLocalizations.of(context).closeButtonLabel,
        () {
          if (!_more.isOpen && !_lensMenu.isOpen) return _close();
          _more.close();
          _lensMenu.close();
        },
        shortcut: const SingleActivator(LogicalKeyboardKey.escape),
        icon: Icons.close,
      ),
    ];

    final drags = ref.watch(fileDragProvider) != null;
    final theme = appTheme(
      Brightness.dark,
      highContrast: MediaQuery.highContrastOf(context),
    );
    // Under reduce motion the route cross-fades the page instead.
    final flight = Motion.reduced(context) ? null : _route;
    final flying = !(flight?.shown.isCompleted ?? true);
    final shown = flight?.shown ?? kAlwaysCompleteAnimation;
    Widget faded(Widget child) => FadeTransition(opacity: shown, child: child);
    final pages = PageView.builder(
      controller: _pager,
      // Builds the neighbours too, so that a video's first frame slides in.
      allowImplicitScrolling: _landed,
      physics: locked ? const NeverScrollableScrollPhysics() : null,
      itemCount: _window,
      onPageChanged: (i) {
        if (_base + i == _at) return;
        if (_compared != null) _compare(_at, null);
        _history.value = false;
        _outlined.value = const [];
        widget.position.value = _base + i;
        setState(() {
          _motion?.dispose();
          _motion = null;
          _zoomed = false;
          // Playback gives back the chrome it hid; the user's stays hidden.
          _chrome |= _playbackHid;
          _playbackHid = false;
          _idle?.cancel();
          _preload();
        });
      },
      itemBuilder: (context, i) {
        final p = _base + i;
        final item = _itemAt(p);
        if (item == null) return const SizedBox.expand();
        return Consumer(
          builder: (context, ref, _) =>
              _page(p, item, ref.watch(assetRowProvider(item))),
        );
      },
    );

    // The flight shows the item instead.
    final photos = IgnorePointer(
      ignoring: flying,
      child: Opacity(
        opacity: flying ? 0 : 1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.depth == 0 &&
                (n is ScrollStartNotification || n is ScrollEndNotification)) {
              _scrolling = n is ScrollStartNotification;
              _rest();
            }
            return false;
          },
          child: pages,
        ),
      ),
    );

    // The info beside the photo from 760 dp, which pushes it; below, a
    // sheet over it.
    final side = size.width >= wideViewer;
    final panel = _info && _landed;
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: MouseRegion(
                  onHover: _hovered,
                  onExit: _left,
                  child: Listener(
                    onPointerDown: (_) => _touches.value++,
                    onPointerSignal: (_) => _touches.value++,
                    child: Stack(
                      children: [
                        if (_backdrop(settings.background) case final backdrop?)
                          Positioned.fill(child: faded(backdrop)),
                        Positioned.fill(
                          child: GestureDetector(
                            // With the info shown, a swipe down hides it.
                            onVerticalDragEnd: !_info
                                ? null
                                : (details) {
                                    if ((details.primaryVelocity ?? 0) > 0) {
                                      info();
                                    }
                                  },
                            child: LayoutBuilder(
                              builder: (context, area) => Listener(
                                onPointerDown: (event) {
                                  _area = area.biggest;
                                  // A mouse has the arrows instead.
                                  _pressed(
                                    event.kind == PointerDeviceKind.mouse
                                        ? area.maxWidth / 2
                                        : event.localPosition.dx,
                                    area.maxWidth,
                                  );
                                  // A sphere turns instead.
                                  _press =
                                      drags &&
                                          !_sphere &&
                                          event.kind ==
                                              PointerDeviceKind.mouse &&
                                          event.buttons == kPrimaryMouseButton
                                      ? event.position
                                      : null;
                                },
                                onPointerMove: _dragOut,
                                onPointerUp: (_) => _press = null,
                                child: RawGestureDetector(
                                  gestures: _sideDrags(),
                                  child: NotificationListener(
                                    onNotification: _rested,
                                    child: photos,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if ((flight, _images[_at])
                            case (final flight?, final image?) when flying)
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: shown,
                              builder: (context, _) => _Flight(
                                image,
                                flight.from(),
                                shown.value,
                                _photo?._controller.value,
                              ),
                            ),
                          ),
                        if (_images[_at] case final image? when !flying)
                          _Faces(_outlined, image),
                        if (_chrome && !flying && !_panorama(row))
                          _Arrows(
                            pointer: _pointer,
                            zone: sphere == null ? null : 92,
                            // A video's controls take the foot of the picture.
                            bottom: video ? 112 : 0,
                            onPrevious: _at > 0 ? () => _go(_at - 1) : null,
                            onNext: _at < widget.count - 1
                                ? () => _go(_at + 1)
                                : null,
                          ),
                        if (_chrome && own.isNotEmpty)
                          faded(_Cues(own, raised: video)),
                        if ((item, sphere) case (final item?, final sphere?)
                            when _landed)
                          SphereCues(
                            key: ValueKey('cues ${item.key}'),
                            view: _viewOf(item),
                            sphere: sphere,
                            chrome: _chrome,
                            touches: _touches,
                            turning: _motion == null,
                            lenses: lenses,
                            turns: turns,
                            raised: video,
                            menu: _lensMenu,
                          ),
                        if (_level case (final icon, final value))
                          Center(child: _Level(icon, value)),
                        if (_notice case final notice?) _Notice(notice),
                        if (_chrome)
                          faded(
                            MouseRegion(
                              onEnter: (_) => _onControl = true,
                              onExit: (_) => _onControl = false,
                              child: ViewerBar(
                                readOnly: widget.readOnly,
                                pins: [...settings.bar.where(onThisPlatform)],
                                actions: actions,
                                onCustomize: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const ToolbarPage(),
                                  ),
                                ),
                                menu: _more,
                                onMenu: (open) => _menuOpen = open,
                                history: versions.isEmpty || widget.readOnly
                                    ? null
                                    : Command(
                                        strings.infoHistory,
                                        () => setState(() {
                                          _info = true;
                                          _history.value = true;
                                        }),
                                        icon: Icons.history,
                                      ),
                              ),
                            ),
                          ),
                        // Drags pan a strip, so buttons turn its page.
                        if (_chrome &&
                            sphere == null &&
                            !video &&
                            _panorama(row))
                          for (final (to, icon, label) in [
                            (
                              _at - 1,
                              Icons.chevron_left,
                              strings.viewerPrevious,
                            ),
                            (_at + 1, Icons.chevron_right, strings.viewerNext),
                          ])
                            if (to >= 0 && to < widget.count)
                              faded(
                                Align(
                                  alignment: to < _at
                                      ? AlignmentDirectional.centerStart
                                      : AlignmentDirectional.centerEnd,
                                  child: IconButton.filledTonal(
                                    icon: Icon(icon),
                                    tooltip: label,
                                    onPressed: () => _go(to),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              // Never with the chrome, so that it never moves the photo.
              if (filmstrip) faded(_strip),
            ],
          ),
        ),
        // Laid out whether or not the item's row has come, so that a page
        // turn never resizes the pages.
        if (panel && side)
          faded(
            SizedBox(
              key: const ValueKey('info'),
              width: 340,
              child: Theme(
                data: Theme.of(context),
                child: Material(child: _panel(item, row, strings)),
              ),
            ),
          ),
      ],
    );
    final body = !panel || side
        ? content
        : Stack(
            fit: StackFit.expand,
            children: [
              content,
              faded(
                DraggableScrollableSheet(
                  key: const ValueKey('info'),
                  // At its peek, the photo's middle in view.
                  initialChildSize: 0.25,
                  maxChildSize: 0.9,
                  snap: true,
                  snapSizes: const [0.25, 0.5, 0.9],
                  // In the app's theme, light or dark, as the panel is.
                  builder: (_, scroll) => Theme(
                    data: Theme.of(context),
                    child: Material(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _panel(item, row, strings, scroll),
                    ),
                  ),
                ),
              ),
            ],
          );

    return Theme(
      data: theme,
      child: Commands(
        commands: commands,
        // A scaffold of its own, so that its snack bars show over it.
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SwipeToDismiss(
            enabled: !locked && !_info,
            // A mouse drags the file out instead, where windows take files.
            mouse: !drags,
            onDismissed: _close,
            onSwipeUp: () => setState(() => _info = !widget.readOnly),
            // The route's flight shows the drag; its scrim, the background.
            onDrag: _route?.drag,
            child: _route == null
                ? body
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      faded(ColoredBox(color: theme.colorScheme.scrim)),
                      body,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// The item shown in flight: [image] cropped as its cell crops it, [t] of
/// the way from [from], its cell on the screen, to where it fits this box,
/// seen through its photo's [zoom].
class _Flight extends LeafRenderObjectWidget {
  const new(this.image, this.from, this.t, this.zoom)
    : super(key: const ValueKey('flight'));

  final ui.Image image;
  final Rect from;
  final double t;
  final Matrix4? zoom;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderFlight(this);

  @override
  void updateRenderObject(BuildContext context, _RenderFlight renderObject) =>
      renderObject
        ..flight = this
        ..markNeedsPaint();
}

class _RenderFlight extends RenderBox {
  new(this.flight);

  _Flight flight;

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    final _Flight(:image, :from, :t, :zoom) = flight;
    final fitted = Alignment.center.inscribe(
      applyBoxFit(
        BoxFit.contain,
        Size(image.width.toDouble(), image.height.toDouble()),
        size,
      ).destination,
      Offset.zero & size,
    );
    final to = zoom == null ? fitted : MatrixUtils.transformRect(zoom, fitted);
    final cell = Rect.fromPoints(
      globalToLocal(from.topLeft),
      globalToLocal(from.bottomRight),
    );
    paintImage(
      canvas: context.canvas,
      rect: (Rect.lerp(cell, to, t) ?? to).shift(offset),
      image: image,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
    );
  }
}

/// A message at the foot of the viewer, read out as it appears.
class _Notice extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Semantics(
          liveRegion: true,
          child: Material(
            color: colours.inverseSurface,
            shape: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                text,
                style: TextStyle(color: colours.onInverseSurface),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The thumbnails of every item in a row under the photo (VIEW-12), the one
/// shown outlined and kept in the middle.
class _Filmstrip extends StatefulWidget {
  const _Filmstrip({
    required this.pages,
    required this.count,
    required this.position,
    required this.thumbnails,
    required this.after,
    required this.copies,
    required this.onTap,
  });

  final TimelinePages pages;
  final int count;
  final ValueNotifier<int> position;
  final Thumbnails thumbnails;
  final ValueListenable<bool> after;
  // The editor's copies, shown in place of what they copy.
  final ValueListenable<Map<int, ThumbnailItem>> copies;
  final ValueChanged<int> onTap;

  @override
  State<_Filmstrip> createState() => _FilmstripState();
}

class _FilmstripState extends State<_Filmstrip> {
  static const _extent = 64.0;
  ScrollController? _scroll;
  int? _clicked;

  @override
  void initState() {
    super.initState();
    widget.position.addListener(_follow);
  }

  @override
  void dispose() {
    widget.position.removeListener(_follow);
    _scroll?.dispose();
    super.dispose();
  }

  double _offset(double width) =>
      max(0, (widget.position.value + 0.5) * _extent - width / 2);

  /// Keeps the item shown in view, never jumping (docs/10 §4.6): one
  /// [_clicked] is uncovered by the least amount, else the strip recentres,
  /// smoothly, only once the item comes within 20 % of an edge.
  void _follow() {
    final scroll = _scroll;
    final clicked = _clicked == widget.position.value;
    _clicked = null;
    if (scroll == null || !scroll.hasClients) return;
    final (at, width) = (scroll.offset, scroll.position.viewportDimension);
    final start = widget.position.value * _extent;
    final end = start + _extent;
    final margin = clicked ? 0 : width / 5;
    if (start >= at + margin && end <= at + width - margin) return;
    final to = (clicked ? (start < at ? start : end - width) : _offset(width))
        .clamp(0.0, scroll.position.maxScrollExtent);
    final duration = Motion.of(context, Motion.short);
    if (duration == Duration.zero || (to - at).abs() > width) {
      scroll.jumpTo(to);
    } else {
      scroll.animateTo(to, duration: duration, curve: Motion.curve);
    }
  }

  /// Shows the item at [p], clicked in the strip.
  void _click(int p) {
    _clicked = p;
    widget.onTap(p);
    if (widget.position.value != p) _clicked = null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _extent + 8,
      child: LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          key: const ValueKey('filmstrip'),
          controller: _scroll ??= ScrollController(
            initialScrollOffset: _offset(constraints.maxWidth),
          ),
          scrollDirection: Axis.horizontal,
          itemExtent: _extent,
          itemCount: widget.count,
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemBuilder: (context, p) => _Cell(p, widget),
        ),
      ),
    );
  }
}

/// A filmstrip cell, which builds again only when it becomes or stops being
/// the item shown.
class _Cell extends StatefulWidget {
  const _Cell(this.at, this.strip);

  final int at;
  final _Filmstrip strip;

  @override
  State<_Cell> createState() => _CellState();
}

class _CellState extends State<_Cell> {
  var _outlined = false;

  bool get _shown => widget.strip.position.value == widget.at;

  @override
  void initState() {
    super.initState();
    widget.strip.position.addListener(_moved);
  }

  @override
  void dispose() {
    widget.strip.position.removeListener(_moved);
    super.dispose();
  }

  void _moved() {
    if (_shown != _outlined) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final strip = widget.strip;
    _outlined = _shown;
    return Semantics(
      label: AppLocalizations.of(context)
          .viewerItem(widget.at + 1, strip.count),
      selected: _outlined,
      child: InkWell(
        onTap: () => context.findAncestorStateOfType<_FilmstripState>()?._click(
          widget.at,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: _outlined
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: ValueListenableBuilder(
            valueListenable: strip.copies,
            builder: (context, copies, _) => ThumbnailAt(
              widget.at,
              strip.pages,
              strip.thumbnails,
              after: strip.after,
              item: copies[widget.at],
            ),
          ),
        ),
      ),
    );
  }
}

String _motionKey(ThumbnailItem item) => 'motion ${item.key}';

/// The [faces] the info outlines on the photo, each with its name, where
/// [image] fits the stage unzoomed.
class _Faces extends StatelessWidget {
  const new(this.faces, this.image);

  final ValueListenable<List<InfoFace>> faces;
  final ui.Image image;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: LayoutBuilder(
      builder: (context, box) => ValueListenableBuilder(
        valueListenable: faces,
        builder: (context, faces, _) {
          final picture = Alignment.center.inscribe(
            applyBoxFit(
              BoxFit.contain,
              Size(image.width.toDouble(), image.height.toDouble()),
              box.biggest,
            ).destination,
            Offset.zero & box.biggest,
          );
          Rect place(Rect f) => Rect.fromLTRB(
            picture.left + f.left * picture.width,
            picture.top + f.top * picture.height,
            picture.left + f.right * picture.width,
            picture.top + f.bottom * picture.height,
          );
          return Stack(
            children: [
              for (final face in faces)
                Positioned.fromRect(
                  key: ValueKey(face),
                  rect: place(face.box),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: OverflowBox(
                      alignment: Alignment.bottomCenter,
                      minWidth: 0,
                      minHeight: 0,
                      maxWidth: 200,
                      maxHeight: double.infinity,
                      child: FractionalTranslation(
                        translation: const Offset(0, 1),
                        child: Text(
                          face.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 4)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

/// The arrows at the stage's edges for a mouse (docs/10 §4.6, VIEW-41):
/// faint while the [pointer] moves over it, opaque within [zone] of an edge
/// (18 % of its width unless given), where the whole strip turns the page;
/// and for the keyboard, shown while focused.
class _Arrows extends StatelessWidget {
  const new({
    required this.pointer,
    required this.zone,
    required this.onPrevious,
    required this.onNext,
    this.bottom = 0,
  });

  final ValueListenable<(Offset?, bool)> pointer;
  final double? zone;
  final double bottom;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final width = zone ?? box.maxWidth * 0.18;
      // i18n-ok: the previous item is at the start of the reading direction
      final rtl = Directionality.of(context) == TextDirection.rtl;
      return ValueListenableBuilder(
        valueListenable: pointer,
        builder: (context, p, _) {
          final (at, moving) = p;
          // Under the bar, the bar's.
          final x = at == null || at.dy < 64 || at.dy > box.maxHeight - bottom
              ? null
              : at.dx;
          bool hot({required bool end}) =>
              x != null &&
              ((end != rtl) ? x > box.maxWidth - width : x < width);
          return Stack(
            children: [
              for (final (end, run) in [(false, onPrevious), (true, onNext)])
                if (run != null)
                  _Arrow(
                    end: end,
                    width: width,
                    bottom: bottom,
                    hot: hot(end: end),
                    moving: moving,
                    onTap: run,
                  ),
            ],
          );
        },
      );
    },
  );
}

/// One of [_Arrows], at the [end] of the reading direction or its start.
class _Arrow extends StatefulWidget {
  const new({
    required this.end,
    required this.width,
    required this.bottom,
    required this.hot,
    required this.moving,
    required this.onTap,
  });

  final bool end;
  final double width;
  final double bottom;
  final bool hot;
  final bool moving;
  final VoidCallback onTap;

  @override
  State<_Arrow> createState() => _ArrowState();
}

class _ArrowState extends State<_Arrow> {
  var _focused = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final end = widget.end;
    final name = end ? 'next' : 'previous';
    final opaque = widget.hot || _focused;
    return PositionedDirectional(
      start: end ? null : 0,
      end: end ? 0 : null,
      top: 0,
      bottom: widget.bottom,
      width: widget.width,
      child: Focus(
        key: ValueKey('arrow $name focus'),
        onFocusChange: (on) => setState(() => _focused = on),
        onKeyEvent: (_, event) {
          final key = event.logicalKey;
          if (event is! KeyDownEvent ||
              key != LogicalKeyboardKey.enter &&
                  key != LogicalKeyboardKey.space) {
            return KeyEventResult.ignored;
          }
          widget.onTap();
          return KeyEventResult.handled;
        },
        child: Semantics(
          button: true,
          label: end ? strings.viewerNext : strings.viewerPrevious,
          onTap: widget.onTap,
          child: IgnorePointer(
            ignoring: !widget.hot,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: Align(
                alignment: end
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: AnimatedOpacity(
                    opacity: opaque ? 1 : (widget.moving ? 0.5 : 0),
                    duration: Motion.of(context, Motion.short),
                    child: DecoratedBox(
                      key: ValueKey('arrow $name'),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(
                          alpha: opaque ? 0.8 : 0.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(
                        dimension: 52,
                        child: Icon(
                          end ? Icons.chevron_right : Icons.chevron_left,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The buttons of what one kind of item alone has (HDR, a motion photo's
/// video) at the picture's corner, never in the bar, so that
/// its buttons never shift (docs/10 §4.6); [raised] over a video's controls.
class _Cues extends StatelessWidget {
  const new(this.commands, {required this.raised});

  final List<Command> commands;
  final bool raised;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.bottomStart,
    child: Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, raised ? 112 : 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          for (final c in commands)
            IconButton.filledTonal(
              icon: Icon(c.icon),
              tooltip: c.label,
              isSelected: c.on,
              onPressed: c.run,
            ),
        ],
      ),
    ),
  );
}

/// A progress ring for an item with nothing to show yet, after 400 ms, so
/// that a quick load never flashes one (docs/10 §4.6).
class _LateRing extends StatefulWidget {
  const new();

  @override
  State<_LateRing> createState() => _LateRingState();
}

class _LateRingState extends State<_LateRing> {
  var _late = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(milliseconds: 400),
      () => setState(() => _late = true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _late
      ? const Center(
          child: CircularProgressIndicator(key: ValueKey('viewer-progress')),
        )
      : const SizedBox.shrink();
}

/// What a side drag sets, [icon], and how far, [value] from 0 to 1.
class _Level extends StatelessWidget {
  const new(this.icon, this.value);

  final IconData icon;
  final double value;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Icon(icon),
          SizedBox(width: 120, child: LinearProgressIndicator(value: value)),
        ],
      ),
    ),
  );
}

/// What shows behind transparent images, over the viewer's black.
Widget? _backdrop(ViewerBackground background) => switch (background) {
  ViewerBackground.black => null,
  ViewerBackground.white => const ColoredBox(
    key: ValueKey('viewer-background'),
    color: Colors.white,
  ),
  ViewerBackground.checkerboard => CustomPaint(
    key: const ValueKey('viewer-background'),
    painter: _Checkerboard(),
  ),
};

/// Light and dark grey squares of 16 px.
class _Checkerboard extends CustomPainter {
  final _light = Paint()..color = const Color(0xffe0e0e0);
  final _dark = Paint()..color = const Color(0xffa0a0a0);

  @override
  void paint(Canvas canvas, Size size) {
    const side = 16.0;
    canvas.drawRect(Offset.zero & size, _light);
    for (var y = 0; y * side < size.height; y++) {
      for (var x = y % 2; x * side < size.width; x += 2) {
        canvas.drawRect(Rect.fromLTWH(x * side, y * side, side, side), _dark);
      }
    }
  }

  @override
  bool shouldRepaint(_Checkerboard old) => false;
}

/// Whether [row]'s metadata says it is a panorama: shown as a strip unless
/// it is a sphere.
bool _panorama(LocalAssetData? row) =>
    (row?.facets ?? '').split(',').contains('panorama');

/// An item: its image fitted, or a [strip] wider than the screen at its
/// height, zoomed with pinches and double taps, deep into the tiles of its
/// regions once its screen-size image shows, to 2 device pixels per image
/// pixel; its [motion] video, if any, plays while pressed, and an animated
/// image plays once sharp while it is [shown], which alone tells the viewer
/// whether it is zoomed.
class _Photo extends ConsumerStatefulWidget {
  const _Photo({
    required this.motion,
    required this.shown,
    required this.strip,
    this.hdr,
    super.key,
    required this.item,
    required this.image,
    required this.sharp,
    this.failure,
    this.oneFingerZoom = true,
    required this.onZoomed,
    required this.onTap,
  });

  final ThumbnailItem item;
  final ui.Image? image;
  final bool sharp;
  final bool shown;
  final bool strip;

  /// Why it has no image, when it has none.
  final Object? failure;

  final VideoPlayerController? motion;
  final bool oneFingerZoom;

  /// Whether its HDR leaf shows; null when it has none.
  final bool? hdr;

  final ValueChanged<bool> onZoomed;
  final VoidCallback onTap;

  @override
  ConsumerState<_Photo> createState() => _PhotoState();
}

class _PhotoState extends ConsumerState<_Photo> with TickerProviderStateMixin {
  final _controller = TransformationController();
  late final AnimationController _animation = AnimationController(vsync: this)
    ..addListener(() => _controller.value = _tween!.evaluate(_animation));
  Matrix4Tween? _tween;
  Regions? _regions;
  Future<void>? _opening;
  var _zoomed = false;
  var _maxScale = 4.0;
  // A strip's box, whose height it fills at _fill times, until it is zoomed
  // otherwise.
  Size? _strip;
  var _fill = 1.0;
  var _unstripped = false;
  Offset? _tapped;
  var _moving = false;
  // The animation asked for, and its player and frame once it plays.
  Object? _animating;
  Frames? _frames;
  ui.Image? _frame;
  // A one-finger zoom's recognizer, and the zoom and point it started from.
  late final _oneFinger = OneFingerZoom(debugOwner: this)
    ..onStart = _dragStart
    ..onUpdate = _drag;
  (Matrix4, Offset)? _dragged;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final scale = _controller.value.getMaxScaleOnAxis();
      if (_strip != null && (scale - _fill).abs() > 1e-9) {
        _strip = null;
        _unstripped = true;
      }
      final zoomed = scale > 1.001;
      if (zoomed == _zoomed) return;
      if (widget.shown) widget.onZoomed(zoomed);
      _zoomed = zoomed;
      // A decoder can hold the whole file: only a zoomed item has one.
      if (zoomed && _opening == null) {
        _opening = ref.read(regionsProvider)(widget.item).then((regions) {
          if (mounted) {
            setState(() => _regions = regions);
          } else {
            regions?.close();
          }
        });
      }
    });
    _animate();
  }

  @override
  void didUpdateWidget(_Photo old) {
    super.didUpdateWidget(old);
    if (widget.shown && !old.shown && _zoomed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.shown) widget.onZoomed(_zoomed);
      });
    }
    _animate();
  }

  void _animate() {
    if (!widget.shown) return _still();
    if (_animating != null || !widget.sharp) return;
    final animating = _animating = Object();
    unawaited(
      ref.read(animationProvider)(widget.item).then(
        (codec) {
          if (codec == null) return;
          if (!mounted || animating != _animating) return codec.dispose();
          _frames = Frames(codec, this, (frame) {
            setState(() {
              _frame?.dispose();
              _frame = frame;
            });
          });
        },
        onError: (Object error) => _log.warning(
          'no animation',
          fields: {'file': '${widget.item}'},
          error: error,
        ),
      ),
    );
  }

  void _still() {
    _animating = null;
    _frames?.dispose();
    _frames = null;
    _frame?.dispose();
    _frame = null;
  }

  /// Plays the motion video from the start; it shows while it plays, until
  /// it ends or [stopMotion].
  Future<void> playMotion() async {
    final motion = widget.motion;
    if (motion == null) return;
    setState(() => _moving = true);
    await motion.seekTo(Duration.zero);
    await motion.start();
  }

  void stopMotion() {
    unawaited(widget.motion?.pause());
    if (mounted) setState(() => _moving = false);
  }

  @override
  void dispose() {
    _still();
    _regions?.close();
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Fits an image of [size] into [box]: how far it zooms, and a strip's
  /// height.
  void _fit(Size size, Size box) {
    final fitted = applyBoxFit(BoxFit.contain, size, box).destination;
    final fill = box.height / fitted.height;
    _maxScale = max(
      max(4, fill),
      2 * size.width / (fitted.width * MediaQuery.devicePixelRatioOf(context)),
    );
    if (widget.strip && !_unstripped && fill > 1.001 && box != _strip) {
      final was = _strip;
      _strip = box;
      _fillHeight(was, box, fill);
    }
  }

  /// Fills [box]'s height with the strip, [fill] times its fitted height,
  /// after this frame; what was across the middle of [was], its last box,
  /// stays there.
  void _fillHeight(Size? was, Size box, double fill) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _strip != box) return;
        final across = was == null
            ? 0.5
            : _controller.toScene(was.center(Offset.zero)).dx / was.width;
        _fill = fill;
        _controller.value = Matrix4.identity()
          ..translateByDouble(
            (box.width * (0.5 - across * fill)).clamp(
              box.width * (1 - fill),
              0,
            ),
            box.height * (1 - fill) / 2,
            0,
            1,
          )
          ..scaleByDouble(fill, fill, 1, 1);
      });

  /// [sdr] under the HDR leaf, if any.
  Widget _leaf(Widget sdr) => switch (widget.hdr) {
    final show? => HdrLeaf(uri: widget.item.uri, show: show, sdr: sdr),
    null => sdr,
  };

  /// Zooms by [factor] about [focus], the centre unless given, between
  /// fitting the screen and the most this item allows.
  void zoom(double factor, [Offset? focus]) {
    final size = context.size ?? Size.zero;
    final to = _scaled(
      _controller.value,
      _controller.value.getMaxScaleOnAxis() * factor,
      focus ?? size.center(Offset.zero),
    );
    _tween = Matrix4Tween(begin: _controller.value, end: to);
    _animation
      ..duration = Motion.of(context)
      ..forward(from: 0).whenComplete(() {
        if (mounted) _controller.value = to;
      });
  }

  /// [from] scaled to [to], within what this item allows, keeping what it
  /// shows at [at] there.
  Matrix4 _scaled(Matrix4 from, double to, Offset at) {
    final size = context.size!;
    final scale = to.clamp(1.0, _maxScale);
    final scene = MatrixUtils.transformPoint(Matrix4.inverted(from), at);
    return Matrix4.identity()
      ..translateByDouble(
        (at.dx - scene.dx * scale).clamp(size.width * (1 - scale), 0),
        (at.dy - scene.dy * scale).clamp(size.height * (1 - scale), 0),
        0,
        1,
      )
      ..scaleByDouble(scale, scale, 1, 1);
  }

  void _dragStart(Offset at) {
    _animation.stop();
    if (context.findRenderObject() case final RenderBox box) {
      _dragged = (_controller.value.clone(), box.globalToLocal(at));
    }
  }

  /// Doubles the zoom for every 100 px a one-finger zoom has moved down.
  void _drag(double dy) {
    if (_dragged case (final from, final at)) {
      _controller.value = _scaled(
        from,
        from.getMaxScaleOnAxis() * pow(2, dy / 100),
        at,
      );
    }
  }

  Widget _image(Size? size, ui.Image? image) => size == null
      ? SizedBox.expand(
          child: switch (widget.failure) {
            final failure? => FailureMark(failure, size: 64),
            null => const _LateRing(),
          },
        )
      : _leaf(
          DeepZoom(
            size: size,
            base: image,
            controller: _controller,
            regions: widget.sharp && _frames == null ? _regions : null,
          ),
        );

  @override
  Widget build(BuildContext context) {
    final image = _frame ?? widget.image;
    final size =
        _regions?.size ??
        (image == null
            ? null
            : Size(image.width.toDouble(), image.height.toDouble()));
    return LayoutBuilder(
      builder: (context, constraints) {
        if (size != null) _fit(size, constraints.biggest);
        final motion = widget.motion;
        final photo = GestureDetector(
          // A one-finger zoom's first tap is no tap.
          onTap: () => _oneFinger.pressing ? null : widget.onTap(),
          onDoubleTapDown: (details) => _tapped = details.localPosition,
          onDoubleTap: () => zoom(_zoomed ? 0 : 2.5, _tapped),
          onLongPressStart: motion == null ? null : (_) => playMotion(),
          onLongPressEnd: motion == null ? null : (_) => stopMotion(),
          child: InteractiveViewer(
            transformationController: _controller,
            maxScale: _maxScale,
            panEnabled: _zoomed,
            // Inside, so that it hears a drag before the viewer's pan does.
            child: RawGestureDetector(
              behavior: HitTestBehavior.opaque,
              gestures: {
                OneFingerZoom:
                    GestureRecognizerFactoryWithHandlers<OneFingerZoom>(
                      () => _oneFinger,
                      (zoom) => zoom
                        ..enabled = widget.oneFingerZoom
                        ..gestureSettings = MediaQuery.maybeGestureSettingsOf(
                          context,
                        ),
                    ),
              },
              child: _image(size, image),
            ),
          ),
        );
        if (motion == null) return photo;
        return Stack(
          fit: StackFit.expand,
          children: [
            Semantics(
              onLongPressHint: AppLocalizations.of(context).viewerMotion,
              child: photo,
            ),
            if (_moving)
              ValueListenableBuilder(
                valueListenable: motion,
                builder: (context, v, child) => switch (child) {
                  final child? when v.isPlaying => child,
                  _ => const SizedBox.shrink(),
                },
                child: IgnorePointer(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: motion.value.aspectRatio,
                      child: VideoPlayer(motion),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
