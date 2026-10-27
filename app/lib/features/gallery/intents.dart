import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photolib/features/gallery/gallery_intent.dart';

/// Where other apps' intents come from: GalleryIntents.kt on Android.
abstract interface class IntentSource {
  /// The intent that started the activity, once; null when the launcher did.
  Future<GalleryIntent?> initial();

  /// The intents the running activity is sent.
  Stream<GalleryIntent> get incoming;

  /// Answers a pick with [uris], readable by the caller, and closes.
  Future<void> pick(List<Uri> uris);

  /// Answers a pick with nothing, and closes.
  Future<void> cancel();

  /// Closes the activity that was started for another app, which then shows
  /// again.
  Future<void> done();
}

/// GalleryIntents.kt, over `org.photolib/intents`.
class IntentsChannel implements IntentSource {
  /// The channel; its handler is set once.
  new() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'intent') {
        final intent = GalleryIntent.fromMap(call.arguments as Map);
        if (intent != null) _incoming.add(intent);
      }
    });
  }

  static const _channel = MethodChannel('org.photolib/intents');
  final _incoming = StreamController<GalleryIntent>.broadcast();

  @override
  Stream<GalleryIntent> get incoming => _incoming.stream;

  @override
  Future<GalleryIntent?> initial() async {
    final raw = await _channel.invokeMapMethod<Object?, Object?>('initial');
    return raw == null ? null : GalleryIntent.fromMap(raw);
  }

  @override
  Future<void> pick(List<Uri> uris) =>
      _channel.invokeMethod('pick', [for (final u in uris) '$u']);

  @override
  Future<void> cancel() => _channel.invokeMethod('cancel');

  @override
  Future<void> done() => _channel.invokeMethod('done');
}

/// Nothing to hear: every other platform.
class NoIntents implements IntentSource {
  /// None.
  const new();

  @override
  Stream<GalleryIntent> get incoming => const Stream.empty();

  @override
  Future<GalleryIntent?> initial() async => null;

  @override
  Future<void> pick(List<Uri> uris) async {}

  @override
  Future<void> cancel() async {}

  @override
  Future<void> done() async {}
}

/// Whether other apps ask this platform for pictures: Android does. (Tests
/// run as Android on a desktop, whose channel never answers: they say yes only
/// when they fake the channel.)
final galleryIntentsProvider = Provider<bool>(
  (ref) => !kIsWeb && Platform.isAndroid,
);

/// The intents of other apps; tests fake it.
final intentSourceProvider = Provider<IntentSource>(
  (ref) =>
      ref.watch(galleryIntentsProvider) ? IntentsChannel() : const NoIntents(),
);

/// The intent that started this activity, once; null for a launch from the
/// launcher or a platform without them.
final initialIntentProvider = FutureProvider<GalleryIntent?>((ref) async {
  if (!ref.watch(galleryIntentsProvider)) return null;
  try {
    return await ref.read(intentSourceProvider).initial();
  } on MissingPluginException {
    return null;
  }
});
