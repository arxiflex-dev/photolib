// The sync calls would block the root isolate (tool/root_isolate_lint.dart).
// ignore_for_file: avoid_slow_async_io

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:photolib/features/folders/rename.dart';
import 'package:photolib_workers/photolib_workers.dart';

// File operations in desktop folders (MOB-24): the bytes and modification
// time of every file stay as they were; the folder watcher sees the result.

/// The name of the file or folder at [path].
String baseName(String path) => path.split(RegExp(r'[/\\]')).last;

/// The folder that [path] is in.
String parentOf(String path) =>
    path.substring(0, max(0, path.length - baseName(path).length - 1));

/// The path of [name] in the folder [dir].
String joinPath(String dir, String name) =>
    '$dir${Platform.pathSeparator}$name';

/// A file's outcome: where it went, or why it did not.
typedef FileResult = ({String source, String? target, String? error});

Future<bool> _taken(String path) async =>
    await FileSystemEntity.type(path, followLinks: false) !=
    FileSystemEntityType.notFound;

/// Renames each file `from` to `to` in two steps, so that names can swap:
/// a name another file holds is refused (`exists`), never overwritten.
Future<List<FileResult>> renameFiles(List<(String, String)> renames) async {
  final suffix = '.photolib-${Random().nextInt(1 << 32)}';
  final parked = <(String, String, String)?>[];
  final results = <FileResult>[];
  for (final (i, (from, to)) in renames.indexed) {
    try {
      await File(from).rename('$from$suffix-$i');
      parked.add((from, to, '$from$suffix-$i'));
    } on FileSystemException catch (e) {
      parked.add(null);
      results.add((source: from, target: null, error: e.message));
    }
  }
  for (final p in parked) {
    if (p == null) continue;
    final (from, to, temp) = p;
    final refused = await _taken(to);
    try {
      await File(temp).rename(refused ? from : to);
      results.add((
        source: from,
        target: refused ? null : to,
        error: refused ? 'exists' : null,
      ));
    } on FileSystemException catch (e) {
      // A name the file system refuses (300 characters) must not leave the
      // file under the name it was parked by: it goes back.
      try {
        await File(temp).rename(from);
      } on FileSystemException {
        // Parked under its temporary name, which nothing else holds.
      }
      results.add((source: from, target: null, error: e.message));
    }
  }
  final order = [for (final (from, _) in renames) from];
  return results..sort(
    (a, b) => order.indexOf(a.source).compareTo(order.indexOf(b.source)),
  );
}

/// Makes the folder [name] in [parent]: null once made, else why not
/// (`invalid`, `exists` or the system's reason).
Future<String?> createFolder(String parent, String name) async {
  if (!validName(name)) return 'invalid';
  final path = joinPath(parent, name);
  if (await _taken(path)) return 'exists';
  try {
    await Directory(path).create();
    return null;
  } on FileSystemException catch (e) {
    return e.message;
  }
}

/// A file of a [Transfer]: the share of it [done], where it went, or why it
/// did not (`exists`, `changed`, `cancelled` or the system's reason).
class TransferFile {
  /// The file at [source], not started.
  new(this.source);

  /// The original's path.
  final String source;

  /// The share copied, from 0 to 1.
  double done = 0;

  /// Its path in the target folder, once there.
  String? target;

  /// Why it is not there.
  String? error;
}

/// A move or copy of files into the folder [to], one file at a time on a
/// worker: each copy is written beside its target, read back and compared
/// with the original's SHA-256 before it takes its name, and a move removes
/// the original only then; within one volume a move is a rename.
class Transfer extends ChangeNotifier {
  /// A transfer of [sources] into [to], not started.
  new(List<String> sources, this.to, {required this.move})
    : files = [for (final s in sources) TransferFile(s)];

  /// The target folder.
  final String to;

  /// Whether the originals go.
  final bool move;

  /// Every file, as it goes.
  final List<TransferFile> files;

  Job<String?>? _job;
  var _cancelled = false;

  /// Moves or copies every file, then says each outcome.
  Future<void> run() async {
    for (final file in files) {
      if (_cancelled) {
        file.error = 'cancelled';
        continue;
      }
      final job = _job = _pool.run(_transfer, [file.source, to, move]);
      final progress = job.progress.listen((done) {
        file.done = done;
        notifyListeners();
      });
      try {
        file
          ..target = await job.result
          ..done = 1;
      } on JobCancelled {
        file.error = 'cancelled';
      } on JobFailed catch (e) {
        file.error = e.error;
      } finally {
        await progress.cancel();
      }
      notifyListeners();
    }
    _job = null;
  }

  /// Stops the file under way, which keeps its original, and the rest.
  void cancel() {
    _cancelled = true;
    _job?.cancel();
  }

  /// Moves back what was moved, or removes the copies made; a file whose
  /// old place was taken since stays where it is.
  Future<void> undo() async {
    for (final file in files) {
      if (file.target case final target?) {
        try {
          move
              ? await _pool.run(_transfer, [
                  target,
                  parentOf(file.source),
                  true,
                ]).result
              // deletion-ok: the copy this transfer made
              : await File(target).delete();
          file.target = null;
        } on Exception {
          continue;
        }
      }
    }
    notifyListeners();
  }
}

/// Where the copy of [target], a file of the folder [dir], is written before
/// it takes its name: a hidden file in the same folder, its name short and
/// the same for the same target whatever the length of the target's own, which
/// can be 255 bytes, so that a file with a long name moves and a killed copy
/// leaves one partial file to write over, not a new one each time.
@visibleForTesting
String partOf(String dir, String target) =>
    '$dir${Platform.pathSeparator}.photolib-'
    '${sha1.convert(utf8.encode(target)).toString().substring(0, 16)}.part';

final _pool = WorkerPool([_transfer], size: 1);
const _transfer = Task<List<Object?>, String?>('transfer', _run);

class _Refused implements Exception {
  const new(this.reason);

  final String reason;

  @override
  String toString() => reason;
}

Future<String?> _run(List<Object?> input, TaskContext context) async {
  final [source as String, dir as String, move as bool] = input;
  final from = File(source);
  final target = joinPath(dir, baseName(source));
  if (await _taken(target)) throw const _Refused('exists');
  if (move) {
    try {
      await from.rename(target);
      return target;
    } on FileSystemException {
      // Another volume: copied below.
    }
  }
  final modified = await from.lastModified();
  final part = File(partOf(dir, target));
  try {
    final digest = await _copy(from, part, context);
    if (await sha256.bind(part.openRead()).single != digest) {
      throw const _Refused('changed');
    }
    await part.setLastModified(modified);
    if (await _taken(target)) throw const _Refused('exists');
    await part.rename(target);
  } finally {
    // The error that stopped the copy (a full disk) is the one to report, not
    // one of its clean-up.
    try {
      // deletion-ok: the partial copy this transfer made
      if (await part.exists()) await part.delete();
    } on FileSystemException {
      // A partial file is hidden and written over by the next copy.
    }
  }
  // deletion-ok: a move's original, once its copy is verified in place
  if (move) await from.delete();
  return target;
}

// Copies [from] to [to] and syncs it, returning what the original hashed to.
Future<Digest> _copy(File from, File to, TaskContext context) async {
  final size = await from.length();
  final hashed = StreamController<List<int>>();
  final digest = sha256.bind(hashed.stream).single;
  final out = await to.open(mode: FileMode.writeOnly);
  var copied = 0;
  try {
    await for (final chunk in from.openRead()) {
      await out.writeFrom(chunk);
      hashed.add(chunk);
      copied += chunk.length;
      context.progress(copied / max(size, 1));
    }
    await out.flush();
  } finally {
    await out.close();
    await hashed.close();
  }
  return await digest;
}
