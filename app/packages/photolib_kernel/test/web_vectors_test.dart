// Runs the kernel's conformance vectors through its WebAssembly build in a
// browser, as vectors_test.dart does through the C ABI: `dart test -p chrome
// -c dart2js -c dart2wasm` (the `web` part of tools/check.sh). Its speed is
// benchmark/web_bench_test.dart's.
@TestOn('browser')
@Timeout(Duration(minutes: 10))
library;

import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:photolib_harness/photolib_harness.dart';
import 'package:photolib_kernel/photolib_kernel_web.dart';
import 'package:test/test.dart';

import 'cases.dart';

@JS()
external bool get crossOriginIsolated;

@JS('navigator.userAgent')
external String get userAgent;

Keys keys(Kernel kernel) {
  final keyring = kernel.keyring();
  return (
    call: keyring.call,
    open: (method, request) {
      final stream = keyring.openStream(method, request);
      return (push: stream.push, finish: stream.finish);
    },
    close: keyring.close,
  );
}

void main() {
  strict();
  late final Uri module;
  late final Map<Object?, Object?> vectors;
  setUpAll(() async {
    final setup = await spawnHybridUri('wasm_server.dart').stream.first as Map;
    module = Uri.parse(setup['module'] as String);
    vectors = setup['vectors'] as Map;
  });

  test('the vectors pass without cross-origin isolation', () async {
    expect(crossOriginIsolated, isFalse);
    final kernel = await Kernel.load(module);
    expect(vectors, isNotEmpty);
    vectors.forEach((file, text) {
      final json = jsonDecode(text as String) as Map<String, dynamic>;
      for (final c in (json['cases'] as List).cast<Map<String, dynamic>>()) {
        expect(
          run(keys(kernel), c, json),
          equals(expected(c)),
          reason: '$file: ${c['name']}',
        );
      }
    });
  });

  test('a panic traps only its call; '
      'then the module refuses calls until loaded again', () async {
    final kernel = await Kernel.load(module);
    final keyring = kernel.keyring();
    expect(keyring.call(panicProbe, Uint8List(0)), kernelPanic);
    expect(() => kernel.call(3, Uint8List(0)), throwsStateError);
    expect(() => keyring.call(3, Uint8List(0)), throwsStateError);
    expect(() => kernel.openStream(10, Uint8List(0)), throwsStateError);
    final again = await Kernel.load(module);
    expect(again.call(panicProbe, Uint8List(0)), kernelPanic);
    expect((await Kernel.load(module)).call(3, Uint8List(0)), [0x0a, 0x00]);
  });

  test('a module that is not there fails to load', () {
    expect(Kernel.load(module.resolve('missing.js')), throwsA(anything));
  });
}
