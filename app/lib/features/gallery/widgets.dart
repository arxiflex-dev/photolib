// The snapshot is written on the app's own isolate, not the root's.
// ignore_for_file: avoid_slow_async_io

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photolib/core/device_library.dart';
import 'package:photolib/core/logging.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/folders/sorting.dart';
import 'package:photolib/features/gallery/actions.dart';
import 'package:photolib/features/gallery/intents.dart';
import 'package:photolib/features/gallery/shortcuts.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/library/timeline/providers.dart';
import 'package:photolib/features/library/timeline/thumbnails.dart';
import 'package:photolib/features/search/search.dart' show itemOf;
import 'package:photolib/l10n/app_localizations.dart';
import 'package:photolib_data/photolib_data.dart';

const _log = Logger('photolib.widgets');

/// What a home-screen widget shows: a picture under a `title`, which a tap
/// opens at `link`.
typedef WidgetPicture = ({String title, ThumbnailItem item, Uri link});

/// What the Android widgets show today (MOB-11, ADR-0401), by kind: a
/// `memories` picture of this day in years past, the latest `favourites`, the
/// cover of the first album (`albums`) and the cover of the person with most
/// faces (`people`). A kind the library has nothing for is left out; every
/// picture comes from a query that keeps out the folders the user hides.
Future<Map<String, WidgetPicture>> widgetPictures(
  Replica db,
  DateTime today, {
  required String favourites,
}) async {
  final pictures = <String, WidgetPicture>{};
  final memory = (await onThisDay(db, today)).firstOrNull;
  if (memory != null) {
    pictures['memories'] = (
      title: '${memory.day ~/ 10000}',
      item: ThumbnailItem.local(memory),
      link: Uri(scheme: 'photolib', path: '/library'),
    );
  }
  final liked = await favouriteItems(db).first;
  if (liked.isNotEmpty) {
    final latest = liked.reduce((a, b) => takenOf(a) >= takenOf(b) ? a : b);
    pictures['favourites'] = (
      title: favourites,
      item: itemOf(latest),
      link: Uri(scheme: 'photolib', path: '/collections/favourites'),
    );
  }
  final album = (await albumChildren(
    db,
    null,
  ).first).where((a) => !a.folder && a.cover != null).firstOrNull;
  if (album != null) {
    pictures['albums'] = (
      title: album.name,
      item: ThumbnailItem.local(album.cover!),
      link: albumLink(album.id, album.name),
    );
  }
  if (await topPerson(db) case final person?) {
    if ((await db.mapItems([person.asset]).get()).firstOrNull
        case final cover?) {
      pictures['people'] = (
        title: person.name,
        item: ThumbnailItem.local(cover),
        link: Uri(scheme: 'photolib', path: '/library'),
      );
    }
  }
  return pictures;
}

/// Writes what the widgets show into [dir] (PhotoWidget.kt reads it, never
/// the library): the pictures, each rendered once by [render] and left out if
/// that fails, then `snapshot.json`, which names them by kind; pictures it no
/// longer names go. True when the widgets have something new to show.
Future<bool> writeWidgetPictures(
  Directory dir,
  Map<String, WidgetPicture> pictures,
  Future<Uint8List> Function(ThumbnailItem item) render,
) async {
  await dir.create(recursive: true);
  // A file is complete under its name, or not there.
  Future<void> write(String name, List<int> bytes) async {
    final temp = await File('${dir.path}/$name.tmp').writeAsBytes(bytes);
    await temp.rename('${dir.path}/$name');
  }

  final shown = <String, Map<String, String>>{};
  for (final MapEntry(:key, :value) in pictures.entries) {
    final image = '${value.item.key}.png';
    try {
      if (!await File('${dir.path}/$image').exists()) {
        await write(image, await render(value.item));
      }
      shown[key] = {
        'title': value.title,
        'image': image,
        'link': '${value.link}',
      };
    } on Object catch (error) {
      _log.info('no widget image', fields: {'kind': key, 'cause': '$error'});
    }
  }
  final snapshot = jsonEncode(shown);
  final changed = await File('${dir.path}/snapshot.json')
      .readAsString()
      .then((old) => old != snapshot, onError: (Object _) => true);
  await write('snapshot.json', utf8.encode(snapshot));
  final kept = {'snapshot.json', for (final s in shown.values) s['image']};
  await for (final file in dir.list()) {
    // deletion-ok: a picture of the widgets' snapshot, which the app wrote
    if (!kept.contains(file.uri.pathSegments.last)) await file.delete();
  }
  return changed;
}

/// Keeps the Android widgets' snapshot current: at start and whenever the app
/// leaves the screen; the placed widgets are drawn again when it changed.
final widgetPicturesProvider = Provider<void>((ref) {
  if (!ref.watch(galleryIntentsProvider)) return;
  Future<Uint8List> render(ThumbnailItem item) async {
    final pipeline = await ref.read(thumbnailPipelineProvider.future);
    final image = await pipeline.load(item, 512, Tile());
    try {
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      return png?.buffer.asUint8List() ?? (throw StateError('not encoded'));
    } finally {
      image.dispose();
    }
  }

  final write = Coalesced(() async {
    try {
      final platform = ref.read(galleryPlatformProvider);
      final dir = Directory(await platform.widgetsDir());
      final db = await ref.read(replicaProvider.future);
      final strings = lookupAppLocalizations(
        ui.PlatformDispatcher.instance.locale,
      );
      final pictures = await widgetPictures(
        db,
        DateTime.now(),
        favourites: strings.searchFavourites,
      );
      if (await writeWidgetPictures(dir, pictures, render)) {
        await platform.updateWidgets();
      }
    } on Object catch (error, stack) {
      _log.warning(
        'widget pictures not written',
        error: error,
        stackTrace: stack,
      );
    }
  });
  unawaited(write());
  final lifecycle = AppLifecycleListener(onHide: write.call);
  ref.onDispose(lifecycle.dispose);
});
