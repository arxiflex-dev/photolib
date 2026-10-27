import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:photolib/core/keystore.dart';
import 'package:photolib/core/replica.dart';
import 'package:photolib/features/library/timeline/buckets.dart';
import 'package:photolib/features/library/timeline/layout.dart';
import 'package:photolib/features/library/timeline/pipeline.dart';
import 'package:photolib/l10n/locales.dart';

/// How the library's timeline is sorted (VIEW-06), grouped (VIEW-03) and
/// zoomed (VIEW-02), which backup state it shows and whether tiles have their
/// badges (VIEW-05).
@immutable
class LibraryView {
  /// By date taken, by day, every tile with its badge, unless told otherwise.
  const new({
    this.added = false,
    this.grouping = Grouping.day,
    this.density = Density.days,
    this.backup,
    this.badges = true,
  });

  /// By date added, as "Recently added", instead of date taken.
  final bool added;

  /// The segments of the timeline's denser levels.
  final Grouping grouping;

  /// The zoom level, as the last pinch or zoom button left it.
  final Density density;

  /// Only the tiles in this state; all when null.
  final Availability? backup;

  /// Whether tiles show their backup state.
  final bool badges;

  /// This view with what is given changed; [backup] returns the new filter.
  LibraryView copyWith({
    bool? added,
    Grouping? grouping,
    Density? density,
    Availability? Function()? backup,
    bool? badges,
  }) => LibraryView(
    added: added ?? this.added,
    grouping: grouping ?? this.grouping,
    density: density ?? this.density,
    backup: backup == null ? this.backup : backup(),
    badges: badges ?? this.badges,
  );
}

/// A behaviour of the viewer or the grid the user turns on or off (VIEW-39,
/// VIEW-14, FMT-13), on unless [byDefault] is false.
enum Toggle {
  /// A tap on the viewer's left or right fifth goes to the item that side.
  edgeTaps,

  /// A double tap held and dragged zooms.
  oneFingerZoom,

  /// Vertical drags on a video's sides set the brightness and the volume.
  swipes,

  /// The screen is at full brightness while the viewer shows.
  maxBrightness(byDefault: false),

  /// A phone's viewer turns to the item's orientation.
  autoRotate(byDefault: false),

  /// Videos with a sound track play over other apps' audio rather than
  /// pausing it; a silent video always does.
  mixAudio(byDefault: false),

  /// A video plays as it is shown (docs/10 §4.6).
  autoplay(byDefault: false),

  /// Videos play over and over.
  loop(byDefault: false),

  /// A video that ends goes on to the next item.
  autoNext(byDefault: false),

  /// A video starts again where it was left.
  resume(byDefault: false),

  /// Animated images play in the grid.
  animateGrid(byDefault: false);

  new({this.byDefault = true});

  /// Whether it is on until the user says otherwise.
  final bool byDefault;
}

/// What shows behind a transparent image in the viewer.
enum ViewerBackground {
  /// The viewer's own.
  black,

  /// White, as a page.
  white,

  /// Grey squares, which show what is transparent.
  checkerboard,
}

/// The viewer's actions (VIEW-39, VIEW-40), in the order its `⋮` menu lists
/// those not pinned to its bar (docs/10 §4.6).
enum ViewerAction {
  /// Marks the item a favourite, or no longer (ADR-0245).
  favourite,

  /// Shows the item's info.
  info,

  /// Edits the item into a copy (ADR-0331).
  edit,

  /// Moves the item to the trash.
  trash,

  /// Shows or hides the filmstrip.
  filmstrip,

  /// Offers the item to another app.
  share,

  /// Saves the item's file.
  download,

  /// Copies the item to the clipboard.
  copy,

  /// Shows the text OCR read in the picture, and copies it (server pictures).
  copyText,

  /// Shows the item's file in the file manager.
  reveal,

  /// Turns the photo shown a quarter clockwise, until the viewer closes.
  rotate,

  /// Shows where the item was taken in the platform's maps.
  map,

  /// Hands the photo to the apps that set one as a wallpaper or contact
  /// photo (Android).
  setAs,

  /// Plays the items as a slideshow.
  slideshow,

  /// Hides the item, or shows it again while hidden items show.
  hide,

  /// Archives the item, or takes it out again while archived items show.
  archive,

  /// Adds the item to an album.
  addToAlbum,

  /// Keeps the item whole on this device, or lets it go (ADR-0200 P2).
  keepOffline,
}

/// The actions pinned to the viewer's bar until the user changes them: the
/// owner's order (ADR-0245), a bar already saved keeps its own.
const List<ViewerAction> defaultPins = [
  ViewerAction.favourite,
  ViewerAction.share,
  ViewerAction.info,
  ViewerAction.trash,
  ViewerAction.edit,
  ViewerAction.filmstrip,
];

/// The viewer's choices kept together: its pins, its filmstrip and whether
/// its map loads.
typedef _Chrome = ({List<ViewerAction> bar, bool? filmstrip, bool maps});

/// How a slideshow runs (VIEW-21): each item's seconds, whether in a random
/// order, and whether it starts over after the last.
typedef Slideshow = ({int seconds, bool shuffle, bool loop});

const Slideshow _slideshow = (seconds: 5, shuffle: false, loop: false);

/// What the app opens on: the library's timeline, the folders and albums,
/// or the favourites.
enum StartScreen {
  /// The library's timeline.
  timeline,

  /// The folders and albums.
  folders,

  /// The favourites.
  favourites,
}

/// Every setting of this install.
@immutable
class Settings {
  /// The defaults, but for what is given.
  const new({
    this.themeMode = ThemeMode.system,
    this.diagnostics = false,
    this.hdr = true,
    this.downloadFolder,
    this.library = const LibraryView(),
    this.toggles = const {},
    this.background = ViewerBackground.black,
    this.bar = defaultPins,
    this.filmstrip,
    this.maps = false,
    this.indexWhileCharging = false,
    this.searchColumns = 4,
    this.slideshow = _slideshow,
    this.indexBattery = 20,
    this.indexAllowSaver = false,
    this.indexAllowMetered = false,
    this.indexModels = false,
    this.indexText = false,
    this.faceNotice = 0,
    this.faceEmbedder = 'sface',
    this.recoveryReminder,
    this.startScreen = StartScreen.timeline,
    this.albumsFirst = false,
    this.language,
  });

  /// The settings [json] holds: one it lacks, or holds in a form this version
  /// does not know, takes its default, so that a new one needs no migration.
  new _fromJson(Map<String, Object?> json)
    : themeMode =
          ThemeMode.values.asNameMap()[json['themeMode']] ?? ThemeMode.system,
      diagnostics = json['diagnostics'] == true,
      hdr = json['hdr'] != false,
      downloadFolder = switch (json['downloadFolder']) {
        final String folder => folder,
        _ => null,
      },
      library = switch (json['library']) {
        final Map<String, Object?> view => LibraryView(
          added: view['added'] == true,
          grouping:
              Grouping.values.asNameMap()[view['grouping']] ?? Grouping.day,
          density: Density.values.asNameMap()[view['density']] ?? Density.days,
          backup: Availability.values.asNameMap()[view['backup']],
          badges: view['badges'] != false,
        ),
        _ => const LibraryView(),
      },
      toggles = switch (json['toggles']) {
        final Map<String, Object?> stored => {
          for (final MapEntry(:key, :value) in stored.entries)
            if ((Toggle.values.asNameMap()[key], value) case (
              final t?,
              final bool on,
            ))
              t: on,
        },
        _ => {},
      },
      background =
          ViewerBackground.values.asNameMap()[json['background']] ??
          ViewerBackground.black,
      bar = switch (json['bar']) {
        final List<Object?> names => [
          for (final name in names) ?ViewerAction.values.asNameMap()[name],
        ],
        _ => defaultPins,
      },
      filmstrip = switch (json['filmstrip']) {
        final bool on => on,
        _ => null,
      },
      maps = json['maps'] == true,
      indexWhileCharging = json['indexWhileCharging'] == true,
      searchColumns = switch (json['searchColumns']) {
        final int columns => columns,
        _ => 4,
      },
      slideshow = switch (json['slideshow']) {
        final Map<String, Object?> s => (
          seconds: switch (s['seconds']) {
            final int seconds when seconds > 0 => seconds,
            _ => _slideshow.seconds,
          },
          shuffle: s['shuffle'] == true,
          loop: s['loop'] == true,
        ),
        _ => _slideshow,
      },
      indexBattery = switch (json['indexBattery']) {
        final int percent when percent >= 0 && percent <= 100 => percent,
        _ => 20,
      },
      indexAllowSaver = json['indexAllowSaver'] == true,
      indexAllowMetered = json['indexAllowMetered'] == true,
      indexModels = json['indexModels'] == true,
      indexText = json['indexText'] == true,
      faceEmbedder = switch (json['faceEmbedder']) {
        final String id when id.isNotEmpty => id,
        _ => 'sface',
      },
      faceNotice = switch (json['faceNotice']) {
        final int version when version > 0 => version,
        _ => 0,
      },
      recoveryReminder = switch (json['recoveryReminder']) {
        final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
        _ => null,
      },
      startScreen =
          StartScreen.values.asNameMap()[json['startScreen']] ??
          StartScreen.timeline,
      albumsFirst = json['albumsFirst'] == true,
      language = launchLocales
          .where((locale) => locale.toLanguageTag() == json['language'])
          .firstOrNull;

  /// Light, dark, or as the system is.
  final ThemeMode themeMode;

  /// Whether a release build shows Diagnostics; debug builds always do.
  final bool diagnostics;

  /// Whether the viewer shows HDR items in HDR where it can (docs/10 §4.5).
  final bool hdr;

  /// Where a desktop's save dialog opens: the folder chosen last.
  final String? downloadFolder;

  /// How the library is shown.
  final LibraryView library;

  /// The toggles the user changed; the others are as they are by default.
  final Map<Toggle, bool> toggles;

  /// What shows behind a transparent image in the viewer.
  final ViewerBackground background;

  /// The actions pinned to the viewer's bar, in order; the others are in its
  /// menu.
  final List<ViewerAction> bar;

  /// Whether the viewer shows its filmstrip; until the user says, from
  /// 760 dp on (docs/10 §4.6).
  final bool? filmstrip;

  /// Whether the user agreed that the info panel's map loads its tiles from
  /// the internet (docs/10 §4.6, docs/14 §1).
  final bool maps;

  /// Whether on-device indexing runs only while the device charges.
  final bool indexWhileCharging;

  /// The battery, in percent, below which on-device indexing waits for a
  /// charger.
  final int indexBattery;

  /// Whether on-device indexing runs in power saving mode too.
  final bool indexAllowSaver;

  /// Whether the model downloads over a metered network too.
  final bool indexAllowMetered;

  /// Whether the user agreed to download the model and index on this device
  /// (design 09 §12.2).
  final bool indexModels;

  /// Whether the user agreed to download the OCR models and read the text in
  /// the photos on this device (ADR-0388).
  final bool indexText;

  /// The version of the face recognition notice the user agreed to, 0 while
  /// they have not (ADR-0389): faces are found, on this device or its server,
  /// only while this is the current version.
  final int faceNotice;

  /// The registry id of the model that describes faces on this device:
  /// SFace, or the optional AuraFace on desktops.
  final String faceEmbedder;

  /// Until when the offer of a recovery code is put off.
  final DateTime? recoveryReminder;

  /// What the app opens on.
  final StartScreen startScreen;

  /// Whether the folders and albums open on the albums' tab.
  final bool albumsFirst;

  /// The language the app shows, else the device's: also when this build no
  /// longer ships the one stored.
  final Locale? language;

  /// Whether [toggle] is on.
  bool isOn(Toggle toggle) => toggles[toggle] ?? toggle.byDefault;

  /// The columns of search's results, as the last pinch or zoom left them.
  final int searchColumns;

  /// How slideshows run.
  final Slideshow slideshow;

  /// Where the app opens.
  String get startLocation => switch (startScreen) {
    StartScreen.timeline => '/library',
    StartScreen.folders =>
      albumsFirst ? '/collections/albums' : '/collections/folders',
    StartScreen.favourites => '/collections/favourites',
  };

  Settings _with({
    ThemeMode? themeMode,
    bool? diagnostics,
    bool? hdr,
    String? downloadFolder,
    LibraryView? library,
    Map<Toggle, bool>? toggles,
    ViewerBackground? background,
    _Chrome? chrome,
    bool? indexWhileCharging,
    int? searchColumns,
    Slideshow? slideshow,
    int? indexBattery,
    bool? indexAllowSaver,
    bool? indexAllowMetered,
    bool? indexModels,
    bool? indexText,
    DateTime? recoveryReminder,
    StartScreen? startScreen,
    bool? albumsFirst,
    (Locale?,)? language,
  }) {
    final c = chrome ?? (bar: bar, filmstrip: filmstrip, maps: maps);
    T keep<T>(T? changed, T current) => changed ?? current;
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      diagnostics: diagnostics ?? this.diagnostics,
      hdr: hdr ?? this.hdr,
      downloadFolder: downloadFolder ?? this.downloadFolder,
      library: library ?? this.library,
      toggles: toggles ?? this.toggles,
      background: background ?? this.background,
      bar: c.bar,
      filmstrip: c.filmstrip,
      maps: c.maps,
      indexWhileCharging: indexWhileCharging ?? this.indexWhileCharging,
      searchColumns: searchColumns ?? this.searchColumns,
      slideshow: slideshow ?? this.slideshow,
      indexBattery: keep(indexBattery, this.indexBattery),
      indexAllowSaver: keep(indexAllowSaver, this.indexAllowSaver),
      indexAllowMetered: keep(indexAllowMetered, this.indexAllowMetered),
      indexModels: keep(indexModels, this.indexModels),
      indexText: keep(indexText, this.indexText),
      recoveryReminder: recoveryReminder ?? this.recoveryReminder,
      startScreen: startScreen ?? this.startScreen,
      albumsFirst: albumsFirst ?? this.albumsFirst,
      language: language == null ? this.language : language.$1,
    );
  }

  /// The settings as JSON, which [Settings._fromJson] reads; the viewer's
  /// only where they are not the defaults, which may change.
  Map<String, Object?> toJson() => {
    'themeMode': themeMode.name,
    'diagnostics': diagnostics,
    'hdr': hdr,
    'downloadFolder': downloadFolder,
    'library': {
      'added': library.added,
      'grouping': library.grouping.name,
      'density': library.density.name,
      'backup': library.backup?.name,
      'badges': library.badges,
    },
    'indexWhileCharging': indexWhileCharging,
    'searchColumns': searchColumns,
    if (toggles.isNotEmpty)
      'toggles': {
        for (final MapEntry(:key, :value) in toggles.entries) key.name: value,
      },
    if (background != ViewerBackground.black) 'background': background.name,
    if (!listEquals(bar, defaultPins))
      'bar': [for (final action in bar) action.name],
    'filmstrip': ?filmstrip,
    if (maps) 'maps': true,
    'slideshow': {
      'seconds': slideshow.seconds,
      'shuffle': slideshow.shuffle,
      'loop': slideshow.loop,
    },
    if (indexBattery != 20) 'indexBattery': indexBattery,
    if (indexAllowSaver) 'indexAllowSaver': true,
    if (indexAllowMetered) 'indexAllowMetered': true,
    if (indexModels) 'indexModels': true,
    if (indexText) 'indexText': true,
    if (faceNotice > 0) 'faceNotice': faceNotice,
    if (faceEmbedder != 'sface') 'faceEmbedder': faceEmbedder,
    if (recoveryReminder case final at?)
      'recoveryReminder': at.millisecondsSinceEpoch,
    'startScreen': startScreen.name,
    'albumsFirst': albumsFirst,
    if (language case final locale?) 'language': locale.toLanguageTag(),
  };
}

/// How long "Later" puts the offer of a recovery code off.
const recoveryReminderAfter = Duration(days: 30);

/// Where settings are kept: one object sealed in the vault (docs/21 §4), read
/// again from a vault opened anew.
final settingsStoreProvider = Provider<SecretStore>((ref) {
  final vault = ref.watch(vaultProvider.future);
  return VaultText(() => vault, 'settings');
});

/// The settings, read from [settingsStoreProvider] at start and written back
/// on every change.
class SettingsNotifier extends StoredNotifier<Settings> {
  @override
  Provider<SecretStore> get store => settingsStoreProvider;

  @override
  Settings get initial => const Settings();

  @override
  Settings decode(Object json) =>
      Settings._fromJson(json as Map<String, Object?>);

  @override
  Object? encode(Settings state) => state.toJson();

  /// Shows the app in [mode].
  void setThemeMode(ThemeMode mode) => change((s) => s._with(themeMode: mode));

  /// Shows Diagnostics in a release build, or not.
  void setDiagnostics({required bool on}) =>
      change((s) => s._with(diagnostics: on));

  /// Shows HDR items in SDR, or in HDR again.
  void toggleHdr() => change((s) => s._with(hdr: !s.hdr));

  /// Keeps [folder] as the one a save dialog opens in.
  void setDownloadFolder(String folder) =>
      change((s) => s._with(downloadFolder: folder));

  /// Shows the library as [view] says.
  void setLibraryView(LibraryView view) =>
      change((s) => s._with(library: view));

  /// Turns [toggle] on or off.
  void setToggle(Toggle toggle, {required bool on}) =>
      change((s) => s._with(toggles: {...s.toggles, toggle: on}));

  /// Shows [background] behind transparent images.
  void setBackground(ViewerBackground background) =>
      change((s) => s._with(background: background));

  /// Puts [bar] in the viewer's bar, in that order.
  void setBar(List<ViewerAction> bar) => change(
    (s) => s._with(chrome: (bar: bar, filmstrip: s.filmstrip, maps: s.maps)),
  );

  /// Shows the viewer's filmstrip, or not.
  void setFilmstrip({required bool on}) =>
      change((s) => s._with(chrome: (bar: s.bar, filmstrip: on, maps: s.maps)));

  /// Lets the info panel's map load its tiles.
  void agreeToMaps() => change(
    (s) => s._with(chrome: (bar: s.bar, filmstrip: s.filmstrip, maps: true)),
  );

  /// Indexes on this device only while it charges, or not.
  void setIndexWhileCharging({required bool on}) =>
      change((s) => s._with(indexWhileCharging: on));

  /// Shows search's results in [columns].
  void setSearchColumns(int columns) =>
      change((s) => s._with(searchColumns: columns));

  /// Changes what is given of how slideshows run.
  void setSlideshow({int? seconds, bool? shuffle, bool? loop}) => change(
    (s) => s._with(
      slideshow: (
        seconds: seconds ?? s.slideshow.seconds,
        shuffle: shuffle ?? s.slideshow.shuffle,
        loop: loop ?? s.slideshow.loop,
      ),
    ),
  );

  /// Indexes on this device without a charger down to [percent] battery.
  void setIndexBattery(int percent) =>
      change((s) => s._with(indexBattery: percent));

  /// Indexes on this device in power saving mode too, or not.
  void setIndexAllowSaver({required bool on}) =>
      change((s) => s._with(indexAllowSaver: on));

  /// Downloads the model over metered networks too, or not.
  void setIndexAllowMetered({required bool on}) =>
      change((s) => s._with(indexAllowMetered: on));

  /// Downloads the model and indexes on this device, or not.
  void setIndexModels({required bool on}) =>
      change((s) => s._with(indexModels: on));

  /// Downloads the OCR models and reads the text in photos on this device, or
  /// not.
  void setIndexText({required bool on}) =>
      change((s) => s._with(indexText: on));

  /// Records that the user agreed to the face recognition notice of
  /// [version], or with 0 withdrew.
  void setFaceNotice(int version) =>
      change((s) => Settings._fromJson({...s.toJson(), 'faceNotice': version}));

  /// Describes faces on this device with the registry's model [id].
  void setFaceEmbedder(String id) =>
      change((s) => Settings._fromJson({...s.toJson(), 'faceEmbedder': id}));

  /// Puts the offer of a recovery code off for [recoveryReminderAfter].
  void remindRecoveryLater() => change(
    (s) => s._with(recoveryReminder: DateTime.now().add(recoveryReminderAfter)),
  );

  /// Opens the app on [screen] from its next start.
  void setStartScreen(StartScreen screen) =>
      change((s) => s._with(startScreen: screen));

  /// Opens the folders and albums on the albums' tab, or the folders'.
  void setAlbumsFirst({required bool albums}) =>
      change((s) => s._with(albumsFirst: albums));

  /// Shows the app in [language], or the device's when null.
  void setLanguage(Locale? language) =>
      change((s) => s._with(language: (language,)));

  /// The folder chosen last, once the stored settings are read.
  Future<String?> downloadFolder() => loaded.then((_) => state.downloadFolder);
}

/// The settings of this install.
final settingsProvider = NotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);
