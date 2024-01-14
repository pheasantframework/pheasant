import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:path/path.dart';

import '../general/errors.dart';
import 'interface.dart';
import 'config.dart';
import 'custom_file.dart';

Future<void> initGenerate(Logger logger, ArgResults results, ProcessManager manager, String projName) async {
  // Generate Project
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
    'create', '-t', 'web', proj
  ]);
  // Check for errors in spawn
  await errorCheck(spawn, logger, genProgress);
  logger.trace('Base Project Generated');

  // Configure pubspec.yaml file
  await pubspecConfig(logger, proj, spawn, manager, genProgress);
  genProgress.finish(showTiming: true);

  // Configure component files
  genProgress = logger.progress('Setting Up Project');
  await componentFileConfig(logger, projName, proj, resolvedPath);

  // Configure pheasant.yaml file
  await createYamlConfig(logger, proj, projName, cliAnswers: answers);

  genProgress.finish(showTiming: true);
}
