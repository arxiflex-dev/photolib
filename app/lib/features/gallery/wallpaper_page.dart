import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/features/folders/folders_page.dart'
    show Cover, pageThumbnails;
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib/ui/tokens.dart';

/// Set as wallpaper (MOB-12, ADR-0401): a preview of [item] in the shape of
/// the screen, and the choice of the home screen, the lock screen or both.
class WallpaperPage extends ConsumerStatefulWidget {
  /// The page.
  const new(this.item, {super.key});

  /// The photo.
  final ThumbnailItem item;

  /// Opens the page over the viewer.
  static Future<void> show(BuildContext context, ThumbnailItem item) =>
      Navigator.of(
        context,
        rootNavigator: true,
      ).push(MaterialPageRoute<void>(builder: (_) => WallpaperPage(item)));

  @override
  ConsumerState<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends ConsumerState<WallpaperPage> {
  late final Thumbnails _thumbnails = pageThumbnails(ref);
  WallpaperTarget _target = WallpaperTarget.both;
  bool _busy = false;

  @override
  void dispose() {
    _thumbnails.clear();
    super.dispose();
  }

  Future<void> _set() async {
    final strings = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _busy = true);
    try {
      await ref
          .read(galleryPlatformProvider)
          .setWallpaper(widget.item.uri, _target);
      messenger.showSnackBar(
        SnackBar(content: Text(strings.galleryWallpaperDone)),
      );
      navigator.pop();
    } on PlatformException {
      messenger.showSnackBar(
        SnackBar(content: Text(strings.galleryWallpaperFailed)),
      );
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final tokens = AppTokens.of(context);
    final screen = MediaQuery.sizeOf(context);
    final labels = {
      WallpaperTarget.home: strings.galleryWallpaperHome,
      WallpaperTarget.lock: strings.galleryWallpaperLock,
      WallpaperTarget.both: strings.galleryWallpaperBoth,
    };
    return Scaffold(
      appBar: AppBar(title: Text(strings.galleryWallpaper)),
      body: ListView(
        padding: EdgeInsets.all(tokens.md),
        children: [
          // The preview has the screen's shape, as the wallpaper will crop.
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: AspectRatio(
                aspectRatio: screen.width / screen.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(tokens.md),
                  child: Cover(widget.item, _thumbnails),
                ),
              ),
            ),
          ),
          SizedBox(height: tokens.md),
          RadioGroup<WallpaperTarget>(
            groupValue: _target,
            onChanged: (target) => setState(() => _target = target ?? _target),
            child: Column(
              children: [
                for (final MapEntry(:key, :value) in labels.entries)
                  RadioListTile<WallpaperTarget>(
                    contentPadding: EdgeInsets.zero,
                    value: key,
                    title: Text(value),
                  ),
              ],
            ),
          ),
          SizedBox(height: tokens.md),
          FilledButton(
            onPressed: _busy ? null : () => unawaited(_set()),
            child: Text(strings.galleryWallpaper),
          ),
        ],
      ),
    );
  }
}
