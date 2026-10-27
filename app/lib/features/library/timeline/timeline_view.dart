import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/library/timeline/buckets.dart';
import 'package:photolib/features/library/timeline/layout.dart';
import 'package:photolib/features/library/timeline/pages.dart';
import 'package:photolib/features/library/timeline/pipeline.dart' show Mark;
import 'package:photolib/features/library/timeline/scrubber.dart';
import 'package:photolib/features/library/timeline/selection.dart';
import 'package:photolib/features/library/timeline/sliver.dart';
import 'package:photolib/features/library/timeline/thumb_hash.dart';
import 'package:photolib/features/library/timeline/thumbnail_at.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/library/timeline/timeline_header.dart';
import 'package:photolib/features/library/timeline/timeline_row.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/l10n/formats.dart';
import 'package:photolib/ui/commands.dart' show primary;
import 'package:photolib/ui/media_grid.dart' show PinchRecognizer, peek;
import 'package:photolib/ui/motion.dart';

/// The timeline (docs/10 §3): segments of square cells over the bucket table,
/// a scrubber, and thumbnails decoded around the viewport.
class TimelineView extends StatefulWidget {
  /// A timeline of [buckets], whose items [pages] loads.
  const new({
    required this.buckets,
    required this.pages,
    required this.thumbnails,
    required this.selection,
    this.placeholder,
    this.duration,
    this.excluded,
    this.sphere,
    this.marks,
    this.badge,
    this.grouping = Grouping.day,
    this.animated,
    this.animation,
    this.density = Density.days,
    this.onDensity,
    this.onOpen,
    this.onPress,
    this.onVisible,
    this.onDragOut,
    super.key,
  });

  /// The assets per day.
  final TimelineBuckets buckets;

  /// The item at each position, loaded a page at a time.
  final TimelinePages pages;

  /// The decoded thumbnails, and the queue of decodes.
  final Thumbnails thumbnails;

  /// The selected positions, which the view changes.
  final ValueNotifier<Selection> selection;

  /// What a cell shows until its thumbnail is decoded (T0).
  final ThumbHash? Function(Object item)? placeholder;

  /// A video's duration, which its cell shows once known.
  final Duration? Function(Object item)? duration;

  /// Whether an item's folder is one the library shows only for now, which
  /// its cell marks.
  final bool Function(Object item)? excluded;

  /// Whether an item is a photo sphere or 360° video, whose cell has a badge
  /// (design 08 §7).
  final bool Function(Object item)? sphere;

  /// The marks its cell shows: favourite, hidden, archived (ADR-0245).
  final Set<Mark> Function(Object item)? marks;

  /// The badge of an item's cell, at its bottom start, and what it says.
  final (IconData, String)? Function(Object item)? badge;

  /// The segments of the day densities.
  final Grouping grouping;

  /// Whether an item is an animated image, whose cell has a badge.
  final bool Function(Object item)? animated;

  /// An animated item's frames, which its cell plays while nothing is
  /// selected; null when the grid plays none (FMT-13).
  final Future<ui.Codec?> Function(Object item)? animation;

  /// The density it opens at, and changes to whenever this changes.
  final Density density;

  /// Told the density a pinch or zoom changes to, which its parent keeps.
  final ValueChanged<Density>? onDensity;

  /// Opens the item at a position, whose cell is at a rectangle of the screen.
  final void Function(int asset, Rect cell)? onOpen;

  /// Hears a pointer touch the cell of an asset, which a tap may open.
  final void Function(int asset)? onPress;

  /// The first and last visible asset, whenever the scroll settles.
  final void Function(int first, int last)? onVisible;

  /// Drags the item at a position out of the window, as a mouse moves it from
  /// its cell as far as a drag starts (docs/10 §8.2).
  final void Function(int asset)? onDragOut;

  @override
  State<TimelineView> createState() => TimelineViewState();
}

/// The state of a [TimelineView], through which its page scrolls, zooms and
/// selects.
class TimelineViewState extends State<TimelineView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  /// The scroll position of the grid.
  final controller = ScrollController();
  final _focus = FocusNode(debugLabel: 'timeline');
  late final _ticker = createTicker(_autoScroll);

  /// The grid's geometry at its current width and density.
  late TimelineLayout layout;

  /// The buckets grouped into the segments shown.
  late TimelineBuckets segments;

  /// The density shown, which a pinch or [zoom] changes.
  late Density density = widget.density;
  var _lastOffset = 0.0;
  var _forward = true;
  Size _size = Size.zero;
  (int, int)? _reported;

  // A pinch scales the grid until it snaps to a density on release; the
  // asset under the fingers, how far down its cell, and where they were.
  var _scale = 1.0;
  Offset _focal = Offset.zero;
  ({int asset, double fraction, double y})? _anchor;

  // The last asset tapped or dragged to, where a shift tap's range starts;
  // and a drag-select's first asset, the selection before it, whether it adds
  // or removes, the pointer, the time it has been held and whether it scrolls.
  int? _last;
  int? _dragFrom;
  Selection _dragBase = Selection.none;
  var _adding = true;
  Offset _pointer = Offset.zero;
  Duration _lastTick = Duration.zero;
  var _autoScrolling = false;
  // Where the primary mouse button went down, until it moves a file out.
  Offset? _press;
  // While selecting, the asset a long press previews, and what ends that.
  int? _peeked;
  VoidCallback? _unpeek;

  /// The height of a segment's header.
  static const headerExtent = 48.0;

  @override
  void initState() {
    super.initState();
    controller.addListener(_prefetch);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(TimelineView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.density != oldWidget.density) {
      _snap(widget.density, Offset.zero);
    }
  }

  @override
  void dispose() {
    _endPeek();
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _focus.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void didHaveMemoryPressure() => widget.thumbnails.clear();

  /// Puts the newest segment of a month at the top: one O(1) lookup.
  void jumpToMonth(int year, int month) {
    final segment = segments.segmentOfMonth(year, month);
    if (segment == null) return;
    controller.jumpTo(
      layout
          .segmentOffset(segment)
          .clamp(0, controller.position.maxScrollExtent),
    );
  }

  /// Puts [asset]'s row at the top, where [visible] starts.
  void scrollTo(int asset) => controller.jumpTo(
    layout.assetOffset(asset).clamp(0, controller.position.maxScrollExtent),
  );

  /// Steps [by] densities, sparser when positive, keeping the top row.
  void zoom(int by) => _snap(
    Density.values[(density.index + by).clamp(0, Density.values.length - 1)],
    Offset.zero,
  );

  /// The first and last asset in the viewport.
  (int, int) get visible {
    final offset = controller.offset;
    final first = layout.childAt(offset);
    final last = layout.childAt(offset + controller.position.viewportDimension);
    return (
      layout.firstAsset(first),
      layout.firstAsset(last) + layout.assetCount(last) - 1,
    );
  }

  // i18n-ok: hit-testing mirrors the columns as rows paint them
  bool get _rtl => Directionality.of(context) == TextDirection.rtl;

  /// The asset at [point] of the view, whether a cell is there, and how far
  /// down its row the point is.
  ({int asset, bool cell, double fraction}) _at(Offset point) {
    final y = point.dy + (controller.hasClients ? controller.offset : 0);
    final last = layout.columns - 1;
    var column = (point.dx / layout.cellExtent).floor().clamp(0, last);
    if (_rtl) column = last - column;
    final (asset, cell) = layout.assetAt(y, column);
    final fraction = (y - layout.assetOffset(asset)) / layout.cellExtent;
    return (asset: asset, cell: cell, fraction: fraction.clamp(0.0, 1.0));
  }

  /// Changes to [to], keeping the asset at [point] at the height [y].
  void _snap(Density to, Offset point, {double? y}) {
    if (to == density) return;
    final at = _at(point);
    setState(() {
      density = to;
      _anchor = (asset: at.asset, fraction: at.fraction, y: y ?? point.dy);
    });
    if (to != widget.density) widget.onDensity?.call(to);
  }

  void _pinchStart(ScaleStartDetails details) {
    _focal = details.localFocalPoint;
    _anchor = null;
  }

  void _pinchUpdate(ScaleUpdateDetails details) => setState(() {
    _focal = details.localFocalPoint;
    _scale = details.scale.clamp(
      layout.columns / Density.years.columns(_size.width),
      layout.columns / Density.comfortable.columns(_size.width),
    );
  });

  void _pinchEnd(ScaleEndDetails details) {
    final to = Density.nearest(_size.width, layout.columns / _scale);
    // Where the fingers were before the grid scaled.
    final center = _size.center(Offset.zero);
    final point = center + (_focal - center) / _scale;
    setState(() => _scale = 1);
    _snap(to, point, y: _focal.dy);
  }

  /// The cell the arrow keys are on, ringed; null until one is pressed and
  /// after a pointer goes down.
  int? get cursor => _cursor;
  int? _cursor;

  /// Moves the cursor [dx] cells along or [dy] rows down, the first arrow to
  /// the first cell shown; [extend] selects from the last cell selected.
  void _arrow(int dx, int dy, {bool extend = false}) {
    final from = _cursor;
    var to = from ?? _at(const Offset(0, headerExtent)).asset;
    if (from != null && dx != 0) {
      to = (from + (_rtl ? -dx : dx)).clamp(0, segments.assets - 1);
    } else if (from != null && dy != 0) {
      to = _nextRow(from, dy);
    }
    if (extend) {
      final anchor = _last ??= from ?? to;
      _selection = _selection.add(
        math.min(anchor, to),
        math.max(anchor, to) + 1,
      );
    }
    setState(() => _cursor = to);
    reveal(to);
  }

  /// The asset in [asset]'s column a row up (-1) or down (1), across a day's
  /// header, else in its last cell; [asset] itself past either end.
  int _nextRow(int asset, int dy) {
    final top = layout.assetOffset(asset);
    var y = dy < 0 ? top - 1 : top + layout.cellExtent + 1;
    if (y >= 0 && y < layout.extent && layout.isHeader(layout.childAt(y))) {
      y += dy * layout.headerExtent;
    }
    if (y < 0 || y >= layout.extent) return asset;
    return layout.assetAt(y, layout.assetColumn(asset)).$1;
  }

  /// Space toggles the cursor's cell, Enter opens it.
  void _key(void Function(int cursor) run) {
    if (_cursor case final cursor?) run(cursor);
  }

  Selection get _selection => widget.selection.value;
  set _selection(Selection value) => widget.selection.value = value;

  /// Selects every asset.
  void selectAll() => _selection = Selection.none.add(0, segments.assets);

  /// Selects a segment, or clears it if it is all selected.
  void _toggleSegment(int segment) {
    final (start, end) = layout.assetsOf(segment);
    _selection = _selection.containsAll(start, end)
        ? _selection.remove(start, end)
        : _selection.add(start, end);
  }

  void _tap(TapUpDetails details) {
    final at = _at(details.localPosition);
    if (at.cell) _activate(at.asset);
  }

  /// Opens [asset], or while selecting toggles it; Shift adds the range from
  /// the last, Ctrl or Cmd toggles.
  void _activate(int asset) {
    final keys = HardwareKeyboard.instance;
    final last = _last;
    if (keys.isShiftPressed && last != null) {
      _selection = _selection.add(
        math.min(last, asset),
        math.max(last, asset) + 1,
      );
    } else if (!_selection.isEmpty ||
        keys.isControlPressed ||
        keys.isMetaPressed) {
      _selection = _selection.toggle(asset);
    } else {
      _open(asset);
    }
    _last = asset;
  }

  void _scrollBy(double by) {
    final position = controller.position;
    final to = (position.pixels + by).clamp(0.0, position.maxScrollExtent);
    final duration = Motion.of(context, Motion.short);
    if (duration == Duration.zero) {
      controller.jumpTo(to);
    } else {
      controller.animateTo(to, duration: duration, curve: Motion.curve);
    }
  }

  void _open(int asset) {
    if (widget.pages[asset] != null) widget.onOpen?.call(asset, cellOf(asset));
  }

  /// Where [asset]'s cell is in the view.
  Rect _cell(int asset) {
    final cell = layout.cellExtent;
    var column = layout.assetColumn(asset);
    if (_rtl) column = layout.columns - 1 - column;
    return Offset(
          column * cell,
          layout.assetOffset(asset) - controller.offset,
        ) &
        Size.square(cell);
  }

  /// Where [asset]'s cell is on the screen.
  Rect cellOf(int asset) =>
      _cell(asset).shift(switch (context.findRenderObject()) {
        final RenderBox box => box.localToGlobal(Offset.zero),
        _ => throw StateError('the timeline has no box'),
      });

  /// Scrolls the least that shows [asset]'s cell below the sticky header, as
  /// the viewer moves through the items.
  void reveal(int asset) {
    final top = layout.assetOffset(asset);
    final position = controller.position;
    var to = position.pixels;
    if (to > top - headerExtent) {
      to = top - headerExtent;
    } else if (to < top + layout.cellExtent - position.viewportDimension) {
      to = top + layout.cellExtent - position.viewportDimension;
    }
    controller.jumpTo(to.clamp(0, position.maxScrollExtent));
  }

  /// Selects from where a long press went down, or while selecting
  /// previews the item there until the press moves to another.
  void _dragStart(LongPressStartDetails details) {
    final at = _at(details.localPosition);
    if (!at.cell) return;
    _pointer = details.localPosition;
    if (_selection.isEmpty) return _selectFrom(at.asset);
    _peeked = at.asset;
    _unpeek = peek(
      context,
      ThumbnailAt(at.asset, widget.pages, widget.thumbnails),
    );
  }

  void _selectFrom(int asset) {
    _dragFrom = asset;
    _dragBase = _selection;
    _adding = !_dragBase.contains(asset);
    _dragTo(asset);
    _lastTick = Duration.zero;
    _ticker.start();
  }

  void _endPeek() {
    _unpeek?.call();
    _unpeek = _peeked = null;
  }

  void _dragTo(int asset) {
    final from = _dragFrom;
    if (from == null) return;
    final (start, end) = (math.min(from, asset), math.max(from, asset) + 1);
    _selection = _adding
        ? _dragBase.add(start, end)
        : _dragBase.remove(start, end);
    _last = asset;
  }

  void _dragUpdate(LongPressMoveUpdateDetails details) {
    _pointer = details.localPosition;
    final asset = _at(_pointer).asset;
    if (_peeked case final peeked? when peeked != asset) {
      _endPeek();
      _selectFrom(peeked);
    }
    _dragTo(asset);
  }

  void _dragOut(PointerMoveEvent event) {
    final press = _press;
    if (press == null ||
        _dragFrom != null ||
        (event.localPosition - press).distance <
            computePanSlop(PointerDeviceKind.mouse, null)) {
      return;
    }
    _press = null;
    final at = _at(press);
    if (at.cell && widget.pages[at.asset] != null) {
      // The platform's drag takes the mouse from here: no tap or long press
      // of the grid may fire on it.
      GestureBinding.instance.cancelPointer(event.pointer);
      widget.onDragOut?.call(at.asset);
    }
  }

  void _dragEnd([Object? _]) {
    _endPeek();
    _ticker.stop();
    _dragFrom = null;
    _scrollsItself(false);
  }

  // Its jumps are the user's scroll too, for the decodes (ADR-0114).
  void _scrollsItself(bool scrolling) {
    if (scrolling == _autoScrolling) return;
    _autoScrolling = scrolling;
    _prefetch();
  }

  /// Scrolls while a drag-select holds the pointer near an edge: a screen a
  /// second at the edge, faster the longer it is held.
  void _autoScroll(Duration elapsed) {
    final zone = math.max(48, layout.cellExtent / 2);
    final depth = _pointer.dy < zone
        ? _pointer.dy - zone
        : _pointer.dy > _size.height - zone
        ? _pointer.dy - (_size.height - zone)
        : 0.0;
    final seconds = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _scrollsItself(depth != 0);
    if (depth == 0) return;
    final position = controller.position;
    final speed = depth / zone * _size.height * (1 + elapsed.inSeconds);
    controller.jumpTo(
      (position.pixels + speed * seconds).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
    );
    _dragTo(_at(_pointer).asset);
  }

  // Decodes follow the scroll at any speed; the visible items are reported
  // once it is slow enough to read, and when it ends.
  void _prefetch({bool ended = false}) {
    if (!controller.hasClients) return;
    final (first, last) = visible;
    final position = controller.position;
    if (position.pixels != _lastOffset) {
      _forward = position.pixels > _lastOffset;
    }
    widget.thumbnails.focus(
      first,
      last,
      forward: _forward,
      scrolling: _autoScrolling || !ended && position.isScrollingNotifier.value,
    );
    _lastOffset = position.pixels;
    final settled = ended || !position.recommendDeferredLoading(context);
    if (settled && _reported != (first, last)) {
      _reported = (first, last);
      widget.onVisible?.call(first, last);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final formats = Formats(strings);
    final style = Theme.of(context).textTheme.titleSmall;
    final grouping = density.grouping(widget.grouping);
    segments = widget.buckets.grouped(
      grouping,
      firstDay: formats.firstDayOfWeek,
    );
    String label(int segment) => switch ((segments.day(segment), grouping)) {
      (null, _) => strings.timelineUndated,
      (final day?, Grouping.month) => formats.month(day),
      (final day?, Grouping.week) => strings.timelineWeek(formats.date(day)),
      (final day?, Grouping.day) => formats.date(day),
    };
    Widget header(int segment) => TimelineHeader(
      label: label(segment),
      style: style,
      assets: layout.assetsOf(segment),
      selection: widget.selection,
      onTap: () => _toggleSegment(segment),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        _lay(constraints.biggest);
        final tier = tierFor(
          layout.cellExtent * MediaQuery.devicePixelRatioOf(context),
        );
        return CallbackShortcuts(
          bindings: _shortcuts(),
          child: Focus(
            focusNode: _focus,
            autofocus: true,
            child: Listener(
              onPointerDown: (_) {
                _focus.requestFocus();
                if (_cursor != null) setState(() => _cursor = null);
              },
              child: Stack(
                children: [
                  _grid(_rows(tier, strings, formats, label, header)),
                  if (_cursor case final cursor?) _ring(cursor),
                  _sticky(header),
                  PositionedDirectional(
                    top: 0,
                    bottom: 0,
                    end: 0,
                    child: TimelineScrubber(
                      controller: controller,
                      layout: layout,
                      buckets: segments,
                      thumbnails: widget.thumbnails,
                      formats: formats,
                      label: strings.timelineScrubber,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Lays the segments out across [size], keeping the asset a change of
  /// density anchored where it was.
  void _lay(Size size) {
    // A rotation or a resized window keeps the item at the top.
    if (_size.width > 0 &&
        size.width != _size.width &&
        _anchor == null &&
        controller.hasClients) {
      final at = _at(const Offset(0, headerExtent));
      _anchor = (asset: at.asset, fraction: at.fraction, y: headerExtent);
    }
    _size = size;
    final columns = density.columns(_size.width);
    layout = TimelineLayout(
      segments.counts,
      columns: columns,
      cellExtent: _size.width / columns,
      headerExtent: headerExtent,
    );
    if (_anchor case final anchor? when controller.hasClients) {
      _anchor = null;
      controller.position.correctPixels(
        (layout.assetOffset(anchor.asset) +
                anchor.fraction * layout.cellExtent -
                anchor.y)
            .clamp(0, math.max(0, layout.extent - _size.height)),
      );
    }
    SchedulerBinding.instance.addPostFrameCallback((_) => _prefetch());
  }

  Map<ShortcutActivator, VoidCallback> _shortcuts() => {
    primary(LogicalKeyboardKey.keyA): selectAll,
    const SingleActivator(LogicalKeyboardKey.escape): () =>
        _selection = Selection.none,
    const SingleActivator(LogicalKeyboardKey.pageDown): () =>
        _scrollBy(_size.height * 0.9),
    const SingleActivator(LogicalKeyboardKey.pageUp): () =>
        _scrollBy(-_size.height * 0.9),
    const SingleActivator(LogicalKeyboardKey.home): () =>
        _scrollBy(-double.infinity),
    const SingleActivator(LogicalKeyboardKey.end): () =>
        _scrollBy(double.infinity),
    for (final (key, dx, dy) in const [
      (LogicalKeyboardKey.arrowLeft, -1, 0),
      (LogicalKeyboardKey.arrowRight, 1, 0),
      (LogicalKeyboardKey.arrowUp, 0, -1),
      (LogicalKeyboardKey.arrowDown, 0, 1),
    ])
      for (final shift in const [false, true])
        SingleActivator(key, shift: shift): () => _arrow(dx, dy, extend: shift),
    const SingleActivator(LogicalKeyboardKey.space): () => _key((c) {
      _selection = _selection.toggle(c);
      _last = c;
    }),
    const SingleActivator(LogicalKeyboardKey.enter): () => _key(_open),
  };

  // Mouse drags out start on the grid, not on the scrubber or the sticky
  // header above it.
  Widget _grid(SliverChildDelegate rows) => Listener(
    onPointerDown: (event) {
      final mouse =
          event.kind == PointerDeviceKind.mouse &&
          event.buttons == kPrimaryMouseButton;
      _press = mouse ? event.localPosition : null;
      final (:asset, :cell, fraction: _) = _at(event.localPosition);
      if (cell && _scale == 1) widget.onPress?.call(asset);
    },
    onPointerMove: _dragOut,
    onPointerUp: (_) => _press = null,
    child: RawGestureDetector(
      gestures: _gestures(),
      child: ClipRect(
        child: Transform.scale(
          scale: _scale,
          origin: _focal - _size.center(Offset.zero),
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (_) {
              _prefetch(ended: true);
              return false;
            },
            child: CustomScrollView(
              controller: controller,
              // Two screens either side are built, so that their thumbnails
              // are wanted before they show.
              scrollCacheExtent: const ScrollCacheExtent.viewport(2),
              slivers: [SliverTimeline(timeline: layout, delegate: rows)],
            ),
          ),
        ),
      ),
    ),
  );

  Map<Type, GestureRecognizerFactory<GestureRecognizer>> _gestures() => {
    TapGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(debugOwner: this),
          (tap) => tap.onTapUp = _tap,
        ),
    LongPressGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(debugOwner: this),
          (press) => press
            ..onLongPressStart = _dragStart
            ..onLongPressMoveUpdate = _dragUpdate
            ..onLongPressEnd = _dragEnd
            ..onLongPressCancel = _dragEnd,
        ),
    PinchRecognizer: GestureRecognizerFactoryWithHandlers<PinchRecognizer>(
      () => PinchRecognizer(debugOwner: this),
      (pinch) => pinch
        ..onStart = _pinchStart
        ..onUpdate = _pinchUpdate
        ..onEnd = _pinchEnd,
    ),
  };

  /// The segments' headers and rows, whose cells show [tier] thumbnails.
  SliverChildDelegate _rows(
    int tier,
    AppLocalizations strings,
    Formats formats,
    String Function(int segment) label,
    Widget Function(int segment) header,
  ) {
    final columns = layout.columns;
    return SliverChildBuilderDelegate(
      (context, i) {
        final segment = layout.segmentOf(i);
        if (layout.isHeader(i)) {
          return header(segment);
        }
        final (start, end) = layout.assetsOf(segment);
        return TimelineRow(
          first: layout.firstAsset(i),
          count: layout.assetCount(i),
          columns: columns,
          tier: tier,
          view: widget,
          clock: formats.duration,
          cannotPlay: strings.timelineCannotPlay,
          noHeic: noHeicText(strings),
          excluded: strings.timelineExcluded,
          sphere: strings.timelineSphere,
          markLabel: (mark) => strings.mark(mark.name),
          describe: (asset, {failed = false}) =>
              (failed ? strings.timelineCellNoPreview : strings.timelineCell)(
                label(segment),
                asset - start + 1,
                end - start,
              ),
          onTap: _activate,
          onLongPress: (asset) => _selection = _selection.toggle(asset),
        );
      },
      childCount: layout.childCount,
      addAutomaticKeepAlives: false,
    );
  }

  /// The ring around the [cursor]'s cell.
  Widget _ring(int cursor) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Positioned.fromRect(
      key: const ValueKey('cursor'),
      rect: _cell(cursor),
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
        ),
      ),
    ),
  );

  /// The header of the segment at the top, until the next one's pushes it away.
  Widget _sticky(Widget Function(int segment) header) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final offset = controller.hasClients ? controller.offset : 0.0;
      final segment = layout.segmentAt(offset);
      if (layout.segmentCount == 0 || offset <= layout.segmentOffset(segment)) {
        return const SizedBox.shrink();
      }
      final next = segment + 1 < layout.segmentCount
          ? layout.segmentOffset(segment + 1)
          : double.infinity;
      return PositionedDirectional(
        top: math.min(0, next - offset - headerExtent),
        start: 0,
        end: 0,
        height: headerExtent,
        child: Material(child: header(segment)),
      );
    },
  );
}
