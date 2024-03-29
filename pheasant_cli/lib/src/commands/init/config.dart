import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:io/io.dart';
import 'package:pheasant_cli/src/config/config.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../general/errors.dart';

Future<void> createYamlConfig(Logger logger, String proj, String projName,
    {Map<String, dynamic>? cliAnswers, AppConfig? appConfig}) async {
  logger.trace('Setting Up Config File');
  File configFile = await File('$proj/pheasant.yaml').create();
  Map<String, dynamic> config = {
    'project': projName,
    'version': '1.0.0',
    'env': 'dart',
    'entry': {'main': 'web/main.dart', 'app': 'lib/App.phs'},
    'config': {
      'sass': cliAnswers?.values.toList()[0] ?? false,
      'js': cliAnswers?.values.toList()[1] ?? false,
      'linter': cliAnswers?.values.toList()[3] ?? false,
      'formatter': cliAnswers?.values.toList()[4] ?? false,
      'phsComponents': cliAnswers?.values.toList()[2] ?? false
    },
    'plugins': {
      'main':
          appConfig?.plugins.where((el) => el is! PheasantDevPlugin).map((e) {
                Map<String, dynamic> plugmap = {
                  e.name: {'version': e.version}
                };
                if (e.source != null) {
                  plugmap[e.name].addAll({'source': e.source!});
                }
                if (e.sourcesupp != null && e.sourcesuppName != null) {
                  plugmap[e.name].addAll({e.sourcesuppName!: e.sourcesupp!});
                }
                return plugmap;
              }).toList() ??
              [],
      'dev': appConfig?.plugins.whereType<PheasantDevPlugin>().map((e) {
            Map<String, dynamic> plugmap = {
              e.name: {'version': e.version}
            };
            if (e.source != null) plugmap[e.name].addAll({'source': e.source!});
            if (e.sourcesupp != null && e.sourcesuppName != null) {
              plugmap[e.name].addAll({e.sourcesuppName!: e.sourcesupp!});
            }
            return plugmap;
          }).toList() ??
          []
    },
    'dependencies': []
  };
  final yamlEditor = YamlEditor('');
  yamlEditor.update([], config);
  await configFile.writeAsString(yamlEditor.toString());
}

Future<void> pubspecConfig(Logger logger, String proj, Process spawn,
    ProcessManager manager, Progress genProgress) async {
  logger.trace('Adding Dependencies');
  spawn = await manager
      .spawnDetached('dart', ['pub', 'add', '-C', proj, 'pheasant:any']);
  await errorCheck(spawn, logger, genProgress);
  logger.trace('Dependencies Added');
}

Future<void> analysisOptionsConfig(String projDir, String projName,
    {bool lint = false}) async {
  var analysisOptions =
      await File('$projDir/analysis_options.yaml').readAsString();
  analysisOptions += '''
analyzer:
  exclude: [build/**]
  errors:
    uri_has_not_been_generated: ignore

''';
  if (lint) {
    analysisOptions += '''
linter:
  rules:
    - camel_case_types
''';
  }
  await File('$projDir/analysis_options.yaml').writeAsString(analysisOptions);
}
