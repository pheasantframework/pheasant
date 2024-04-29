// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

final RegExp regex = RegExp(r"RouteTo\('([^']+)'");

/// Builder Class used in generating support files for routing in a pheasant application
class PheasantRouterBuilder extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;
    var data = await buildStep.readAsString(inputId);
    final outputId = inputId.changeExtension('.routes.dart');
    final content = LineSplitter().convert(data);
    var importLine =
        "import '${buildStep.inputId.pathSegments.last.replaceAll('.dart', '.routes.dart')}'";
    final partDir = content.firstWhere(
      (element) => element.contains(importLine),
      orElse: () => "",
    );
    if (partDir == "") {
      // await buildStep.writeAsString(outputId, "");
      return;
    }

    var matchable = content.where((element) {
      return regex.hasMatch(element);
    });
    final paths = matchable
        .map((e) {
          Iterable<Match> matches = regex.allMatches(e);
          return matches.map((m) => m[1]).join(',');
        })
        .join(',')
        .split(',');
    if (paths.isEmpty ||
        paths
            .map((e) => e.trim())
            .where((t) => t.isNotEmpty && t.length >= 3 && t != 'null')
            .isEmpty) {
      // await buildStep.writeAsString(outputId, "");
      return;
    }

    var sourceOut = '''
    import 'package:pheasant/build.dart';
    ${paths.map((e) {
      return 'import "package:${inputId.package}/${e.replaceAll('.phs', '.phs.dart')}" as _i${paths.indexOf(e)};\n';
    }).join('\n')}

    PheasantTemplate RouteTo(String path) {
      switch (path) {
        ${paths.map((e) {
      return """
case "$e":
          return _i${paths.indexOf(e)}.${p.basenameWithoutExtension(e)}Component();
          """;
    }).join('\n')}
        default:
          return UnknownPheasantTemplate();
      }
    }
    ''';
    await buildStep.writeAsString(outputId, sourceOut);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.routes.dart']
      };
}
