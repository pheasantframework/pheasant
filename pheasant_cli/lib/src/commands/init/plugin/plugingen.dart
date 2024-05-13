// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:path/path.dart';

import 'pluginconfig.dart';
import '../../general/errors.dart';
import '../app/appgen.dart';
import '../config.dart';

FutureOr<void> initPluginGenerate(
    Logger logger,
    ArgResults results,
    ProcessManager manager,
    String projName,
    Map<String, dynamic> pluginanswers) async {
  final baseProject = await baseGeneration(logger, results, projName, manager);
  var proj = baseProject.proj;
  var spawn = baseProject.process;
  var genProgress = baseProject.progress;
  var resolvedPath = baseProject.path;

  await pubspecConfig(logger, proj, spawn, manager, genProgress);
  genProgress.finish(showTiming: true);

  await fileGenConfig(logger, projName, proj, resolvedPath, manager,
      filesRef: pluginanswers, results: results);

  // Configure pheasant.yaml file
  await createYamlConfig(logger, proj, projName);

  await _makeYamlPlugin(proj);

  genProgress.finish(showTiming: true);
}

Future<void> _makeYamlPlugin(String proj) async {
  String pheasantYamlRerender = '''
project: nini
version: 1.0.0
env: dart
type: plugin
config:
  sass: false
  js: false
  linter: false
  formatter: false
  phsComponents: false
plugins:
  main: []
  dev: []
dependencies: []
''';
  await File('$proj/pheasant.yaml').writeAsString(pheasantYamlRerender);
}

Future<ProjGenClass> baseGeneration(Logger logger, ArgResults results,
    String projName, ProcessManager manager) async {
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
    'package',
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
      process: spawn);
}
