// The kernel's speed measured through a binding: the overhead of a call that does nothing, EXIF + capture time on
// 64 KiB file heads (ADR-0004's go/no-go gate), PLB decrypt throughput on a 1 MiB envelope and Argon2id at the device
// floor, which passcode setup times to calibrate t (M0-40, docs/dev/crypto-v1.md). No time is asserted here: the
// budgets are the series `kernel-binding` of tools/perf/budgets.json, which tools/perf/measure.sh checks from the
// `result:` lines [report] prints.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:test/test.dart';

import 'cases.dart';

/// Measures a binding on an empty [keyring], which it closes, with the vector files [vectors] (file name to JSON),
/// and returns the results; what it measures must work (a wrong answer fails), however long it takes. The pieces a
/// stream decrypts
/// are first passed through [input], which on the web puts them where file and network reads put bytes: in
/// JavaScript buffers. [clock] gives microseconds of this thread's CPU time where the binding can read it, so that
/// other work on a shared machine does not count; without it, the wall clock.
Map<String, double> benchmark(
  Keys keyring,
  Map<String, String> vectors, {
  Uint8List Function(Uint8List bytes) input = _same,
  int Function()? clock,
}) {
  final (call, open) = (keyring.call, keyring.open);
  Map<String, dynamic> vector(String file, String name) =>
      (jsonDecode(vectors[file]!)['cases'] as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((c) => (c['name'] as String).startsWith(name));

  // Key handle 1 seals 1 MiB, sixteen 64 KiB chunks, as kind 1 (original), which a stream decrypts chunk by chunk, as
  // apps and the viewer read originals and video.
  const plaintext = 1 << 20;
  call(5, encode({1: List.filled(32, 7)}));
  final sealed = encode({
    1: 1,
    2: 1,
    5: List.filled(32, 5),
    6: List.generate(plaintext, (i) => i % 251),
  });
  final envelope = fields(fields(call(10, sealed))[1]!)[1]!;
  final pieces = [
    for (var at = 0; at < envelope.length; at += 65552)
      input(
        Uint8List.fromList(
          envelope.sublist(at, min(at + 65552, envelope.length)),
        ),
      ),
  ];
  int decrypt() {
    final stream = open(11, encode({1: 1, 2: 1}));
    var length = 0;
    for (final piece in pieces) {
      length += stream.push(piece).length;
    }
    return length + stream.finish().length;
  }

  expect(decrypt(), greaterThan(plaintext));

  // KEK_pass at m = 64 MiB, t = 3, p = 1.
  final floor = encode({
    1: utf8.encode('123456'),
    2: [1, 0, 1, 0, 0, 0, 0, 0, 3, 1, ...List.filled(16, 0)],
    3: utf8.encode('kek/passcode'),
  });
  expect(fields(call(8, floor)).keys, [1]);

  final exif = vector('capture_time.json', 'EXIF with sub-seconds');
  final file = fields(base64Decode(exif['request'] as String));
  final head = encode({
    1: [...file[1]!, ...List.filled(65536 - file[1]!.length, 0)],
    2: file[2]!,
  });
  expect(call(2, head), base64Decode(exif['response'] as String));

  final results = <String, double>{};
  void measure(
    String name,
    double Function(double) result,
    void Function() run,
  ) {
    results[name] = result(
      seconds(run, clock: clock ?? _wall, until: (_) => true),
    );
  }

  measure('call_us', (s) => s * 1e6, () => call(0, Uint8List(0)));
  measure('decrypt_MiB_s', (s) => plaintext / s / (1 << 20), decrypt);
  measure('exif_files_s', (s) => 1 / s, () => call(2, head));
  // Within the 600 ms unlock budget (design doc 21 §8) even before calibration raises t.
  measure('argon2id_floor_ms', (s) => s * 1e3, () => call(8, floor));
  // The passcode's t from the calibration rule: at least 250 ms per unlock.
  results['passcode_t'] = min(
    64,
    max(3, (3 * 250 / results['argon2id_floor_ms']!).ceil()),
  ).toDouble();
  keyring.close();
  return results;
}

Uint8List _same(Uint8List bytes) => bytes;

final _watch = Stopwatch()..start();
int _wall() => _watch.elapsedMicroseconds;

/// The seconds that [run] takes by [clock] (microseconds) in its fastest sample, sampling for a second and then, while
/// [until] is false, for up to ten. Other work on a shared machine only slows a sample, by descheduling it or by running
/// it on a slower core, so the fastest one is the kernel's speed and a slower kernel still measures slower. A sample doubles its
/// runs until it lasts [sampleUs] and reads [clock] only at its ends, as a CPU-time clock is slow to read.
double seconds(
  void Function() run, {
  required bool Function(double) until,
  int Function() clock = _wall,
}) {
  var (best, runs) = (double.infinity, 1);
  for (
    final watch = Stopwatch()..start();
    watch.elapsedMilliseconds < 1000 ||
        !until(best) && watch.elapsedMilliseconds < 10000;
  ) {
    final start = clock();
    for (var i = 0; i < runs; i++) {
      run();
    }
    final took = clock() - start;
    if (took < sampleUs) {
      runs *= 2;
    } else {
      best = min(best, took / runs / 1e6);
    }
  }
  return best;
}

/// A sample of 1 ms often runs undisturbed even on a shared core; browsers coarsen the clock (Chrome to 100 µs), so
/// there a sample of 5 ms keeps its error within 2 %.
const sampleUs = bool.fromEnvironment('dart.library.js_interop') ? 5000 : 1000;

/// The length-delimited fields of a protobuf message, by field number.
Map<int, List<int>> fields(List<int> message) {
  final fields = <int, List<int>>{};
  for (var at = 0; at < message.length;) {
    final number = message[at++] >> 3;
    var length = 0;
    for (var shift = 0; ; shift += 7) {
      length |= (message[at] & 0x7f) << shift;
      if (message[at++] < 0x80) break;
    }
    fields[number] = message.sublist(at, at += length);
  }
  return fields;
}

/// A message of length-delimited fields and, for int values, varint fields.
Uint8List encode(Map<int, Object> fields) => Uint8List.fromList([
  for (final MapEntry(key: number, :value) in fields.entries)
    ...switch (value) {
      int n => [number << 3, ...varint(n)],
      List<int> bytes => [number << 3 | 2, ...varint(bytes.length), ...bytes],
      _ => throw ArgumentError(value),
    },
]);

List<int> varint(int n) => [for (; n >= 0x80; n >>= 7) n & 0x7f | 0x80, n];

/// Prints each of [results] that is a budget of `kernel-binding` as the line tools/perf/perf.py watch records, for
/// [target] `native`, `dart2js` or `dart2wasm`.
void report(String target, Map<String, double> results) {
  for (final MapEntry(:key, :value) in results.entries) {
    if (key == 'passcode_t') continue;
    // The measurements are the run's report.
    // ignore: avoid_print
    print(
      'result: ${jsonEncode({'budget': 'kernel-binding', 'metric': key, 'target': target, 'value': double.parse(value.toStringAsPrecision(4))})}',
    );
  }
}
