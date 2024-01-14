import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pub;

import '../general/errors.dart';
import '../general/validate_project.dart';
import '../../config/config.dart';
import '../../constants/buildfile.dart';


Future<void> buildApplication(Progress progress, Logger logger, ProcessManager manager, ArgResults results) async {
  progress = logger.progress('Cleaning Cache');
  var cacheClean = await manager.spawnDetached('dart', ['run', 'build_runner', 'clean']);
  await errorCheck(cacheClean, logger, progress);
  progress.finish(showTiming: true);
  progress = logger.progress('Building Code');
  List<String> args = ['build'];
  if (results.command!.wasParsed('output')) args.addAll(['--output', results.command!['output']]);
  if (results.command!.wasParsed('release')) args.add('--release');
  var buildProject = await manager.spawnDetached('webdev', args);
  await errorCheck(buildProject, logger, progress);
}

Future<Progress> checkProjectBeforeBuild(Logger logger, List<String> configArgs) async {
  var progress = logger.progress('Checking Project');
  logger.trace('Verifying code is running in project root, and all files are ready');
  AppConfig appConfig = await validateProject(logger, configArgs);
  logger.trace('Checking "build.yaml" file');
  bool buildFileExists = await File('build.yaml').exists();
  if (!buildFileExists) {
    File buildFile = await File('build.yaml').create();
    final data = pub.Pubspec.parse(File('pubspec.yaml').readAsStringSync());
    buildFile = await buildFile.writeAsString(genBuildFile(appConfig, projNameFromPubspec: data.name));
  }
  progress.finish(showTiming: true);
  return progress;
}
