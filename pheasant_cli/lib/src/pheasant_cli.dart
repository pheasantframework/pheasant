// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.  
// You may use this file only in accordance with the license.
  
import 'package:args/command_runner.dart';
import 'package:pheasant_cli/src/commands/cmdrunner.dart';
import 'package:pheasant_cli/src/commands/commands.dart';

/// Command to run the CLI 
Future<CommandRunner> run(List<String> args) async {
  return PheasantCommandRunner("pheasant", "The Pheasant Framework Command Line Interface")
  ..addCommand(DoctorCommand())
  ..addCommand(InitCommand())
  ..addCommand(RunCommand())
  ..addCommand(BuildCommand())
  ..addCommand(ServeCommand())
  ..addCommand(CreateCommand())
  ..addCommand(TestCommand())
  ..addCommand(AddCommand())
  ..addCommand(RemoveCommand())
  ..run(args);
}