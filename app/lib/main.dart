import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/on_device_faces.dart';
import 'package:photolib/core/on_device_ml.dart';
import 'package:photolib/core/on_device_ocr.dart';
import 'package:photolib/core/share_inbox.dart';
import 'package:photolib/core/widget_snapshot.dart';
import 'package:photolib/features/desktop/file_drag.dart';
import 'package:photolib/features/gallery/widgets.dart';
import 'package:photolib/features/viewer/mpv.dart'
    if (dart.library.js_interop) 'package:photolib/features/viewer/mpv_web.dart';

import 'app.dart';
import 'core/errors.dart';
import 'core/log_native.dart' if (dart.library.js_interop) 'core/log_web.dart';
import 'core/logging.dart';
import 'core/observers.dart';
import 'core/providers.dart';

Future<void> main([List<String> args = const []]) async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Roboto',
    ], await rootBundle.loadString('assets/fonts/Roboto-LICENSE.txt'));
  });
  // Elsewhere video_player has the platform's player (docs/10 §4.2).
  if (kIsWeb || Platform.isLinux || Platform.isWindows) MpvPlayers.register();
  // Everything in debug and profile builds, info and above redacted in
  // release (ADR-0115): to the memory log, the log store and the console,
  // natively only in debug builds.
  Log.configure(release: kReleaseMode);
  if (kDebugMode || kIsWeb) Log.records.listen(printLog);
  final container = ProviderContainer(
    observers: const [StateLog()],
    retry: retry,
    // Open with Photolib on Linux and Windows.
    overrides: [
      openedFilesProvider.overrideWithValue(args.map(openedArg).toList()),
    ],
  );
  container
    ..read(memoryLogProvider)
    ..read(logStoreProvider)
    ..read(shareInboxProvider)
    ..read(widgetSnapshotProvider)
    ..read(widgetPicturesProvider)
    // Without a view too, as when the OS runs the backlog in the background.
    ..listen(onDeviceMlProvider, (_, _) {})
    ..listen(onDeviceOcrProvider, (_, _) {})
    ..listen(onDeviceFacesProvider, (_, _) {});
  const log = Logger('photolib.app');
  installErrorHandlers(log);
  watchPlatform();
  unawaited(listenToNativeLog());
  log.info('starting', fields: environment());
  AppLifecycleListener(
    onStateChange: (state) =>
        log.info('lifecycle', fields: {'state': state.name}),
  );
  await runPhotolib(container);
}
