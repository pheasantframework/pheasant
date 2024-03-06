// ignore_for_file: constant_identifier_names

import 'package:pheasant_cli/src/config/config.dart';

void addPlugins(Iterable<List<String>> items, String? gitUrl, AppConfig appConfig, String? pathUrl, String? hostUrl) {
  items.forEach((element) {
    bool devPlugin;
    String version;
    String name;
    if (element.contains('dev')) {
      devPlugin = true;
      name = element[1];
    } else {
      devPlugin = false;
      name = element[0];
    }
    if (element.where((el) => el.contains('.')).isNotEmpty) {
      version = element.last;
    } else {
      version = 'latest';
    }
    _addPlugins(gitUrl, devPlugin, appConfig, name, version, pathUrl, hostUrl);
  });
}

void _addPlugins(String? gitUrl, bool devPlugin, AppConfig appConfig, String name, String version, String? pathUrl, String? hostUrl) {
  if (gitUrl != null) {
    (devPlugin ? appConfig.devPlugins : appConfig.plugins).add(
      devPlugin ? PheasantDevPlugin(
        name: name,
        version: version,
        source: 'git',
        sourcesupp: gitUrl,
        sourcesuppName: 'url'
      ) : PheasantPlugin(
        name: name,
        version: version,
        source: 'git',
        sourcesupp: gitUrl,
        sourcesuppName: 'url'
      )
    );
  } else if (pathUrl != null) {
    (devPlugin ? appConfig.devPlugins : appConfig.plugins).add(
      devPlugin ? PheasantDevPlugin(
        name: name,
        version: version,
        source: 'path',
        sourcesupp: pathUrl,
        sourcesuppName: 'path'
      ) : PheasantPlugin(
        name: name,
        version: version,
        source: 'path',
        sourcesupp: gitUrl,
        sourcesuppName: 'path'
      )
    );
  } else if (hostUrl != null) {
    (devPlugin ? appConfig.devPlugins : appConfig.plugins).add(
      devPlugin ? PheasantDevPlugin(
        name: name,
        version: version,
        source: 'hosted',
        sourcesupp: hostUrl,
        sourcesuppName: 'url'
      ) : PheasantPlugin(
        name: name,
        version: version,
        source: 'hosted',
        sourcesupp: hostUrl,
        sourcesuppName: 'url'
      )
    );
  } else {
    (devPlugin ? appConfig.devPlugins : appConfig.plugins).add(
      devPlugin ? PheasantDevPlugin(
        name: name,
        version: version,
      ) : PheasantPlugin(
        name: name,
        version: version,
      )
    );
  }
}