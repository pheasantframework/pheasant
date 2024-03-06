import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:pheasant_cli/src/config/config.dart';

Future<String> _getPluginNames(
    PheasantPlugin element, List<dynamic> errors) async {
  String name = element.name;
  if (element is PheasantDevPlugin) {
    name = 'dev:$name';
  }
  if (element.source == null) {
    if (element.version == 'latest') {
    } else if (element.version == 'any') {
      name = '$name:any';
    } else {
      name = '$name:${element.version}';
    }
  } else {
    // String src = element.source!;
    if (element.supptype == 'path') {
      name = '\'$name:{"path":"${element.sourcesupp}"}\'';
    } else if (element.supptype == 'git' || element.supptype == 'github') {
      name = '\'$name:{"git":"${element.sourcesupp}"}\'';
    } else if (element.supptype == 'hosted') {
      name = '\'$name:{"hosted":"${element.sourcesupp}"}\'';
    }
  }
  return name;
}

List<String> _getpluginstrings(AppConfig appConfig, List<dynamic> errors) {
  List<String> pluginStrings = [];
  appConfig.plugins.forEach((element) async {
    pluginStrings.add(await _getPluginNames(element, errors));
  });
  return pluginStrings;
}

Future<void> getPlugins(AppConfig appConfig, {Logger? logger}) async {
  final errors = [];
  final pluginstrings = _getpluginstrings(appConfig, errors);
  logger?.trace('Retrieving Plugins');
  if (pluginstrings.isNotEmpty) {
    final pubprocess = await Process.run(
        'dart', ['pub', 'add', ...pluginstrings],
        stderrEncoding: utf8, stdoutEncoding: utf8);
    if (pubprocess.stderr != null && pubprocess.stderr.toString().isNotEmpty) {
      errors.add(pubprocess.stderr);
    }
  }
  if (errors.isNotEmpty) {
    stderr.writeAll([
      wrapWith("Errors retrieving plugin packages: ", [red, styleBold]),
      ...errors.map((e) => styleBold.wrap(e))
    ], " ");
    exit(1);
  }
  logger?.trace('Plugins Gotten');
}
