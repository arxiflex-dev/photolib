import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photolib/core/device_library.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/settings/settings.dart';
import 'package:photolib_data/photolib_data.dart';

/// The platform of each source of device items (docs/10-client-app.md §5.4):
/// MediaStore or PhotoKit for the device's library, and for a desktop's or
/// browser's folders the Trash on macOS, the freedesktop.org trash on Linux,
/// else Photolib's own bin.
final mediaPlatformProvider = Provider<MediaPlatform Function(String source)>((
  ref,
) {
  final device = ref.watch(deviceLibraryProvider);
  final folders = !kIsWeb && Platform.isMacOS
      ? const _MacTrash()
      : desktopTrash();
  return (source) =>
      source == 'folder' ? folders : device as MediaPlatform? ?? folders;
});

/// The one way items are deleted (ADR-0245).
final deletionProvider = FutureProvider<DeletionService>(
  (ref) async => DeletionService(
    await ref.watch(replicaProvider.future),
    ref.watch(mediaPlatformProvider),
    retention: Duration(
      days: ref.watch(settingsProvider.select((s) => s.trashDays)),
    ),
  ),
);

/// macOS's Trash through MediaRequests.swift, which Finder restores from.
class _MacTrash implements MediaPlatform {
  const new();

  static const _channel = MethodChannel('org.photolib/media_requests');

  static String _file(LocalAssetData a) => '${a.volume}/${a.path}';

  @override
  bool get expires => false;

  @override
  bool get restores => true;

  @override
  Future<bool> asksFirst() async => false;

  @override
  Future<List<Binned>> trash(List<LocalAssetData> items) async => [
    for (final bin
        in await _channel.invokeListMethod<String>('trash', [
              for (final a in items) _file(a),
            ]) ??
            const <String>[])
      (bin: bin, expires: null),
  ];

  @override
  Future<void> restore(List<LocalAssetData> items) =>
      _channel.invokeMethod('restore', [
        for (final a in items) ...[_file(a), a.bin],
      ]);

  @override
  Future<void> purge(List<LocalAssetData> items) =>
      _channel.invokeMethod('purge', [for (final a in items) ?a.bin]);

  @override
  Future<void> favorite(
    List<LocalAssetData> items, {
    required bool value,
  }) async {}
}
