// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.

import 'package:args/command_runner.dart';

class PheasantCommandRunner extends CommandRunner {
  final String version;

  PheasantCommandRunner(super.executableName, super.description, {this.version = "0.1.0"}): super() {
    argParser.addFlag('version', abbr: 'v', negatable: false, help: "Print out the current pheasant version");
  }

  @override
  Future run(Iterable<String> args) {
    if (args.contains('--version') || args.contains('-v')) {
        return Future.sync(() => print('pheasant version 0.1.0'));
    }
    return super.run(args);
  }

}
