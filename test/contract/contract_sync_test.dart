// Guards against a stale contract copy: when RankeBE is checked out next to
// this repo (../RankeBE, or RANKE_BE_DIR), test/contract/fixtures must be
// byte-identical to its contract/ directory. Fix with tool/sync_contract.sh.
//
// Skipped when the backend isn't available (e.g. mobile-only CI); the
// fixtures committed here are then the contract.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'fake_backend.dart';

void main() {
  final beDir = Platform.environment['RANKE_BE_DIR'] ?? '../RankeBE';
  final source = Directory('$beDir/contract');

  test(
    'fixtures match the backend contract',
    () {
      Map<String, String> read(Directory dir) => {
        for (final f in dir.listSync(recursive: true).whereType<File>())
          if (!f.path.endsWith('README.md'))
            f.path.substring(dir.path.length + 1): f.readAsStringSync(),
      };

      final backend = read(source);
      final app = read(Directory(Contract.dir));

      final problems = [
        for (final name in backend.keys)
          if (!app.containsKey(name))
            'missing: $name'
          else if (app[name] != backend[name])
            'differs: $name',
        for (final name in app.keys)
          if (!backend.containsKey(name)) 'no longer in the backend: $name',
      ]..sort();

      expect(
        problems,
        isEmpty,
        reason:
            'test/contract/fixtures is out of date with ${source.path} — '
            'run tool/sync_contract.sh',
      );
    },
    skip: source.existsSync()
        ? false
        : 'backend contract not found at ${source.path}',
  );
}
