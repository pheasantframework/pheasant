// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.  
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

import 'cmds.dart';
import 'shared/categorize.dart';

/// The Command for `pheasant init`
class InitCommand extends Command {
  @override
  String get description => '''Create a new Pheasant Project
  
  This command can be used to either create a new Pheasant Web Application, or a Pheasant Plugin for use in Pheasant Web Applications''';

  @override
  String get name => "init";

  @override
  String get category => categorize("main");

  InitCommand() {
    argParser..addOption(
            'directory',
            abbr: 'd',
            valueHelp: 'directory',
            help: 'The directory to create your new project',
          )
          ..addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging")
          ..addFlag('yes',
              abbr: 'y',
              negatable: false,
              help:
                  'Applies "yes" to all "yes/No" questions asked for configuring the project.')
          ..addFlag('force',
              abbr: 'f',
              negatable: false,
              help: 'Force Creation of this Project.')
          ..addOption('type',
              abbr: 't',
              help: 'The type of Pheasant Project to generate',
              allowed: ['plugin', 'app'],
              defaultsTo: 'app');
  }

  @override
  void run() {
    initCommand(argResults!);
  }
}

/// The command for `pheasant doctor`
class DoctorCommand extends Command {
  @override
  String get description => '''Doctor Command''';

  @override
  String get name => 'doctor';

  DoctorCommand() {
    argParser.addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging");
  }

  @override
  void run() => doctorCommand(argResults!);
}

/// The command for `pheasant run`
class RunCommand extends Command {
  @override
  String get description => '''Run your Pheasant Application
  
  This command is used to run a pheasant application and serve on the web. 
  This is similar to the serve command but allows for running on release''';

  @override
  String get name => "run";

  @override
  String get category => categorize("main");

  RunCommand() {
    argParser..addOption('port',
              abbr: 'p',
              defaultsTo: '8080',
              help: 'The port to run the web app on.')
          ..addOption('output',
              abbr: 'o',
              help: 'A directory to write the results of the build to.')
              ..addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging")
          ..addFlag('release',
              abbr: 'r',
              negatable: true,
              help: 'Whether to run the release version of the application.');
  }

  @override
  void run() => runCommand(argResults!);
}

/// The command for `pheasant build`
class BuildCommand extends Command {
  @override
  String get description => '''Build a Pheasant Application
  
  This Command is used to build a pheasant application to JavaScript. 
  This application can then be served on a server from the output (specified with ${styleBold.wrap('-o')} or the ${styleItalic.wrap('build/')} directory by default).''';

  @override
  String get name => "build";

  @override
  String get category => categorize("main");

  BuildCommand() {
    argParser..addFlag('release',
              abbr: 'r', help: 'Build with release mode for this app')
              ..addFlag('test', negatable: true, defaultsTo: true, help: "Run tests before building command")
              ..addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging")
          ..addOption('output',
              abbr: 'o',
              help: 'A directory to write the results of the build to.');
  }

  @override
  void run() => buildCommand(argResults!);
}

/// The command for `pheasant add`
class AddCommand extends Command {
  @override
  String get description => '''Add Plugins to your project
  
  This can be used to add plugins to your project, which are different from normal Dart dependencies to your project, as they are used by the Pheasant Compiler.''';

  @override
  String get name => "add";

  @override
  String get category => categorize("plugins");

  AddCommand() {
    argParser..addOption('git',
              valueHelp: 'url',
              help:
                  'Denote this is a github plugin with the repository at <url>')
                  ..addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging")
          ..addOption('path',
              valueHelp: 'PATH',
              help: 'Denote this is a plugin gotten from path: <PATH>')
          ..addOption('hosted',
              valueHelp: 'url',
              help:
                  'Denote that this plugin is hosted outside pub.dev and on <url>');
  }

  @override
  void run() => addCommand(argResults!);
}

/// The command for `pheasant remove`
class RemoveCommand extends Command {
  @override
  String get description => '''Remove Plugins to your project
  
  This can be used to remove plugins to your project, which are different from normal Dart dependencies to your project, as they are used by the Pheasant Compiler.''';

  @override
  String get name => "remove";

  @override
  String get category => categorize("plugins");

  RemoveCommand() {
    argParser.addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging");
  }

  @override
  void run() => removeCommand(argResults!);
}

/// The command for `pheasant create`
class CreateCommand extends Command {
  @override
  String get description => InitCommand().description;

  @override
  String get summary => "Alias for 'init'";

  @override
  String get name => "create";

  @override
  String get category => categorize("main");

  CreateCommand() {
    argParser..addOption(
            'directory',
            abbr: 'd',
            valueHelp: 'directory',
            help: 'The directory to create your new project',
          )
          ..addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging")
          ..addFlag('yes',
              abbr: 'y',
              negatable: false,
              help:
                  'Applies "yes" to all "yes/No" questions asked for configuring the project.')
          ..addFlag('force',
              abbr: 'f',
              negatable: false,
              help: 'Force Creation of this Project.');
  }

  @override
  void run() => initCommand(argResults!);
}

/// The command for `pheasant serve`
class ServeCommand extends Command {
  @override
  String get description => '''Run your Pheasant Application
  
  This command is used to run a pheasant application and serve on the web.''';

  @override
  String get summary => "Alias for 'run'";

  @override
  String get name => "serve";

  @override
  String get category => categorize("main");

  ServeCommand() {
    argParser
    ..addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging")
    ..addOption('port',
              abbr: 'p',
              defaultsTo: '8080',
              help: 'The port to run the web app on');
  }

  @override
  void run() => runCommand(argResults!);
}

/// The command for `pheasant test`
class TestCommand extends Command {
  @override
  String get description => '''Test a Pheasant Application
  
  This Command is used to test your pheasant applications or plugins. 
  This command is also run before building unless the ${styleItalic.wrap("--no-test")} flag is passed to the build command. See more at "pheasant help build".''';

  @override
  String get name => "test";

  @override
  String get category => categorize("main");

  TestCommand() {
    argParser.addFlag('verbose', abbr: 'V', negatable: false, help: "Output Verbose Logging");
  }

  @override
  FutureOr? run() => throw UnimplementedError("The 'test' command is not available at the moment.");
}

// TODO: Do not implement yet
abstract class PheasantCommand extends Command {}
