import 'dart:convert';
import 'dart:io';

import 'package:cli_config/cli_config.dart';
import 'package:yaml/yaml.dart';

import 'configfile.dart';

class PheasantCliBaseConfig {
  String projName;
  String projVersion;
  final PheasantEnvironment _environment;
  Map<String, String>? entrypoints;
  Map<String, bool> generalConfigs;
  List<PheasantPlugin> plugins;
  List<PheasantDevPlugin> devPlugins;
  List<PheasantDependencies> dependencies;
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
      this.devPlugins = const [],
      this.dependencies = const []})
      : _environment = environment;

  PheasantCliBaseConfig.fromJson(String jsonData, {Config? configOverrides})
      : configFile = PheasantConfigFile.json,
        projName = jsonDecode(jsonData)['project'],
        projVersion = jsonDecode(jsonData)['version'],
        _environment = PheasantEnvironment.dart,
        entrypoints = jsonDecode(jsonData)['entry'],
        generalConfigs = jsonDecode(jsonData)['config'],
        plugins = (jsonDecode(jsonData)['plugins']['main'] as List)
            .map((e) => PheasantPlugin.fromMap(e))
            .toList(),
        devPlugins = (jsonDecode(jsonData)['plugins']['dev'] as List)
            .map((e) => PheasantDevPlugin.fromMap(e))
            .toList(),
        dependencies = (jsonDecode(jsonData)['dependencies'] as List)
            .map((e) => PheasantDependencies.fromMap(e))
            .toList() {
    if (configOverrides != null) {
      projName = configOverrides.optionalString('project') ?? projName;
      projVersion = configOverrides.optionalString('version') ?? projVersion;
      plugins = (configOverrides.valueOf('plugins.main') as List?)
              ?.map((e) => PheasantPlugin.fromMap(e))
              .toList() ??
          plugins;
      devPlugins = (configOverrides.valueOf('plugins.dev') as List?)
              ?.map((e) => PheasantDevPlugin.fromMap(e))
              .toList() ??
          devPlugins;
      dependencies = (configOverrides.valueOf('dependencies') as List?)
              ?.map((e) => PheasantDependencies.fromMap(e))
              .toList() ??
          dependencies;
    }
  }

  PheasantCliBaseConfig.fromYaml(String yamlData, {Config? configOverrides})
      : configFile = PheasantConfigFile.yaml,
        projName = loadYaml(yamlData)['project'],
        projVersion = loadYaml(yamlData)['version'],
        _environment = PheasantEnvironment.dart,
        entrypoints = (loadYaml(yamlData)['entry'] as YamlMap?)
            ?.value
            .cast<String, String>(),
        generalConfigs = (loadYaml(yamlData)['config'] as YamlMap)
            .value
            .cast<String, bool>(),
        plugins = (loadYaml(yamlData)['plugins']['main'] as List)
            .map((e) => PheasantPlugin.fromMap(
                (e as YamlMap).value.cast<String, dynamic>()))
            .toList(),
        devPlugins = (loadYaml(yamlData)['plugins']['dev'] as List)
            .map((e) => PheasantDevPlugin.fromMap(
                (e as YamlMap).value.cast<String, dynamic>()))
            .toList(),
        dependencies = (loadYaml(yamlData)['dependencies'] as List)
            .map((e) => PheasantDependencies.fromMap(
                (e as YamlMap).value.cast<String, dynamic>()))
            .toList() {
    if (configOverrides != null) {
      projName = configOverrides.optionalString('project') ?? projName;
      projVersion = configOverrides.optionalString('version') ?? projVersion;
      plugins = (configOverrides.valueOf('plugins.main') as List?)
              ?.map((e) => PheasantPlugin.fromMap(
                  e is YamlMap ? e.value.cast<String, dynamic>() : e))
              .toList() ??
          plugins;
      devPlugins = (configOverrides.valueOf('plugins.dev') as List?)
              ?.map((e) => PheasantDevPlugin.fromMap(
                  e is YamlMap ? e.value.cast<String, dynamic>() : e))
              .toList() ??
          devPlugins;
      dependencies = (configOverrides.valueOf('dependencies') as List?)
              ?.map((e) => PheasantDependencies.fromMap(
                  e is YamlMap ? e.value.cast<String, dynamic>() : e))
              .toList() ??
          dependencies;
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> outmap = {
      'project': projName,
      'version': projVersion,
      'env': _environment.toString().split('.').last,
    };
    if (entrypoints != null) {
      outmap.addAll({
        'entry': {'main': entrypoints?['main'], 'app': entrypoints?['app']}
      });
    }
    outmap.addAll({
      'config': {
        'sass': generalConfigs['sass'],
        'js': generalConfigs['js'],
        'linter': generalConfigs['linter'],
        'formatter': generalConfigs['formatter'],
        'phsComponents': generalConfigs['phsComponents']
      },
      'plugins': {
        'main': plugins.map((e) {
          Map<String, dynamic> plugmap = {
            e.name: {'version': e.version}
          };
          if (e.source != null) plugmap[e.name].addAll({'source': e.source!});
          if (e.sourcesupp != null && e.sourcesuppName != null)
            plugmap[e.name].addAll({e.sourcesuppName!: e.sourcesupp!});
          return plugmap;
        }).toList(),
        'dev': devPlugins.map((e) {
          Map<String, dynamic> plugmap = {
            e.name: {'version': e.version}
          };
          if (e.source != null) plugmap[e.name].addAll({'source': e.source!});
          if (e.sourcesupp != null && e.sourcesuppName != null)
            plugmap[e.name].addAll({e.sourcesuppName!: e.sourcesupp!});
          return plugmap;
        }).toList()
      },
      'dependencies': []
    });
    return outmap;
  }

  @override
  String toString() {
    return toMap().toString();
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
  String? source;
  String? sourcesupp;

  /// The supported name for [sourcesupp]:
  ///
  ///
  String? sourcesuppName;

  PheasantPlugin(
      {required this.name,
      this.version = '1.0.0',
      this.source,
      this.sourcesupp,
      this.sourcesuppName}) {
    if (source != null && sourcesupp == null || sourcesupp == '') {
      stderr.write(
          "Both 'source' and supporting path/link must be provided for plugin: $name");
      exit(1);
    }
  }

  PheasantPlugin.fromJson(String jsonData)
      : name = (jsonDecode(jsonData) as Map).keys.first,
        version = (jsonDecode(jsonData) as Map).values.first['version'],
        source = (jsonDecode(jsonData) as Map).values.first['source'],
        sourcesupp = (jsonDecode(jsonData) as Map).values.first.values.last,
        sourcesuppName = (jsonDecode(jsonData) as Map).values.first.keys.last;

  PheasantPlugin.fromMap(Map<String, dynamic> mapData)
      : name = mapData.keys.first,
        version = mapData.values.first['version'],
        source = mapData.values.first['source'],
        sourcesupp = mapData.values.first.values.last,
        sourcesuppName = mapData.values.first.keys.last;

  String get supptype {
    if (source == 'path') return 'path';
    if (source == 'git') return 'git';
    if (source == 'hosted') return 'hosted';
    return 'unknown';
  }

  @override
  String toString() {
    return "Plugin: $name v$version${source == null ? "" : " -- $supptype: $sourcesupp"}";
  }
}

class PheasantDevPlugin extends PheasantPlugin {
  PheasantDevPlugin(
      {required super.name,
      super.version = '1.0.0',
      super.source,
      super.sourcesupp,
      super.sourcesuppName})
      : super();
  PheasantDevPlugin.fromJson(super.jsonData) : super.fromJson();
  PheasantDevPlugin.fromMap(super.mapData) : super.fromMap();
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
