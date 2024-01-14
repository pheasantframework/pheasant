import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:path/path.dart';
import 'package:pheasant_cli/src/commands/general/errors.dart';

import 'config.dart';
import 'custom_file.dart';

Future<void> initGenerate(Logger logger, ArgResults results, ProcessManager manager, String projName) async {
  var genProgress = logger.progress('Generating Project');
  
  final dirPath = results.command?['directory'];
  String resolvedPath = projName;
  if (dirPath != null) {
    resolvedPath = normalize(absolute(dirPath));
    Directory(resolvedPath).createSync(recursive: true);
  }
  logger.trace('Generating base project');
  var proj = (dirPath == null ? resolvedPath : '$resolvedPath/$projName');
  var spawn = await manager.spawnDetached('dart', [
    'create', '-t', 'web', proj
  ]);
  
  await errorCheck(spawn, logger, genProgress);
  logger.trace('Base Project Generated');
  await pubspecConfig(logger, proj, spawn, manager, genProgress);
  genProgress.finish(showTiming: true);

  genProgress = logger.progress('Setting Up Project');
  await componentFileConfig(logger, projName, proj, resolvedPath);

  await createYamlConfig(logger, proj, projName);

  genProgress.finish(showTiming: true);
}
