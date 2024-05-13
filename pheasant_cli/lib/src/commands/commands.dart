// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:pheasant_cli/src/commands/add/add_plugins.dart';
import 'package:pheasant_cli/src/commands/general/configfile.dart';
import 'package:pheasant_cli/src/commands/remove/remove_plugins.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pub;

import 'run/prereq/get_plugins.dart';
import 'run/bg_process.dart';
import 'run/main_process.dart';
import 'init/app/appgen.dart';
import 'init/plugin/plugingen.dart';
import 'init/interface.dart';
import 'doctor/sdksearch.dart';
import 'general/validate_project.dart';
import 'build/build_application.dart';

import '../config/config.dart';
import '../constants/buildfile.dart';
import '../constants/clidoc.dart';
import '../utils/src/usage.dart';

enum ProjectType { Application, Plugin, DevPlugin }

ProjectType parseProject(String name) {
  if (name == 'app') return ProjectType.Application;
  if (name == 'plugin') return ProjectType.Plugin;
  if (name == 'dev-plugin') return ProjectType.DevPlugin;
  return ProjectType.Application;
}

void initCommand(ArgResults results) async {
  ProjectType projectType;
  try {
    projectType = parseProject(results.command?['type']);
  } catch (e) {
    stderr.writeln(red.wrap('"type" value invalid.'));
    exit(ExitCode.noInput.code);
  }
  if (results.arguments.length <= 1) {
    stderr.writeln(
        red.wrap('Give a name or directory for your project to get started.'));
    exit(ExitCode.noInput.code);
  }
  stdout.writeAll([
    wrapWith('Welcome to the Pheasant CLI\n', [lightYellow, styleBold]),
    "Let's get strated with your new project\n",
    "\n"
  ]);
  final projName = (results.arguments[1].contains('-')
      ? results.arguments.last.split('/').last
      : results.arguments[1]);

  switch (projectType) {
    case ProjectType.Application:
      initAppInterface(results);
      break;
    case ProjectType.Plugin:
      await initPluginInterface(results);
      break;
    default:
      break;
  }

  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  var manager = ProcessManager(stdin: stdin);

  switch (projectType) {
    case ProjectType.Application:
      await initAppGenerate(logger, results, manager, projName,
          linter: appanswers.values.toList()[3]);
      break;
    case ProjectType.Plugin:
      await initPluginGenerate(
          logger, results, manager, projName, pluginanswers);
      break;
    default:
      break;
  }

  logger.stdout('All ${logger.ansi.emphasized('done')}.');
  exit(0);
}

void doctorCommand(ArgResults results) async {
  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();

  logger.stdout(cyan.wrap('The Pheasant Framework depends on the Dart SDK') ??
      'The Pheasant Framework depends on the Dart SDK');
  await findSdk(logger);
  logger.stdout('All ${logger.ansi.emphasized('done')}.');
}

void helpCommand(ArgResults results, ArgParser parser) {
  if (results.rest.isEmpty && results.arguments.length <= 1) {
    stderr.writeln(('Enter a command to get the help documentation\n'));
    printUsage(parser);
    exit(ExitCode.noInput.code);
  }
  final command = results.arguments[1];
  if (!parser.commands.keys.contains(command) &&
      cmdInfo.keys.contains(command)) {
    stderr.writeln(red.wrap('The following command does not exist: $command'));
    exit(ExitCode.unavailable.code);
  }
  stdout.writeAll([
    wrapWith('The $command command\n', [styleBold]),
    commandUsage(parser, command)
  ]);
}

void runCommand(ArgResults results) async {
  List<String> configArgs =
      results.wasParsed('define') ? results['define'] : [];
  String port =
      results.command!.wasParsed('port') ? results.command!['port'] : '8080';

  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  var buildManager = ProcessManager();
  var serveManager = ProcessManager();

  logger.stdout(wrapWith('Pheasant\n', [yellow, styleBold])!);
  AppConfig appConfig = await validateProject(logger, configArgs);

  var progress = logger.progress('Preparing Project for Build');
  File buildFile = await File('build.yaml').create();
  if (!(appConfig.plugins.isEmpty && appConfig.devPlugins.isEmpty)) {
    await getPlugins(appConfig, logger: logger);
  }
  final data = pub.Pubspec.parse(File('pubspec.yaml').readAsStringSync());

  buildFile = await buildFile
      .writeAsString(genBuildFile(appConfig, projNameFromPubspec: data.name));
  progress.finish(showTiming: true);

  await Future.wait([
    bgProcess(buildManager, logger),
    mainProcess(serveManager, logger,
        port: port,
        options: results.command?.options ?? [],
        output: results.command!['output']),
  ]);

  await buildFile.delete();
}

void buildCommand(ArgResults results) async {
  List<String> configArgs =
      results.wasParsed('define') ? results['define'] : [];
  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  var manager = ProcessManager();

  Progress progress = await checkProjectBeforeBuild(logger, configArgs);

  await buildApplication(progress, logger, manager, results);

  logger.stdout('All ${logger.ansi.emphasized('done')}.\n');
  logger.stdout('Build Written to ${results.command!['output'] ?? 'build'}/');
  exit(0);
}

void addCommand(ArgResults results) async {
  List<String> configArgs =
      results.wasParsed('define') ? results['define'] : [];
  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  List<String> plugins = results.command!.arguments
      .where((element) => !element.contains('-'))
      .toList();
  String? gitUrl = results.command!['git'];
  String? pathUrl = results.command!['path'];
  String? hostUrl = results.command!['hosted'];

  Iterable<List<String>> items = plugins.map((e) => e.split(':'));
  var genProgress = logger.progress("Adding plugin(s) to 'pheasant.yaml' file");
  logger.stdout('\n');
  logger.trace('Parsing config file');
  AppConfig appConfig = await validateProject(logger, configArgs, plugin: true);
  logger.trace('Adding plugins');
  AppConfig newConfig = addPlugins(items, gitUrl, appConfig, pathUrl, hostUrl);
  await writeConfigToFile(newConfig);
  genProgress.finish(showTiming: true);

  logger.stdout('All ${logger.ansi.emphasized('done')}.');
  logger.stdout(
      'The following plugins were added: ${logger.ansi.emphasized(plugins.join(' '))}');
  exit(0);
}

void removeCommand(ArgResults results) async {
  List<String> configArgs =
      results.wasParsed('define') ? results['define'] : [];
  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  List<String> plugins = results.command!.arguments
      .where((element) => !element.contains('-'))
      .toList();

  var genProgress = logger.progress('Removing Plugins');
  logger.stdout('\n');
  logger.trace('Parsing config file');
  AppConfig appConfig = await validateProject(logger, configArgs, plugin: true);
  removePlugins(appConfig, plugins);
  await writeConfigToFile(appConfig);

  genProgress.finish(showTiming: true);

  logger.stdout('All ${logger.ansi.emphasized('done')}.');
  logger.stdout(
      'The following plugins were removed: ${logger.ansi.emphasized(plugins.join(' '))}');
  exit(0);
}
