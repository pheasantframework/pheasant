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

Future<void> errorCheck(
    Process spawn, Logger logger, Progress? genProgress) async {
  var exitCode = await spawn.exitCode;
  if (exitCode != 0) {
    logger.trace(red.wrap('Error: Program exited with exit code - $exitCode')!);
    final errorStream = spawn.stderr;
    logger.trace('Stream: ${await errorStream.transform(utf8.decoder).join()}');
    genProgress?.finish(showTiming: true);
    logger.stderr(
        "Couldn't create project: Program exited with exit code $exitCode");
    exit(exitCode);
  }
}
