import 'dart:collection';
import 'dart:math';

import 'package:drift/drift.dart';
// Relative: app/tool/single_writer_lint.dart flags the package URIs of src/.
import 'package:photolib_data/src/file_system.dart'
    if (dart.library.js_interop) 'package:photolib_data/src/browser_folders.dart';
import 'package:photolib_data/src/ignore.dart';
import 'package:photolib_data/src/media_store.dart' show uuidTime, uuidv7;
import 'package:photolib_data/src/replica.dart';
import 'package:photolib_data/src/search.dart' show videoExtensions;
import 'package:photolib_log/photolib_log.dart';

/// What the scanner needs of a file: size, modification time in UTC
/// milliseconds and an id that a rename or move keeps: the volume's on desktops
/// (docs/10-client-app.md §8.1), size and time in browsers (ADR-0082).
typedef FileInfo = ({int size, int mtime, String id});

/// An entry of a directory, whose `info` is read only when asked for.
typedef FileEntry = ({
  String name,
  bool dir,
  Future<FileInfo?> Function() info,
});

/// The files a folder scan reads, by `/`-separated paths under a folder's
/// root: the desktop's file system, or the directories a browser was given.
/// Symlinks are not followed.
abstract interface class FolderFiles {
  /// The files and directories in [dir] under [root], or null when it cannot
  /// be read.
  Future<List<FileEntry>?> list(String root, String dir);

  /// Whether [root] holds nothing, or null when it cannot be read.
  Future<bool?> isEmpty(String root);

  /// Whether the volume of [root] tells names apart by case.
  Future<bool> caseSensitive(String root);

  /// The [FileInfo] of [path] under [root], or null when it cannot be read.
  Future<FileInfo?> stat(String root, String path);

  /// The text of [path] under [root], or '' when it cannot be read.
  Future<String> read(String root, String path);
}

/// Extensions of the photos and videos a folder scan indexes, in lower case.
final Set<String> mediaExtensions = {
  ...'jpg jpeg png gif webp heic heif avif jxl bmp tif tiff'.split(' '),
  ...rawExtensions,
  ...videoExtensions,
};

/// Extensions of camera RAW files, in lower case.
final Set<String> rawExtensions = 'dng cr2 cr3 nef arw orf rw2 raf srw pef'
    .split(' ')
    .toSet();

const _log = Logger('photolib.index');

/// Indexes the folders of `media_source` into `local_asset` rows
/// (docs/10-client-app.md §8.1).
class FolderIndexer {
  /// Indexes into [db] what it reads through [files], by default this
  /// platform's.
  FolderIndexer(this.db, [FolderFiles? files]) : _files = files ?? folderFiles;

  /// The replica it indexes into.
  final Replica db;
  final FolderFiles _files;

  /// Scans the folder [root], or only its subdirectory [dir] (a `/`-separated
  /// path under it), with everything below unless not [recursive], telling
  /// [entering] each directory before it lists it. A full scan records each
  /// directory it finishes, so that after a crash or quit the next one resumes
  /// after it, and keeps the folder in the `scanning` state until it ends,
  /// `online` then. A root that is away (missing, unreadable, or an empty mount
  /// point while it has items) changes nothing but the state of the folder and
  /// its items, to offline, and returns false; the first scan after it returns
  /// covers the whole folder.
  Future<bool> scan(
    String root, {
    String dir = '',
    bool recursive = true,
    void Function(String dir)? entering,
  }) async {
    final took = Stopwatch()..start();
    final folder = await (db.select(
      db.mediaSource,
    )..where((s) => s.root.equals(root))).getSingleOrNull();
    if (folder == null) return false;
    if (!await _online(root)) return await _offline(root);
    final (from, deep) = folder.state == 'offline'
        ? ('', true)
        : (dir, recursive);
    final junk = IgnoreRules.defaults(
      caseSensitive: await _files.caseSensitive(root),
    );
    final above = await _rulesAbove(root, from, junk);
    // Its parent's scan has marked what a junk directory held missing.
    if (above == null) return true;
    final (rules, ignoredAbove) = above;
    final full = from.isEmpty && deep;
    if (full && folder.state != 'scanning') {
      await _update(root, const MediaSourceCompanion(state: Value('scanning')));
    }
    final resume = full ? folder.checkpoint : null;
    final counts = {'directories': 0, 'seen': 0, 'indexed': 0, 'missing': 0};
    final skipped = <String, int>{};
    final pending = [(from, rules, ignoredAbove)];
    while (pending.isNotEmpty) {
      final (d, above, ignoredHere) = pending.removeLast();
      // Directories are scanned in order: those up to the checkpoint are only
      // listed.
      final done = resume != null && _before(d, resume);
      final rules = above.add(d, await _ignoreFile(root, d));
      entering?.call(d);
      final entries = await _files.list(root, d);
      if (entries == null) {
        if (!await _online(root)) return await _offline(root);
        _log.debug('directory unreadable', fields: {'root': root, 'dir': d});
        _count(skipped, 'unreadable directory');
        continue; // An unreadable directory keeps its items as they are.
      }
      _count(counts, 'directories');
      _count(counts, 'seen', entries.length);
      final (files, dirs, ignored) = await _sort(
        root,
        d,
        entries,
        (rules, junk, ignoredHere),
        done,
        skipped,
      );
      if (!done) {
        final (indexed, missing) = await _reconcile(
          root,
          d,
          files,
          dirs.keys.toSet(),
          full,
          ignored,
        );
        _count(counts, 'indexed', indexed);
        _count(counts, 'missing', missing);
      }
      if (deep) {
        pending.addAll([
          for (final s in dirs.keys.toList().reversed)
            (_join(d, s), rules, dirs[s]!),
        ]);
      }
    }
    if (full) {
      await _update(
        root,
        const MediaSourceCompanion(
          checkpoint: Value(null),
          state: Value('online'),
        ),
      );
    }
    _log.info(
      'scanned',
      fields: {
        'root': root,
        'dir': from,
        'recursive': deep,
        'resumed after': ?resume,
        'ms': took.elapsedMilliseconds,
        ...counts,
        'skipped': skipped,
      },
    );
    return true;
  }

  /// The ignore rules of the directories above [dir], and whether one the user
  /// chose ignores it; null when the [junk] defaults do: never indexed.
  Future<(IgnoreRules, bool)?> _rulesAbove(
    String root,
    String dir,
    IgnoreRules junk,
  ) async {
    var rules = junk;
    var ignored = false;
    final parts = dir.isEmpty ? const <String>[] : dir.split('/');
    for (var i = 0; i < parts.length; i++) {
      rules = rules.add(_up(parts, i), await _ignoreFile(root, _up(parts, i)));
      final path = _up(parts, i + 1);
      if (rules.ignores(path, dir: true)) {
        if (junk.ignores(path, dir: true)) return null;
        ignored = true;
      }
    }
    return (rules, ignored);
  }

  /// The media files of the [entries] of [dir] to index, none when [done], its
  /// subdirectories to scan, sorted, each with whether the user's rules ignore
  /// it, and the names of the files they do: these are indexed all the same,
  /// out of every view but the one that shows the excluded. [skipped] counts
  /// the rest, the junk the defaults name among it.
  Future<(Map<String, FileInfo>, Map<String, bool>, Set<String>)> _sort(
    String root,
    String dir,
    List<FileEntry> entries,
    (IgnoreRules, IgnoreRules, bool) rules,
    bool done,
    Map<String, int> skipped,
  ) async {
    final (all, junk, ignoredHere) = rules;
    final files = <String, FileInfo>{};
    final dirs = <String, bool>{};
    final ignored = <String>{};
    for (final (:name, dir: isDir, :info) in entries) {
      final path = _join(dir, name);
      final byRules = all.ignores(path, dir: isDir);
      final out = ignoredHere || byRules;
      if (byRules && junk.ignores(path, dir: isDir)) {
        _count(skipped, 'ignored');
      } else if (isDir) {
        dirs[name] = out;
      } else if (!mediaExtensions.contains(
        name.split('.').last.toLowerCase(),
      )) {
        _count(skipped, 'not media');
      } else if (!done) {
        if (await info() case final info?) {
          files[name] = info;
          if (out) {
            ignored.add(name);
            _count(skipped, 'excluded');
          }
        } else {
          _count(skipped, 'unreadable');
        }
      }
    }
    _log.debug(
      'directory',
      fields: {
        'root': root,
        'dir': dir,
        'entries': entries.length,
        'media': files.length,
        if (done) 'resumed past it': true,
      },
    );
    return (files, SplayTreeMap.of(dirs), ignored);
  }

  Future<String> _ignoreFile(String root, String dir) =>
      _files.read(root, _join(dir, '.photolibignore'));

  Future<void> _update(String root, MediaSourceCompanion change) => (db.update(
    db.mediaSource,
  )..where((s) => s.root.equals(root))).write(change);

  Expression<bool> _in(String root) =>
      db.localAsset.source.equals('folder') & db.localAsset.volume.equals(root);

  /// The items of [root] under its subdirectory [dir].
  Expression<bool> _under(String root, String dir) => dir.isEmpty
      ? _in(root)
      : _in(root) &
            db.localAsset.path.isBiggerThanValue('$dir/') &
            db.localAsset.path.isSmallerThanValue('${dir}0');

  Future<bool> _online(String root) async {
    final empty = await _files.isEmpty(root);
    if (empty == null) {
      _log.info('folder unreadable', fields: {'root': root});
      return false;
    }
    if (!empty) return true;
    final items = db.select(db.localAsset)
      ..where((a) => _in(root) & a.state.equals('missing').not())
      ..limit(1);
    final online = await items.getSingleOrNull() == null;
    if (!online) {
      _log.info(
        'folder empty but has items: an unmounted drive',
        fields: {'root': root},
      );
    }
    return online;
  }

  Future<bool> _offline(String root) => db.transaction(() async {
    _log.info('folder offline', fields: {'root': root});
    // What the checkpoint says is done goes offline too: the scan after it
    // returns starts afresh.
    await _update(
      root,
      const MediaSourceCompanion(
        state: Value('offline'),
        checkpoint: Value(null),
      ),
    );
    await (db.update(db.localAsset)
          ..where((a) => _in(root) & a.state.equals('present')))
        .write(const LocalAssetCompanion(state: Value('offline')));
    return false;
  });

  /// Brings the rows of the directory [dir] in line with its [files] and
  /// [dirs] in one transaction (see [_match]); the files named in [ignored]
  /// are marked excluded (`hidden` 2) and the others no longer are. Returns the
  /// rows it indexed and those it marked missing.
  Future<(int, int)> _reconcile(
    String root,
    String dir,
    Map<String, FileInfo> files,
    Set<String> dirs,
    bool full,
    Set<String> ignored,
  ) => db.transaction(() async {
    if (full) await _update(root, MediaSourceCompanion(checkpoint: Value(dir)));
    final a = db.localAsset;
    final prefix = dir.isEmpty ? '' : '$dir/';
    final rest = a.path.substrExpr(Variable(prefix).length + const Constant(1));
    final slash = FunctionCallExpression<int>('instr', [
      rest,
      const Constant('/'),
    ]);
    final here = {
      for (final row in await (db.select(
        a,
      )..where((_) => _under(root, dir) & slash.equals(0))).get())
        if (row.path case final path?) path.substring(prefix.length): row,
    };
    final sub = rest.substrExpr(const Constant(1), slash - const Constant(1));
    final subdirs = db.selectOnly(a, distinct: true)
      ..addColumns([sub])
      ..where(_under(root, dir) & slash.isBiggerThanValue(0));
    var missing = 0;
    for (final gone in (await subdirs.map((r) => r.read(sub)).get()).nonNulls) {
      if (dirs.contains(gone)) continue;
      missing +=
          await (db.update(a)..where(
                (r) =>
                    _under(root, '$prefix$gone') &
                    r.state.isNotValue('missing'),
              ))
              .write(const LocalAssetCompanion(state: Value('missing')));
    }
    final (claimed, news) = await _match(root, prefix, here, files);
    final folder = files.isEmpty ? 0 : await _folder(root, prefix);
    final changes = [
      for (final (row, path, info) in claimed.values)
        if (_change(row, path, info, folder) case final change?)
          (row.id, change),
    ];
    // In batches, so that a browser, which runs this on its page, renders
    // between them.
    for (final chunk in _chunks(changes, 100)) {
      await db.batch((b) {
        for (final (id, change) in chunk) {
          b.update(a, change, where: (r) => r.id.equals(id));
        }
      });
    }
    for (final chunk in _chunks(news, 100)) {
      await db.batch((b) {
        for (final (name, info) in chunk) {
          b.insert(
            a,
            _insert(
              root,
              '$prefix$name',
              info,
              folder,
              ignored: ignored.contains(name),
            ),
          );
        }
      });
    }
    await _exclude(root, dir, {for (final n in ignored) '$prefix$n'});
    final gone = [
      for (final (_, c) in changes)
        if (c.state == const Value('missing')) c,
    ].length;
    return (news.length + changes.length - gone, missing + gone);
  });

  /// Marks the files of the directory [dir] at [paths] excluded by the rules
  /// (`hidden` 2) unless the user hid them, and lets go of those it marked that
  /// no rule ignores any more. The excluded show only while the library shows
  /// hidden items.
  Future<void> _exclude(String root, String dir, Set<String> paths) async {
    final a = db.localAsset;
    final slash = FunctionCallExpression<int>('instr', [
      a.path.substrExpr(
        Variable(dir.isEmpty ? '' : '$dir/').length + const Constant(1),
      ),
      const Constant('/'),
    ]);
    final rows =
        await (db.select(a)..where(
              (r) =>
                  _under(root, dir) &
                  slash.equals(0) &
                  r.state.isNotValue('missing'),
            ))
            .get();
    final set = <Uint8List>[];
    final unset = <Uint8List>[];
    for (final row in rows) {
      final out = paths.contains(row.path);
      if (out && row.hidden == 0) set.add(row.id);
      if (!out && row.hidden == 2) unset.add(row.id);
    }
    for (final (ids, to) in [(set, 2), (unset, 0)]) {
      for (final chunk in _chunks(ids, 100)) {
        await (db.update(a)..where((r) => r.id.isIn(chunk))).write(
          LocalAssetCompanion(hidden: Value(to)),
        );
      }
    }
  }

  /// The row each of the [files] of the directory at [prefix] keeps, by
  /// source id with its path and info, and those that need a new row. A file
  /// keeps its row [here] when its file id is unchanged; else a row with its
  /// file id, size and modification time whose path no longer holds it, as a
  /// rename or move leaves it; else the row of its path (an editor that saves
  /// a new file, a remount that renumbers files). A row [here] that no file
  /// keeps gets an empty path.
  Future<
    (Map<String, (LocalAssetData, String, FileInfo)>, List<(String, FileInfo)>)
  >
  _match(
    String root,
    String prefix,
    Map<String, LocalAssetData> here,
    Map<String, FileInfo> files,
  ) async {
    // By source id: hashing whole rows costs a browser's page frames in a large
    // directory.
    final claimed = <String, (LocalAssetData, String, FileInfo)>{};
    final moved = <(String, FileInfo)>[];
    for (final MapEntry(key: name, value: info) in files.entries) {
      final row = here[name];
      if (row != null && row.fileId == info.id) {
        claimed[row.sourceId] = (row, '$prefix$name', info);
      } else {
        moved.add((name, info));
      }
    }
    final byId = {
      for (final ids in _chunks([for (final (_, info) in moved) info.id]))
        for (final row in await (db.select(
          db.localAsset,
        )..where((r) => _in(root) & r.fileId.isIn(ids))).get())
          ?row.fileId: row,
    };
    final fresh = <(String, FileInfo)>[];
    for (final (name, info) in moved) {
      final row = byId[info.id];
      if (row != null &&
          !claimed.containsKey(row.sourceId) &&
          await _moved(root, row, info)) {
        claimed[row.sourceId] = (row, '$prefix$name', info);
      } else {
        fresh.add((name, info));
      }
    }
    final news = <(String, FileInfo)>[];
    for (final (name, info) in fresh) {
      final row = here[name];
      if (row != null && !claimed.containsKey(row.sourceId)) {
        claimed[row.sourceId] = (row, '$prefix$name', info);
      } else {
        news.add((name, info));
      }
    }
    for (final row in here.values) {
      claimed.putIfAbsent(
        row.sourceId,
        () => (row, '', (size: 0, mtime: 0, id: '')),
      );
    }
    return (claimed, news);
  }

  /// Whether [row], of [info]'s file id, is that file moved: of its size and
  /// time, and its path no longer holding it.
  Future<bool> _moved(String root, LocalAssetData row, FileInfo info) async {
    final path = row.path;
    if (path == null || row.size != info.size || row.mtime != info.mtime) {
      return false;
    }
    return (await _files.stat(root, path))?.id != info.id;
  }

  /// The device folder of the directory [path] under [root], which the
  /// source tree shows and hides (ADR-0290), added when new.
  Future<int> _folder(String root, String path) async {
    final f = db.deviceFolder;
    await db
        .into(f)
        .insert(
          DeviceFolderCompanion.insert(volume: root, path: path),
          mode: InsertMode.insertOrIgnore,
        );
    final row = await (db.select(
      f,
    )..where((f) => f.volume.equals(root) & f.path.equals(path))).getSingle();
    return row.id;
  }

  LocalAssetCompanion _insert(
    String root,
    String path,
    FileInfo info,
    int folder, {
    bool ignored = false,
  }) {
    final id = uuidv7();
    return LocalAssetCompanion.insert(
      id: id,
      source: 'folder',
      volume: Value(root),
      sourceId: [
        for (final b in id) b.toRadixString(16).padLeft(2, '0'),
      ].join(),
      size: info.size,
      mtime: info.mtime,
      path: Value(path),
      fileId: Value(info.id),
      added: Value(uuidTime(id)),
      folder: Value(folder),
      hidden: Value(ignored ? 2 : 0),
    );
  }

  /// What changes [row] to the file at [path] in the device folder [folder],
  /// or marks it missing when [path] is empty; null when nothing does.
  LocalAssetCompanion? _change(
    LocalAssetData row,
    String path,
    FileInfo info,
    int folder,
  ) {
    if (path.isEmpty) {
      return row.state == 'missing'
          ? null
          : const LocalAssetCompanion(state: Value('missing'));
    }
    final changed = row.size != info.size || row.mtime != info.mtime;
    // A file back from the trash Photolib moved it to was restored there.
    final restored = row.bin != null;
    if (!changed &&
        !restored &&
        row.path == path &&
        row.fileId == info.id &&
        row.folder == folder &&
        row.state == 'present') {
      return null;
    }
    var moved = LocalAssetCompanion(
      path: Value(path),
      folder: Value(folder),
      fileId: Value(info.id),
      size: Value(info.size),
      mtime: Value(info.mtime),
      state: const Value('present'),
    );
    if (restored) {
      moved = moved.copyWith(
        trashed: const Value(0),
        expires: const Value(null),
        bin: const Value(null),
      );
    }
    // A changed file loses what was read in it: its hashes, and its metadata,
    // which extraction reads again.
    return changed
        ? moved.copyWith(
            contentHash: const Value(null),
            fingerprint: const Value(null),
            thumbhash: const Value(null),
            extracted: const Value(null),
            width: const Value(null),
            height: const Value(null),
            orientation: const Value(null),
            durationMs: const Value(null),
          )
        : moved;
  }
}

String _join(String dir, String name) => dir.isEmpty ? name : '$dir/$name';

/// Whether the scan reaches [a] no later than [b].
bool _before(String a, String b) {
  final x = a.split('/');
  final y = b.split('/');
  for (var i = 0; i < x.length && i < y.length; i++) {
    final order = x[i].compareTo(y[i]);
    if (order != 0) return order < 0;
  }
  return x.length <= y.length;
}

String _up(List<String> parts, int n) => parts.take(n).join('/');

void _count(Map<String, int> into, String what, [int n = 1]) =>
    into[what] = (into[what] ?? 0) + n;

Iterable<List<T>> _chunks<T>(List<T> list, [int size = 500]) sync* {
  for (var i = 0; i < list.length; i += size) {
    yield list.sublist(i, min(i + size, list.length));
  }
}
