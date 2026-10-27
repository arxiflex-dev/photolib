import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// An app that edits pictures.
typedef Editor = ({String package, String label});

/// Where the phone stands on being the default gallery: `isDefault` for
/// opening pictures, the default `camera`'s name (which decides what the
/// camera's thumbnail opens, ADR-0039) and whether launchers take `shortcuts`.
typedef GalleryStatus = ({bool isDefault, String? camera, bool shortcuts});

/// The system screens onboarding opens.
enum SystemScreen {
  /// The default apps.
  defaultApps,

  /// The request to manage media, which spares each trash and delete dialog.
  manageMedia,

  /// The app's notifications.
  notifications,

  /// The app's details, where every permission is.
  details,
}

/// Where a wallpaper goes.
enum WallpaperTarget {
  /// The home screen.
  home,

  /// The lock screen.
  lock,

  /// Both.
  both,
}

/// What a default gallery does beside answering intents; GalleryActions.kt.
abstract interface class GalleryPlatform {
  /// The apps that edit a picture of [mime].
  Future<List<Editor>> editors(String mime);

  /// Hands the picture at [uri] to the editor [package] (any, when null) as a
  /// copy it may write, and returns the edited picture as JPEG, null when it
  /// changed nothing.
  Future<Uint8List?> editWith(Uri uri, String mime, String? package);

  /// Opens the item at [uri] in the app the user picks (a video player, for
  /// one), which may read it; Photolib is not offered.
  Future<void> openWith(Uri uri, String? mime);

  /// Sets the picture at [uri] as the wallpaper of [target].
  Future<void> setWallpaper(Uri uri, WallpaperTarget target);

  /// Whether Photolib is the default and what the camera is.
  Future<GalleryStatus> status();

  /// Opens [screen]; false when the phone has no such screen.
  Future<bool> open(SystemScreen screen);

  /// Offers to pin a shortcut named [label] to [link] on the home screen;
  /// false when the launcher cannot.
  Future<bool> pinShortcut(String id, String label, Uri link);

  /// The folder the widgets read their snapshot from.
  Future<String> widgetsDir();

  /// Draws the placed widgets again.
  Future<void> updateWidgets();
}

/// GalleryActions.kt, over `org.photolib/gallery`.
class GalleryChannel implements GalleryPlatform {
  /// The channel.
  const new();

  static const _channel = MethodChannel('org.photolib/gallery');

  @override
  Future<List<Editor>> editors(String mime) async => [
    for (final Map<Object?, Object?> e
        in await _channel.invokeListMethod<Map<Object?, Object?>>(
              'editors',
              mime,
            ) ??
            const <Map<Object?, Object?>>[])
      (package: e['package']! as String, label: e['label']! as String),
  ];

  @override
  Future<Uint8List?> editWith(Uri uri, String mime, String? package) =>
      _channel.invokeMethod<Uint8List>('editWith', ['$uri', mime, package]);

  @override
  Future<void> openWith(Uri uri, String? mime) =>
      _channel.invokeMethod('openWith', ['$uri', mime]);

  @override
  Future<void> setWallpaper(Uri uri, WallpaperTarget target) =>
      _channel.invokeMethod('setWallpaper', ['$uri', target.name]);

  @override
  Future<GalleryStatus> status() async {
    final s =
        await _channel.invokeMapMethod<String, Object?>('status') ?? const {};
    return (
      isDefault: s['default'] == true,
      camera: s['camera'] as String?,
      shortcuts: s['shortcuts'] == true,
    );
  }

  @override
  Future<bool> open(SystemScreen screen) async =>
      await _channel.invokeMethod<bool>('open', screen.name) ?? false;

  @override
  Future<bool> pinShortcut(String id, String label, Uri link) async =>
      await _channel.invokeMethod<bool>('pinShortcut', [id, label, '$link']) ??
      false;

  @override
  Future<String> widgetsDir() async =>
      (await _channel.invokeMethod<String>('widgetsDir'))!;

  @override
  Future<void> updateWidgets() => _channel.invokeMethod('updateWidgets');
}

/// The platform's actions; tests fake them.
final galleryPlatformProvider = Provider<GalleryPlatform>(
  (ref) => const GalleryChannel(),
);
