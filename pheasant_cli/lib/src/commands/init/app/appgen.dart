import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:path/path.dart';

import '../config.dart';
import '../interface.dart';
import 'custom_file.dart';

import '../../general/errors.dart';

Future<void> initAppGenerate(
    Logger logger, ArgResults results, ProcessManager manager, String projName,
    {bool linter = false}) async {
  // Generate Project
  final baseProject = await baseGeneration(logger, results, projName, manager);
  var proj = baseProject.proj;
  var spawn = baseProject.process;
  var genProgress = baseProject.progress;
  var resolvedPath = baseProject.path;

  // Configure pubspec.yaml file
  await pubspecConfig(logger, proj, spawn, manager, genProgress);
  genProgress.finish(showTiming: true);

  // Configure component files
  genProgress = logger.progress('Setting Up Project');
  await componentFileConfig(logger, projName, proj, resolvedPath);

  // Configure pheasant.yaml file
  await createYamlConfig(logger, proj, projName, cliAnswers: appanswers);

  await analysisOptionsConfig(proj, projName, lint: linter);

  genProgress.finish(showTiming: true);
}

class ProjGenClass {
  Logger logger;
  
  Progress progress;
  
  String proj;
  
  String path;
  
  Process process;

  ProjGenClass({
    required this.logger,
    required this.progress,
    required this.proj,
    required this.path,
    required this.process,
  });
}

Future<ProjGenClass> baseGeneration(Logger logger, ArgResults results, String projName, ProcessManager manager) async {
  var genProgress = logger.progress('Generating Project');
  // Create directory if stated
  final dirPath = results.command?['directory'];
  String resolvedPath = projName;
  if (dirPath != null) {
    resolvedPath = normalize(absolute(dirPath));
    Directory(resolvedPath).createSync(recursive: true);
  }

  // Create base project
  logger.trace('Generating base project');
  var proj = (dirPath == null ? resolvedPath : '$resolvedPath/$projName');
  var spawn = await manager.spawnDetached('dart', [
    'create',
    '-t',
    'web',
    proj,
    results.command!.wasParsed('force') ? '--force' : ''
  ]);
  // Check for errors in spawn
  await errorCheck(spawn, logger, genProgress);
  logger.trace('Base Project Generated');

  return ProjGenClass(
    logger: logger,
    progress: genProgress,
    path: resolvedPath,
    proj: proj,
    process: spawn
  );
}
