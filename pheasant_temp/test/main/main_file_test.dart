// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'package:pheasant_temp/pheasant_temp.dart' show renderMain;
import 'package:test/test.dart';

void main() {
  group('main file tests', () {
    String output = renderMain();

    test('import directives', () {
      expect(output, contains("import 'App.phs.dart';"));
      expect(output, contains("import 'package:pheasant/build.dart'"));
    });

    test('body of file', () {
      expect(output, contains('''_i1.PheasantTemplate get App {
  return AppComponent();
}'''));
    });
  });

  group('defined main file tests', () {
    String appName = "CoreComponent";
    String mainEntry = "Core.phs";

    String output = renderMain(appName: appName, mainEntry: mainEntry);

    test('import directives', () {
      expect(output, contains("import 'Core.phs.dart';"));
      expect(output, contains("import 'package:pheasant/build.dart'"));
    });

    test('body of file', () {
      expect(output, contains('''_i1.PheasantTemplate get App {
  return CoreComponent();
}'''));
    });
  });
}
