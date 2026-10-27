import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/offline/offline.dart';
import 'package:photolib/l10n/app_localizations.dart';

import 'pages.dart';
import 'thumbnails.dart';

/// The icon of a [Mark] on a cell.
IconData markIcon(Mark mark) => switch (mark) {
  Mark.favourite => Icons.favorite,
  // A crossed-out picture: the eye is a hidden source's (ADR-0290).
  Mark.hidden => Icons.hide_image,
  Mark.archived => Icons.archive,
};

/// The mark of a cell whose decode failed.
IconData failureMark(Object error) => switch (error) {
  NoThumbnail(unplayable: true) => Icons.videocam_off_outlined,
  NoThumbnail(video: true) => Icons.videocam_outlined,
  _ => Icons.broken_image_outlined,
};

/// What a HEIC no decoder takes says on a desktop with no HEVC decoder to
/// install: connected mode or a Mac, never a codec (ADR-0214).
String noHeicText(AppLocalizations strings) =>
    defaultTargetPlatform == TargetPlatform.windows
    ? strings.timelineNoHeicWindows
    : strings.timelineNoHeicLinux;

/// The [failureMark] of [error], filling its box, which says why on hover or
/// a long press: the way out for a HEIC no decoder takes, else the cause.
class FailureMark extends StatelessWidget {
  const FailureMark(
    this.error, {
    super.key,
    this.size,
    this.trigger = TooltipTriggerMode.longPress,
  });

  final Object error;
  final double? size;
  final TooltipTriggerMode trigger;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: switch (error) {
      NoThumbnail(noHevc: true) => noHeicText(AppLocalizations.of(context)),
      NoThumbnail(:final cause) => cause,
      // error-ok: the technical cause, behind a long press (ADR-0070)
      _ => '$error',
    },
    triggerMode: trigger,
    child: Icon(
      failureMark(error),
      size: size,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}

/// The thumbnail of the item at a timeline position at the grid's tier, so
/// that what the grid holds in memory paints at once and what it left in the
/// disk cache needs no decode of the original; else a placeholder, or the
/// mark of a failed decode. Its list builds it where it shows, so it decodes
/// wherever the grid looks, once [after] is true.
class ThumbnailAt extends StatefulWidget {
  const ThumbnailAt(
    this.asset,
    this.pages,
    this.thumbnails, {
    super.key,
    this.after,
    this.item,
  });

  final int asset;
  final TimelinePages pages;
  final Thumbnails thumbnails;
  final ValueListenable<bool>? after;

  /// What shows instead of the item at [asset].
  final Object? item;

  @override
  State<ThumbnailAt> createState() => _ThumbnailAtState();
}

class _ThumbnailAtState extends State<ThumbnailAt> {
  Object? _item;
  var _tier = 0, _wanted = false;

  @override
  void initState() {
    super.initState();
    widget.pages.addListener(_load);
    widget.after?.addListener(_load);
    _load();
  }

  @override
  void didUpdateWidget(ThumbnailAt old) {
    super.didUpdateWidget(old);
    if (old.asset != widget.asset || old.item != widget.item) {
      _unwant();
      _load();
    }
  }

  @override
  void dispose() {
    widget.pages.removeListener(_load);
    widget.after?.removeListener(_load);
    _unwant();
    super.dispose();
  }

  void _ready() => setState(() {});

  void _load() {
    final item = widget.item ?? widget.pages[widget.asset];
    if (item == null) return;
    if (item != _item) {
      _unwant();
      _item = item;
      _tier = widget.thumbnails.tier;
      setState(() {});
    }
    if (!_wanted && (widget.after?.value ?? true)) {
      _wanted = true;
      widget.thumbnails.want(item, _tier, _ready, at: widget.asset, own: true);
    }
  }

  void _unwant() {
    if (_wanted) widget.thumbnails.unwant(_item!, _tier, _ready);
    _wanted = false;
    _item = null;
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final image = item == null ? null : widget.thumbnails.shown(item, _tier);
    final failure = item == null
        ? null
        : widget.thumbnails.failure(item, _tier);
    final video =
        item != null && (widget.thumbnails.video?.call(item) ?? false);
    final marks = item is ThumbnailItem ? item.marks : const <Mark>{};
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              RawImage(image: image, fit: BoxFit.cover)
            else if (failure != null)
              FailureMark(failure)
            else
              Icon(
                video ? Icons.movie_outlined : Icons.image_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            if (marks.isNotEmpty) MarkBadges(marks),
            if (item case ThumbnailItem(asset: final asset?)) KeptBadge(asset),
          ],
        ),
      ),
    );
  }
}

/// An item's marks along the bottom start of its cell, each said to a screen
/// reader.
class MarkBadges extends StatelessWidget {
  /// The badges of [marks].
  const new(this.marks, {super.key});

  /// What the item is marked as.
  final Set<Mark> marks;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return PositionedDirectional(
      start: 4,
      bottom: 4,
      child: Row(
        children: [
          for (final mark in Mark.values)
            if (marks.contains(mark))
              Icon(
                markIcon(mark),
                size: 16,
                color: Colors.white,
                shadows: const [Shadow(blurRadius: 2)],
                semanticLabel: strings.mark(mark.name),
              ),
        ],
      ),
    );
  }
}

/// A pin at the top end of a cell whose asset this device keeps whole, said
/// to a screen reader (ADR-0200 P2).
class KeptBadge extends ConsumerWidget {
  /// The badge of the asset [asset], shown while it is kept.
  const new(this.asset, {super.key});

  /// The asset's id.
  final Uint8List asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hex = [for (final b in asset) b.toRadixString(16).padLeft(2, '0')]
        .join();
    final kept = ref.watch(
      offlineKeptProvider.select((s) => s.value?.contains(hex) ?? false),
    );
    if (!kept) return const SizedBox.shrink();
    return PositionedDirectional(
      end: 4,
      top: 4,
      child: Icon(
        Icons.push_pin,
        size: 14,
        color: Colors.white,
        shadows: const [Shadow(blurRadius: 2)],
        semanticLabel: AppLocalizations.of(context).mark('offline'),
      ),
    );
  }
}
