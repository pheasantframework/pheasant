import 'dart:io';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../general/errors.dart';

Future<void> createYamlConfig(Logger logger, String proj, String projName) async {
  logger.trace('Setting Up Config File');
  File configFile = await File('$proj/pheasant.yaml').create();
  Map<String, dynamic> config = {
    'project': projName,
    'version': '1.0.0',
    'env': 'dart',
    'entry': {
      'main': 'web/main.dart',
      'app': 'lib/App.phs'
    },
    'config': {
      'sass': true,
      'js': true,
      'linter': true,
      'formatter': true,
      'phsComponents': true
    },
    'plugins': [],
    'dependencies': []
  };
  final yamlEditor = YamlEditor('');
  yamlEditor.update([], config);
  await configFile.writeAsString(yamlEditor.toString());
}

Future<void> pubspecConfig(Logger logger, String proj, Process spawn, ProcessManager manager, Progress genProgress) async {
   logger.trace('Configuring Pubspec');
  String pubspecData = await File('$proj/pubspec.yaml').readAsString();
  pubspecData += '\npublish_to: none';
  var pubspecEditor = YamlEditor(pubspecData);
  await File('$proj/pubspec.yaml').writeAsString(pubspecEditor.toString());
  
  logger.trace('Adding Dependencies');
  
  spawn = await manager.spawnDetached(
    'dart', ['pub', 'add', '-C', proj, 
    'pheasant:{"git":{"url":"https://github.com/pheasantframework/pheasant.git","ref":"development","path":"pheasant"}}'
  ]);
  await errorCheck(spawn, logger, genProgress);
  
  logger.trace('Dependencies Added');
}
