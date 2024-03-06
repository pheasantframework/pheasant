// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:io/ansi.dart';
import 'package:pheasant_cli/src/config/config.dart';
import 'package:yaml_edit/yaml_edit.dart';

Future<void> writeConfigToFile(AppConfig appConfig) async {
  Map<String, dynamic> yamlMap = appConfig.toMap();
  final yamlEditor = YamlEditor('');
  yamlEditor.update([], yamlMap);
  bool exist = File('./pheasant.yaml').existsSync();
  if (!exist) {
    stderr.writeln(red.wrap("\nError: ${wrapWith("The 'pheasant.yaml' file doesn't exist", [white, styleBold])}"));
    exit(2);
  }
  await File('./pheasant.yaml').writeAsString(yamlEditor.toString());
}
