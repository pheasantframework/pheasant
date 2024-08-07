// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'dart:io';
import 'package:args/args.dart';
import 'package:io/ansi.dart';
import 'package:pheasant_cli/src/utils/src/usage.dart';

void welcome(ArgParser argParser) {
  stdout.writeln(wrapWith('Pheasant\n', [styleBold, yellow]));
  stdout.writeln(
      'Welcome to the Pheasant CLI. Get started with your ${wrapWith('new web app!', [
        lightYellow
      ])}');
  printUsage(argParser);
}
