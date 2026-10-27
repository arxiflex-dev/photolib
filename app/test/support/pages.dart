import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/feature_flags.dart';
import 'package:photolib/core/device_library.dart';
import 'package:photolib/core/providers.dart';
import 'package:photolib/features/admin/admin_page.dart';
import 'package:photolib/features/backup/backup.dart';
import 'package:photolib/features/backup/backup_page.dart';
import 'package:photolib/features/folders/device_folders.dart';
import 'package:photolib/features/folders/folders.dart';
import 'package:photolib/features/search/search.dart';
import 'package:photolib_data/photolib_data.dart';

import 'fake_server.dart';
import 'pump_app.dart';

const pseudoLocales = [Locale('en', 'XA'), Locale('ar', 'XB')];
const pages = [
  'library',
  'library_limited',
  'collections',
  'search',
  'settings',
  'folders',
  'viewing',
  'backup',
  'admin',
];

class _Limited extends MediaAccessNotifier {
  @override
  Future<MediaAccess?> build() async => MediaAccess.partial;
}

class _Searching extends SearchQuery {
  @override
  LocalQuery build() => const LocalQuery(text: 'IMG', facets: {Facet.favorite});
}

/// Opens [page] in [locale], with the collections in their customising state
/// because it shows the most controls, the library and Settings as on a
/// desktop with a folder in each state, its folders' tree with a node in each
/// state and visibility, the library also with the partial
/// access of Android 14, the search with results, and the admin console on a
/// fake server.
Future<void> openPage(
  WidgetTester tester,
  Locale locale,
  String page, {
  Size size = const Size(400, 800),
}) async {
  await pumpApp(
    tester,
    size: size,
    locales: [locale],
    overrides: [
      featureFlagsProvider.overrideWithValue(
        FeatureFlags.parse('pseudoLocales'),
      ),
      if (page == 'library_limited')
        mediaAccessProvider.overrideWith(_Limited.new)
      else if (page == 'search') ...[
        searchQueryProvider.overrideWith(_Searching.new),
        searchPageProvider.overrideWith(
          (ref, page) async => (
            count: 3,
            items: [
              for (final (i, name) in [
                'IMG_3.jpg',
                'VID_2.mp4',
                'IMG_1.jpg',
              ].indexed)
                LocalAssetData(
                  id: Uint8List(16)..[15] = i,
                  source: 'mediastore',
                  volume: 'external_primary',
                  sourceId: '$i',
                  size: 1,
                  mtime: i,
                  state: 'present',
                  favorite: 1,
                  trashed: 0,
                  edited: 0,
                  folder: 0,
                  hidden: 0,
                  archived: 0,
                  tile: 0,
                  name: name,
                  mime: name.endsWith('.mp4') ? 'video/mp4' : 'image/jpeg',
                ),
            ],
          ),
        ),
      ] else if (const {'library', 'settings', 'folders'}.contains(page)) ...[
        folderPickerProvider.overrideWithValue(
          ({initialDirectory}) async => null,
        ),
        sourceTreeProvider.overrideWithValue(AsyncData(_tree)),
      ],
      if (page == 'admin') adminClientProvider.overrideWithValue(FakeServer()),
      if (page == 'backup') ...[
        backupStatusProvider.overrideWithValue(
          const AsyncData((
            completed: null,
            first: 1,
            stopped: 'offline',
            pending: 12,
            contact: null,
          )),
        ),
        backupFoldersProvider.overrideWithValue(
          const AsyncData([
            (
              key: 'folder:/home/me/Pictures:',
              source: 'folder',
              volume: '/home/me/Pictures',
              dir: '',
              items: 18240,
            ),
            (
              key: 'folder:/home/me/Pictures:Trip/',
              source: 'folder',
              volume: '/home/me/Pictures',
              dir: 'Trip/',
              items: 300,
            ),
          ]),
        ),
        backupReasonsProvider.overrideWithValue(
          AsyncData([
            BackupReasonsResult(
              state: 'discovered',
              reason: 'folder_new',
              count: 300,
            ),
            BackupReasonsResult(state: 'paused', reason: 'metered', count: 9),
            BackupReasonsResult(
              state: 'failed',
              reason: 'unreadable',
              count: 3,
            ),
          ]),
        ),
      ],
    ],
  );
  Future<void> tap(Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // Settings' entries below on-device indexing.
  Future<void> below(Finder finder) async {
    await tester.scrollUntilVisible(finder, 200);
    await tester.ensureVisible(finder);
    await tester.pump();
    await tap(finder);
  }

  if (page == 'collections') {
    await tap(find.byIcon(Icons.collections_bookmark_outlined));
    await tap(find.byType(TextButton));
  } else if (page == 'search') {
    await tap(find.byIcon(Icons.search));
  } else if (page == 'settings' || page == 'folders') {
    await tap(find.byIcon(Icons.settings_outlined));
    if (page == 'folders') {
      final library = find.byIcon(Icons.folder_special_outlined);
      await tester.scrollUntilVisible(library, 200);
      await tester.ensureVisible(library);
      await tester.pump();
      await tester.tap(library);
      // The scanning folder's progress never settles.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }
  } else if (page == 'viewing') {
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await below(find.byIcon(Icons.photo_outlined));
  } else if (page == 'backup') {
    await tap(find.byIcon(Icons.settings_outlined));
    await below(find.byIcon(Icons.backup_outlined));
  } else if (page == 'admin') {
    await tap(find.byIcon(Icons.settings_outlined));
    await below(find.byIcon(Icons.admin_panel_settings_outlined));
  }
}

SourceNode _node(
  String volume,
  String key, {
  SourceKind kind = SourceKind.folder,
  int items = 0,
  List<SourceNode> children = const [],
  SourceState state = SourceState.present,
  SourceVisibility own = SourceVisibility.inherit,
  bool shown = true,
  bool partly = false,
}) => SourceNode(
  source: volume.isEmpty ? '' : 'folder:$volume',
  volume: volume,
  key: key,
  name: key.isEmpty ? volume : key.split('/').reversed.skip(1).first,
  kind: kind,
  items: items,
  itemsBelow: children.fold(items, (n, c) => n + c.itemsBelow),
  newest: items > 0 ? 20240512 : null,
  state: state,
  visibility: own,
  shown: shown,
  partly: partly,
  children: children,
);

/// A desktop's folders: one online with a hidden folder that shows one
/// below, one scanning, one offline.
final SourceNode _tree = _node(
  '',
  '',
  kind: SourceKind.device,
  own: SourceVisibility.shown,
  children: [
    _node(
      '/home/me/Pictures',
      '',
      kind: SourceKind.root,
      items: 12,
      children: [
        _node(
          '/home/me/Pictures',
          '2024/',
          items: 18000,
          own: SourceVisibility.hidden,
          shown: false,
          partly: true,
          children: [
            _node(
              '/home/me/Pictures',
              '2024/Trip/',
              items: 228,
              own: SourceVisibility.shown,
            ),
          ],
        ),
        _node('/home/me/Pictures', 'Scans/', items: 40),
      ],
    ),
    _node(
      '/media/me/Camera',
      '',
      kind: SourceKind.root,
      items: 1234,
      state: SourceState.scanning,
    ),
    _node(
      '/mnt/nas/Photos',
      '',
      kind: SourceKind.root,
      items: 1,
      state: SourceState.offline,
    ),
  ],
);
