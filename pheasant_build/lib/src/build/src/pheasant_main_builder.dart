// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'dart:async' show FutureOr;
import 'package:build/build.dart' show AssetId, BuildStep, Builder;
import 'package:pheasant_temp/pheasant_temp.dart' show renderMain;

/// Builder Class used in building the `main.phs.dart` file, used as a bridge between the main entrypoint (`web/main.dart` for instance), and the compiled Pheasant Files (`App.phs.dart` for instance).
class PheasantMainBuilder extends Builder {
  String fileExtension;
  String appName;
  String mainEntry;
  String? entrypoint;

  PheasantMainBuilder({
    this.fileExtension = '.phs.dart',
    this.appName = 'AppComponent',
    this.mainEntry = 'App.phs',
    this.entrypoint,
  });

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await buildStep.writeAsString(
        AssetId(
            buildStep.inputId.package, entrypoint ?? 'lib/main$fileExtension'),
        renderMain(
            appName: appName,
            fileExtension: fileExtension,
            mainEntry: mainEntry));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$package$': [entrypoint ?? 'lib/main$fileExtension']
      };
}
