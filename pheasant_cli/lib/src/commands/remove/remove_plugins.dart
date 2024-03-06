// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:io/ansi.dart';
import 'package:pheasant_cli/src/config/config.dart';

void removePlugins(AppConfig appConfig, List<String> plugins) {
  if (appConfig.plugins.where((element) => plugins.contains(element.name)).isNotEmpty) {
    for (var el in plugins) {
      appConfig.plugins.removeWhere((element) => element.name == el);
    }
  } else if (appConfig.devPlugins.where((element) => plugins.contains(element.name)).isNotEmpty) {
    for (var el in plugins) {
      appConfig.devPlugins.removeWhere((element) => element.name == el);
    }
  } else {
    stderr.writeln(red.wrap("Error: ${wrapWith("The given plugin${plugins.length == 1 ? "" : "s"}: ${plugins.join(', ')}, ${plugins.length == 1 ? "does" : "do"} not exist", [white, styleBold])}"));
  }
}