import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_config/cli_config.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pub;

import 'run/getters/configfile.dart';
import 'run/precheck.dart';
import 'run/bg_process.dart';
import 'run/main_process.dart';
import 'init/gen.dart';
import 'init/interface.dart';
import 'doctor/sdksearch.dart';

import '../config/config.dart';
import '../config/configfile.dart';
import '../constants/buildfile.dart';
import '../constants/clidoc.dart';
import '../utils/src/usage.dart';

void initCommand(ArgResults results) async {
  if (results.arguments.length <= 1) {
    stderr.writeln(red.wrap('Give a name or directory for your project to get started.'));
    exit(ExitCode.noInput.code);
  }
  stdout.writeAll([
    wrapWith('Welcome to the Pheasant CLI\n', [lightYellow, styleBold]),
    "Let's get strated with your new project\n",
    "\n"
  ]);
  final projName = (
    results.arguments[1].contains('-') 
    ? results.arguments.last.split('/').last 
    : results.arguments[1]
  );
  initInterface(results);
  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  var manager = ProcessManager();

  await initGenerate(logger, results, manager, projName);
  
  logger.stdout('All ${logger.ansi.emphasized('done')}.');
  exit(0);
}

void doctorCommand(ArgResults results) async {
  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();

  logger.stdout(cyan.wrap('The Pheasant Framework depends on the Dart SDK') 
  ?? 'The Pheasant Framework depends on the Dart SDK');
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
  if (!parser.commands.keys.contains(command) && cmdInfo.keys.contains(command)) {
    stderr.writeln(red.wrap('The following command does not exist: $command'));
    exit(ExitCode.unavailable.code);
  }
  stdout.writeAll([
    wrapWith('The $command command\n', [styleBold]),
    commandUsage(parser, command)
  ]);
}

void runCommand(ArgResults results) async {
  List<String> configArgs = results.wasParsed('define') ? results['define'] : [];
  String port = results.command!.wasParsed('port') ? results.command!['port'] : '8080';

  var verbose = results.wasParsed('verbose');
  var logger = verbose ? Logger.verbose() : Logger.standard();
  var buildManager = ProcessManager();
  var serveManager = ProcessManager();

  logger.stdout(wrapWith('Pheasant\n', [yellow, styleBold])!);
  await checkConfigFiles(logger);
  logger.trace('Reading Data for Config File');
  var configFileData = File(configFile).readAsStringSync();
  var config = Config.fromConfigFileContents(
    fileContents: configFileData,
    commandLineDefines: configArgs,
    environment: Platform.environment
  );
  var appConfig = configFileType == PheasantConfigFile.yaml 
  ? PheasantCliBaseConfig.fromYaml(configFileData, configOverrides: config)
  : PheasantCliBaseConfig.fromJson(configFileData, configOverrides: config);
  handleConfig(config, appConfig: appConfig);
  // Verify you are in right directory
  await checkProject(logger, appConfig);

  var progress = logger.progress('Preparing Project for Build');
  File buildFile = await File('build.yaml').create();
  final data = pub.Pubspec.parse(File('pubspec.yaml').readAsStringSync());
  buildFile = await buildFile.writeAsString(genBuildFile(appConfig, projNameFromPubspec: data.name));
  progress.finish(showTiming: true);
  
  await Future.wait([
    bgProcess(buildManager, logger),
    mainProcess(serveManager, logger, port),
  ]);


  await buildFile.delete();
}

/// Unimplemented yet
void handleConfig(Config config, {PheasantCliBaseConfig? appConfig}) {
  
}
