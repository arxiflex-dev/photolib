import 'dart:math';

import 'package:material_ui/material_ui.dart';

import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/adaptive.dart';

/// Takes the app bar's place while items are selected: how many, a way out,
/// select all, a slideshow, download (share on phones) and the bulk
/// [actions].
class SelectionBar extends StatelessWidget implements PreferredSizeWidget {
  /// The bar of [count] selected items.
  const new({
    required this.count,
    required this.onClear,
    required this.onDownload,
    this.onSelectAll,
    this.onSlideshow,
    this.actions = const [],
    super.key,
  });

  /// How many items are selected.
  final int count;

  /// Clears the selection.
  final VoidCallback onClear;

  /// Selects every item, when the bar offers it.
  final VoidCallback? onSelectAll;

  /// Plays the selected items as a slideshow, when the bar offers it.
  final VoidCallback? onSlideshow;

  /// Downloads, or on phones shares, the selected items.
  final VoidCallback onDownload;

  /// The bulk actions after these.
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final scale = MediaQuery.textScalerOf(context);
    // Select all stays on the bar: it is how a selection starts to grow.
    final selectAll = onSelectAll == null
        ? null
        : IconButton(
            icon: const Icon(Icons.select_all),
            tooltip: strings.selectAll,
            onPressed: onSelectAll,
          );
    final buttons = <IconButton>[
      if (onSlideshow != null)
        IconButton(
          icon: const Icon(Icons.slideshow_outlined),
          tooltip: strings.slideshow,
          onPressed: onSlideshow,
        ),
      IconButton(
        icon: Icon(
          sharesDownloads ? Icons.share_outlined : Icons.download_outlined,
        ),
        tooltip: sharesDownloads ? strings.actionShare : strings.download,
        onPressed: onDownload,
      ),
      ...actions.whereType<IconButton>(),
    ];
    // Other widgets, as a menu of their own, always show.
    final others = [
      for (final action in actions)
        if (action is! IconButton) action,
    ];
    return LayoutBuilder(
      builder: (context, box) {
        // The close button and the count keep their room; what is left holds
        // 48 dp buttons, and the first that do not fit fold into one menu.
        final fit =
            ((box.maxWidth -
                        kToolbarHeight -
                        min(scale.scale(144), box.maxWidth * 0.4)) /
                    _slot)
                .floor();
        final room = fit - others.length - (selectAll == null ? 0 : 1);
        final folded = buttons.length <= room
            ? 0
            : buttons.length - (room > 1 ? room - 1 : 0);
        return AppBar(
          backgroundColor: scheme.secondaryContainer,
          foregroundColor: scheme.onSecondaryContainer,
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: strings.selectionClear,
            onPressed: onClear,
          ),
          // Large text shrinks to fit rather than losing the count to an
          // ellipsis.
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(strings.selectionCount(count)),
          ),
          actions: [
            if (folded > 0) _overflow(context, buttons.take(folded)),
            ?selectAll,
            ...buttons.skip(folded),
            ...others,
          ],
        );
      },
    );
  }

  /// The menu the [folded] buttons are in, each as its icon and tooltip.
  static Widget _overflow(BuildContext context, Iterable<IconButton> folded) =>
      PopupMenuButton<VoidCallback>(
        tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
        onSelected: (action) => action(),
        itemBuilder: (_) => [
          for (final button in folded)
            PopupMenuItem(
              enabled: button.onPressed != null,
              value: button.onPressed,
              child: Row(
                children: [
                  button.icon,
                  const SizedBox(width: 16),
                  Flexible(child: Text(button.tooltip ?? '')),
                ],
              ),
            ),
        ],
      );
}

/// The width of a button of the bar.
const _slot = 48.0;
