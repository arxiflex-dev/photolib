/// The local store: the replica's schema, its migrations and the data isolate that is its one writer, opened only
/// through the vault, which keys every database and file under the device data key.
library;

export 'package:drift/drift.dart'
    show BooleanExpressionOperators, InsertMode, StringExpressionOperators;
export 'src/albums.dart';
export 'src/backup.dart';
export 'src/deletion.dart' hide bySource, chunked, rowsOf;
export 'src/device_folders.dart';
export 'src/faces.dart';
export 'src/files_native.dart'
    if (dart.library.js_interop) 'src/files_web.dart';
export 'src/folder_indexer.dart';
export 'src/folder_watcher.dart'
    if (dart.library.js_interop) 'src/browser_folders.dart';
export 'src/folders.dart';
export 'src/geo.dart';
export 'src/hints.dart';
export 'src/ignore.dart';
export 'src/journal.dart';
export 'src/keys.dart' show KernelError, openMlSection, sealMlSection;
export 'src/local_only.dart' show deviceTables, localOnlyCount;
export 'src/map_index.dart';
export 'src/media_store.dart';
export 'src/metadata.dart';
export 'src/ml.dart';
export 'src/offline_media.dart';
export 'src/offline_plan.dart';
export 'src/offline_policy.dart';
export 'src/offline_store.dart';
export 'src/offline_sync.dart';
export 'src/open_native.dart'
    if (dart.library.js_interop) 'src/open_web.dart'
    show
        backupReplica,
        extractFirst,
        extractMetadata,
        forgetReplica,
        onDataConnection,
        reportDeviceHealth,
        syncReplica;
export 'src/organise.dart';
export 'src/photo_kit.dart';
export 'src/recovery_code.dart';
export 'src/replica.dart';
export 'src/search.dart';
export 'src/source_tree.dart';
export 'src/sync.dart';
export 'src/top_person.dart';
export 'src/vault.dart';
export 'src/vault_cache.dart';
export 'src/versions.dart';
