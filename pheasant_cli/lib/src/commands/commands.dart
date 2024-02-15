import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pub;

import 'run/bg_process.dart';
import 'run/main_process.dart';
import 'init/gen.dart';
import 'init/interface.dart';
import 'doctor/sdksearch.dart';
import 'general/validate_project.dart';
import 'build/build_application.dart';

import '../config/config.dart';
import '../constants/buildfile.dart';
import '../constants/clidoc.dart';
import '../utils/src/usage.dart';

void initCommand(ArgResults results) async {
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
  initInterface(results);
  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  var manager = ProcessManager();

  await initGenerate(logger, results, manager, projName,
      linter: answers.values.toList()[3]);

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
