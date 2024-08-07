// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'dart:io';
import 'package:args/args.dart';

import 'general/welcome.dart';
import 'commands.dart';

void handleCommand(ArgResults argResults, ArgParser argParser) {
  switch (argResults.command?.name) {
    case 'init':
    case 'create':
      initCommand(argResults);
      break;
    case 'doctor':
      doctorCommand(argResults);
      break;
    case 'help':
      helpCommand(argResults, argParser);
      break;
    case 'run':
    case 'serve':
      runCommand(argResults);
      break;
    case 'build':
      buildCommand(argResults);
      break;
    case 'add':
      addCommand(argResults);
      break;
    case 'remove':
      removeCommand(argResults);
      break;
    default:
      if (argResults.command != null) stderr.writeln('Invalid Command');
      welcome(argParser);
      break;
  }
}
