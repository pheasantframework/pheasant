import 'dart:convert';

import 'package:cli_config/cli_config.dart';
import 'package:yaml/yaml.dart';

import 'configfile.dart';

class PheasantCliBaseConfig {
  String projName;
  String projVersion;
  final PheasantEnvironment _environment;
  Map<String, String> entrypoints;
  Map<String, bool> generalConfigs;
  Iterable<PheasantPlugin> plugins;
  Iterable<PheasantDependencies> dependencies;
  PheasantConfigFile? configFile;

  PheasantCliBaseConfig(
      {this.projName = '',
      this.projVersion = '1.0.0',
      PheasantEnvironment environment = PheasantEnvironment.dart,
      this.entrypoints = const {'main': 'web/main.dart', 'app': 'lib/App.phs'},
      this.generalConfigs = const {
        'sass': false,
        'js': false,
        'linter': false,
        'formatter': false,
        'phsComponents': false,
      },
      this.plugins = const [],
      this.dependencies = const []})
      : _environment = environment;

  PheasantCliBaseConfig.fromJson(String jsonData, {Config? configOverrides})
      : configFile = PheasantConfigFile.json,
        projName = jsonDecode(jsonData)['project'],
        projVersion = jsonDecode(jsonData)['version'],
        _environment = jsonDecode(jsonData)['env'] == 'dart'
            ? PheasantEnvironment.dart
            : PheasantEnvironment.node,
        entrypoints = jsonDecode(jsonData)['entry'],
        generalConfigs = jsonDecode(jsonData)['config'],
        plugins = (jsonDecode(jsonData)['plugins'] as List)
            .map((e) => PheasantPlugin.fromMap(e)),
        dependencies = (jsonDecode(jsonData)['dependencies'] as List)
            .map((e) => PheasantDependencies.fromMap(e)) {
    if (configOverrides != null) {
      projName = configOverrides.optionalString('project') ?? projName;
      projVersion = configOverrides.optionalString('version') ?? projVersion;
      plugins = (configOverrides.valueOf('plugins') as List?)
              ?.map((e) => PheasantPlugin.fromMap(e)) ??
          plugins;
      dependencies = (configOverrides.valueOf('dependencies') as List?)
              ?.map((e) => PheasantDependencies.fromMap(e)) ??
          dependencies;
    }
  }

  PheasantCliBaseConfig.fromYaml(String yamlData, {Config? configOverrides})
      : configFile = PheasantConfigFile.yaml,
        projName = loadYaml(yamlData)['project'],
        projVersion = loadYaml(yamlData)['version'],
        _environment = loadYaml(yamlData)['env'] == 'dart'
            ? PheasantEnvironment.dart
            : PheasantEnvironment.node,
        entrypoints = (loadYaml(yamlData)['entry'] as YamlMap)
            .value
            .cast<String, String>(),
        generalConfigs = (loadYaml(yamlData)['config'] as YamlMap)
            .value
            .cast<String, bool>(),
        plugins = (loadYaml(yamlData)['plugins'] as List)
            .map((e) => PheasantPlugin.fromMap(e)),
        dependencies = (loadYaml(yamlData)['dependencies'] as List)
            .map((e) => PheasantDependencies.fromMap(e)) {
    if (configOverrides != null) {
      projName = configOverrides.optionalString('project') ?? projName;
      projVersion = configOverrides.optionalString('version') ?? projVersion;
      plugins = (configOverrides.valueOf('plugins') as List?)
              ?.map((e) => PheasantPlugin.fromMap(e)) ??
          plugins;
      dependencies = (configOverrides.valueOf('dependencies') as List?)
              ?.map((e) => PheasantDependencies.fromMap(e)) ??
          dependencies;
    }
  }

  PheasantEnvironment get environment => _environment;
}

class PheasantDependencies {
  String name;
  String version;

  PheasantDependencies({required this.name, this.version = '1.0.0'});

  PheasantDependencies.fromJson(String jsonData)
      : name = (jsonDecode(jsonData) as Map).keys.first,
        version = (jsonDecode(jsonData) as Map).values.first['version'];

  PheasantDependencies.fromMap(Map<String, dynamic> mapData)
      : name = mapData.keys.first,
        version = mapData.values.first['version'];
}

class PheasantPlugin {
  String name;
  String version;

  PheasantPlugin({required this.name, this.version = '1.0.0'});

  PheasantPlugin.fromJson(String jsonData)
      : name = (jsonDecode(jsonData) as Map).keys.first,
        version = (jsonDecode(jsonData) as Map).values.first['version'];

  PheasantPlugin.fromMap(Map<String, dynamic> mapData)
      : name = mapData.keys.first,
        version = mapData.values.first['version'];
}

class PheasantCliDartConfig extends PheasantCliBaseConfig {
  @override
  PheasantEnvironment get _environment => PheasantEnvironment.dart;
}

class PheasantCliNodeConfig extends PheasantCliBaseConfig {
  @override
  PheasantEnvironment get _environment => PheasantEnvironment.node;

  PheasantCliNodeConfig(
      {super.projName = '',
      super.projVersion = '1.0.0',
      super.entrypoints = const {'main': 'web/main.dart', 'app': 'lib/App.phs'},
      super.generalConfigs = const {
        'cssPreprocessor': false,
        'js': false,
        'ts': false,
        'linter': false,
        'formatter': false,
        'phsComponents': false,
      },
      super.plugins = const [],
      super.dependencies = const []});
}

enum PheasantEnvironment { dart, node }

typedef AppConfig = PheasantCliBaseConfig;
