import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/feature_flags.dart';
import 'package:photolib/core/providers.dart';
import 'package:photolib/features/library/timeline/buckets.dart';
import 'package:photolib/features/library/timeline/layout.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/features/settings/settings.dart';

import '../support/pump_app.dart';

void main() {
  test('the logger writes into the in-memory log', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(loggerProvider).child('test').info('hello');
    final record = container.read(memoryLogProvider).records.single;
    expect(record.message, 'hello');
    expect(record.logger, 'photolib.test');
  });

  test('flags default to off and can be replaced for a test', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(featureFlagsProvider).isOn(Flag.diagnostics), false);

    final overridden = ProviderContainer(
      overrides: [
        featureFlagsProvider.overrideWithValue(
          FeatureFlags.parse('diagnostics'),
        ),
      ],
    );
    addTearDown(overridden.dispose);
    expect(overridden.read(featureFlagsProvider).isOn(Flag.diagnostics), true);
  });

  group('settings', () {
    ProviderContainer settings([MemoryStore? store]) {
      final container = ProviderContainer(
        overrides: [
          settingsStoreProvider.overrideWithValue(store ?? MemoryStore()),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('follow the system theme and show HDR until told otherwise', () {
      final container = settings();
      expect(container.read(settingsProvider).themeMode, ThemeMode.system);
      expect(container.read(settingsProvider).hdr, isTrue);
    });

    test('are kept in their store, and the next run reads them back', () async {
      final store = MemoryStore();
      settings(store).read(settingsProvider.notifier)
        ..setThemeMode(ThemeMode.dark)
        ..setDiagnostics(on: true)
        ..toggleHdr()
        ..setDownloadFolder('/home/ana/Pictures')
        ..setSlideshow(seconds: 7, shuffle: true)
        ..setSlideshow(loop: true);
      final next = settings(store);
      expect(
        await next.read(settingsProvider.notifier).downloadFolder(),
        '/home/ana/Pictures',
      );
      expect(next.read(settingsProvider).themeMode, ThemeMode.dark);
      expect(next.read(settingsProvider).diagnostics, isTrue);
      expect(next.read(settingsProvider).hdr, isFalse);
      expect(next.read(settingsProvider).slideshow, (
        seconds: 7,
        shuffle: true,
        loop: true,
      ));
    });

    test('a slideshow shows each item 5 s, in order, once, until told '
        'otherwise; a kept interval under 1 s is the default', () async {
      expect(settings().read(settingsProvider).slideshow, (
        seconds: 5,
        shuffle: false,
        loop: false,
      ));
      final odd = settings(
        MemoryStore('{"slideshow":{"seconds":0,"shuffle":true}}'),
      )..read(settingsProvider);
      await pumpEventQueue();
      expect(odd.read(settingsProvider).slideshow, (
        seconds: 5,
        shuffle: true,
        loop: false,
      ));
    });

    test("the viewer's and grid's choices are kept, the defaults where "
        'none was made', () async {
      final store = MemoryStore();
      expect(settings(store).read(settingsProvider).isOn(Toggle.loop), false);
      settings(store).read(settingsProvider.notifier)
        ..setToggle(Toggle.loop, on: true)
        ..setToggle(Toggle.edgeTaps, on: false)
        ..setBackground(ViewerBackground.checkerboard)
        ..setBar([ViewerAction.share, ViewerAction.info]);
      final next = settings(store);
      await next.read(settingsProvider.notifier).loaded;
      final read = next.read(settingsProvider);
      expect(
        [for (final t in Toggle.values) read.isOn(t)],
        [
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          true,
          false,
          false,
          false,
        ],
      );
      expect(read.background, ViewerBackground.checkerboard);
      expect(read.bar, [ViewerAction.share, ViewerAction.info]);
    });

    test('changed before they are read, keep the stored ones the change '
        'leaves alone', () async {
      final answer = Completer<void>();
      final stored = jsonEncode({
        'themeMode': 'dark',
        'downloadFolder': '/home/ana/Pictures',
      });
      final store = MemoryStore(stored, answer.future);
      final container = settings(store);
      final notifier = container.read(settingsProvider.notifier)
        ..setDiagnostics(on: true);
      expect(container.read(settingsProvider).diagnostics, isTrue);
      expect(store.value, stored);
      answer.complete();
      expect(await notifier.downloadFolder(), '/home/ana/Pictures');
      expect(container.read(settingsProvider).themeMode, ThemeMode.dark);
      expect(jsonDecode(store.value!), {
        'themeMode': 'dark',
        'diagnostics': true,
        'hdr': true,
        'downloadFolder': '/home/ana/Pictures',
        'library': {
          'added': false,
          'grouping': 'day',
          'density': 'days',
          'backup': null,
          'badges': true,
        },
        'indexWhileCharging': false,
        'searchColumns': 4,
        'trashDays': 60,
        'slideshow': {'seconds': 5, 'shuffle': false, 'loop': false},
        'startScreen': 'timeline',
        'albumsFirst': false,
      });
    });

    Future<Settings> readBack(Map<String, Object?> stored) {
      final container = settings(MemoryStore(jsonEncode(stored)));
      return container
          .read(settingsProvider.notifier)
          .loaded
          .then((_) => container.read(settingsProvider));
    }

    test('on-device indexing keeps its options, each written only once it '
        'differs from its default', () async {
      final store = MemoryStore();
      final container = settings(store);
      await container.read(settingsProvider.notifier).loaded;
      container.read(settingsProvider.notifier)
        ..setIndexBattery(35)
        ..setIndexAllowSaver(on: true)
        ..setIndexAllowMetered(on: true)
        ..setIndexModels(on: true)
        ..setIndexText(on: true);
      final stored = jsonDecode(store.value!) as Map<String, Object?>;
      expect(
        {
          for (final k in stored.keys)
            if (k.startsWith('index')) k: stored[k],
        },
        {
          'indexWhileCharging': false,
          'indexBattery': 35,
          'indexAllowSaver': true,
          'indexAllowMetered': true,
          'indexModels': true,
          'indexText': true,
        },
      );
      final read = await readBack(stored);
      expect(
        (
          read.indexBattery,
          read.indexAllowSaver,
          read.indexAllowMetered,
          read.indexModels,
          read.indexText,
        ),
        (35, true, true, true, true),
      );
      final unknown = await readBack({'indexBattery': 140});
      expect(
        (unknown.indexBattery, unknown.indexModels, unknown.indexText),
        (20, false, false),
      );
    });

    test('the face notice agreed to is kept only while it is one, and nobody '
        'has agreed until they do', () async {
      final store = MemoryStore();
      final container = settings(store);
      await container.read(settingsProvider.notifier).loaded;
      expect(container.read(settingsProvider).faceNotice, 0);
      expect(store.value == null || !store.value!.contains('face'), isTrue);
      container.read(settingsProvider.notifier).setFaceNotice(1);
      final stored = jsonDecode(store.value!) as Map<String, Object?>;
      expect(stored['faceNotice'], 1);
      expect((await readBack(stored)).faceNotice, 1);
      container.read(settingsProvider.notifier).setFaceNotice(0);
      expect(
        (jsonDecode(store.value!) as Map<String, Object?>).containsKey(
          'faceNotice',
        ),
        isFalse,
      );
      for (final odd in <Object?>[-1, 'yes', true, 1.5]) {
        expect((await readBack({'faceNotice': odd})).faceNotice, 0);
      }
    });

    test('a store written without a setting gives it its default, and keeps '
        'the others', () async {
      // As builds before the library's view options wrote it.
      final read = await readBack({
        'themeMode': 'dark',
        'diagnostics': true,
        'downloadFolder': '/home/ana/Pictures',
      });
      expect(read.library.added, isFalse);
      expect(read.library.grouping, Grouping.day);
      expect(read.library.density, Density.days);
      expect(read.searchColumns, 4);
      expect(read.themeMode, ThemeMode.dark);
      expect(read.diagnostics, isTrue);
      expect(read.downloadFolder, '/home/ana/Pictures');
      expect(
        (read.startScreen, read.albumsFirst),
        (StartScreen.timeline, false),
      );
    });

    test('a setting in a form this version does not know takes its default, '
        'and the others are kept', () async {
      final read = await readBack({
        'themeMode': 'sepia',
        'diagnostics': true,
        'downloadFolder': {'path': '/home/ana/Pictures'},
        'library': {
          'added': true,
          'grouping': 'fortnight',
          'density': 'huge',
          'backup': 'sideways',
          'badges': 'off',
        },
        'searchColumns': 'six',
        'trashDays': 'forever',
        'startScreen': 'gallery',
        'albumsFirst': 'yes',
      });
      expect(read.searchColumns, 4);
      expect(read.trashDays, 60);
      expect(
        (read.startScreen, read.albumsFirst),
        (StartScreen.timeline, false),
      );
      expect(read.themeMode, ThemeMode.system);
      expect(read.downloadFolder, isNull);
      expect(read.library.grouping, Grouping.day);
      expect(read.library.density, Density.days);
      expect((read.library.backup, read.library.badges), (null, true));
      expect(read.diagnostics, isTrue);
      expect(read.library.added, isTrue);
    });

    test('keep how long the trash keeps its items, from 30, 60 or 90 days, '
        'and read nothing else', () async {
      final store = MemoryStore();
      settings(store).read(settingsProvider.notifier).setTrashDays(90);
      await pumpEventQueue();
      expect(jsonDecode(store.value!), containsPair('trashDays', 90));
      expect((await readBack({'trashDays': 90})).trashDays, 90);
      expect((await readBack({'trashDays': 45})).trashDays, 60);
      expect(const Settings().trashDays, 60);
    });

    test("keep the library's backup filter and badges", () async {
      final store = MemoryStore();
      settings(store)
          .read(settingsProvider.notifier)
          .setLibraryView(
            const LibraryView(backup: Availability.cloudOnly, badges: false),
          );
      await pumpEventQueue();
      final read = await readBack(
        jsonDecode(store.value!) as Map<String, Object?>,
      );
      expect(
        (read.library.backup, read.library.badges),
        (Availability.cloudOnly, false),
      );
    });

    test('keep the theme mode that was chosen', () {
      final container = settings();
      container.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark);
      expect(container.read(settingsProvider).themeMode, ThemeMode.dark);
    });

    test('a change before the kept ones are read wins over them; unreadable '
        'ones are the defaults', () async {
      final early = settings(
        MemoryStore('{"themeMode":"dark","diagnostics":true}'),
      );
      early.read(settingsProvider.notifier).setThemeMode(ThemeMode.light);
      await pumpEventQueue();
      expect(early.read(settingsProvider).themeMode, ThemeMode.light);
      expect(early.read(settingsProvider).diagnostics, isTrue);
      final damaged = settings(MemoryStore('not json'))..read(settingsProvider);
      await pumpEventQueue();
      expect(damaged.read(settingsProvider).themeMode, ThemeMode.system);
    });
  });
}
