// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:pheasant_cli/src/config/config.dart';

AppConfig addPlugins(Iterable<List<String>> items, String? gitUrl,
    AppConfig appConfig, String? pathUrl, String? hostUrl) {
  AppConfig newConfig = appConfig;
  for (var element in items) {
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
    if (devPlugin) {
      if (newConfig.devPlugins.where((el) => el.name == name).isNotEmpty) {
        stdout.writeln("Plugin $name Already Exists. Updating...");
        var plugin = newConfig.devPlugins.singleWhere((el) => el.name == name);
        newConfig.devPlugins[newConfig.devPlugins.indexOf(plugin)] = plugin
          ..version = version
          ..source = _getSource(gitUrl, pathUrl, hostUrl)
          ..sourcesupp = _getUrl(gitUrl, pathUrl, hostUrl)
          ..sourcesuppName = _getName(_getSource(gitUrl, pathUrl, hostUrl));
        break;
      }
    } else {
      if (newConfig.plugins.where((el) => el.name == name).isNotEmpty) {
        stdout.writeln("Plugin $name Already Exists. Updating...");
        var plugin = newConfig.plugins.singleWhere((el) => el.name == name);
        newConfig.plugins[newConfig.plugins.indexOf(plugin)] = plugin
          ..version = version
          ..source = _getSource(gitUrl, pathUrl, hostUrl)
          ..sourcesupp = _getUrl(gitUrl, pathUrl, hostUrl)
          ..sourcesuppName = _getName(_getSource(gitUrl, pathUrl, hostUrl));
        break;
      }
    }
    newConfig = _addPlugins(
        gitUrl, devPlugin, appConfig, name, version, pathUrl, hostUrl);
  }
  return newConfig;
}

String? _getName(String? getSource) {
  if (getSource == 'git' || getSource == 'hosted') {
    return 'url';
  } else if (getSource == 'path')
    return 'path';
  else
    return null;
}

String? _getUrl(String? gitUrl, String? pathUrl, String? hostUrl) {
  return gitUrl ?? pathUrl ?? hostUrl;
}

String? _getSource(String? gitUrl, String? pathUrl, String? hostUrl) {
  if (gitUrl != null) {
    return 'git';
  } else if (pathUrl != null)
    return 'path';
  else if (hostUrl != null)
    return 'hosted';
  else
    return null;
}

AppConfig _addPlugins(String? gitUrl, bool devPlugin, AppConfig appConfig,
    String name, String version, String? pathUrl, String? hostUrl) {
  AppConfig newConfig = appConfig;
  if (gitUrl != null) {
    devPlugin
        ? newConfig.devPlugins.add(PheasantDevPlugin(
            name: name,
            version: version,
            source: 'git',
            sourcesupp: gitUrl,
            sourcesuppName: 'url'))
        : newConfig.plugins.add(PheasantPlugin(
            name: name,
            version: version,
            source: 'git',
            sourcesupp: gitUrl,
            sourcesuppName: 'url'));
  } else if (pathUrl != null) {
    devPlugin
        ? newConfig.devPlugins.add(PheasantDevPlugin(
            name: name,
            version: version,
            source: 'path',
            sourcesupp: pathUrl,
            sourcesuppName: 'path'))
        : newConfig.plugins.add(PheasantPlugin(
            name: name,
            version: version,
            source: 'path',
            sourcesupp: gitUrl,
            sourcesuppName: 'path'));
  } else if (hostUrl != null) {
    devPlugin
        ? newConfig.devPlugins.add(PheasantDevPlugin(
            name: name,
            version: version,
            source: 'hosted',
            sourcesupp: hostUrl,
            sourcesuppName: 'url'))
        : newConfig.plugins.add(PheasantPlugin(
            name: name,
            version: version,
            source: 'hosted',
            sourcesupp: hostUrl,
            sourcesuppName: 'url'));
  } else {
    devPlugin
        ? newConfig.devPlugins.add(PheasantDevPlugin(
            name: name,
            version: version,
          ))
        : newConfig.plugins.add(PheasantPlugin(
            name: name,
            version: version,
          ));
  }
  return newConfig;
}
