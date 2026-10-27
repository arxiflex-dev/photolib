// The kernel's speed through its WebAssembly build in a browser (test/bench.dart), printed as `result:` lines for
// tools/perf/measure.sh, which checks them against the series `kernel-binding` of tools/perf/budgets.json; no time is
// asserted here: `dart test -p chrome -c dart2js -c dart2wasm benchmark/web_bench_test.dart` (the `web` part of
// tools/check.sh).
@TestOn('browser')
@Timeout(Duration(minutes: 10))
library;

import 'dart:js_interop';

import 'package:photolib_kernel/photolib_kernel_web.dart';
import 'package:test/test.dart';

import '../test/bench.dart';
import '../test/cases.dart';

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
  test('the kernel is measured through WebAssembly', () async {
    // The VM side builds the module and pins the browser to the fastest cores.
    final setup =
        await spawnHybridUri('../test/wasm_server.dart').stream.first as Map;
    final results = benchmark(
      keys(await Kernel.load(Uri.parse(setup['module'] as String))),
      (setup['vectors'] as Map).cast<String, String>(),
      input: (bytes) => bytes.toJS.toDart,
    );
    report(
      const bool.fromEnvironment('dart.tool.dart2wasm')
          ? 'dart2wasm'
          : 'dart2js',
      results,
    );
  });
}
