import 'dart:io';
import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../general/errors.dart';

Future<void> createYamlConfig(Logger logger, String proj, String projName, {Map<String, dynamic>? cliAnswers}) async {
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
      'sass': cliAnswers?.values.toList()[0] ?? false,
      'js': cliAnswers?.values.toList()[1] ?? false,
      'linter': cliAnswers?.values.toList()[3] ?? false,
      'formatter': cliAnswers?.values.toList()[4] ?? false,
      'phsComponents': cliAnswers?.values.toList()[2] ?? false
    },
    'plugins': [],
    'dependencies': []
  };
  final yamlEditor = YamlEditor('');
  yamlEditor.update([], config);
  await configFile.writeAsString(yamlEditor.toString());
}

Future<void> pubspecConfig(Logger logger, String proj, Process spawn, ProcessManager manager, Progress genProgress) async {
  logger.trace('Adding Dependencies');
  spawn = await manager.spawnDetached(
    'dart', ['pub', 'add', '-C', proj, 
    'pheasant:any'
  ]);
  await errorCheck(spawn, logger, genProgress);
  logger.trace('Dependencies Added');
  
}
