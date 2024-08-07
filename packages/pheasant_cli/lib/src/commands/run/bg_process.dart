// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'dart:convert';
import 'dart:io';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import '../general/errors.dart';

Future<void> bgProcess(ProcessManager manager, Logger logger) async {
  // Test
  var process =
      await manager.spawnDetached('dart', ['run', 'build_runner', 'watch'])
        ..stdout.transform(utf8.decoder).forEach((event) {
          if (event.contains('Succeeded')) {
            stdout.writeln('\nBuild Succeeded');
          }
        });
  await errorCheck(process, logger, null);

  ProcessSignal.sigint.watch().listen((event) {
    stdout.write(styleItalic.wrap('\nExiting Web App...'));
    process.kill();
    File('build.yaml').deleteSync();
  });
}
