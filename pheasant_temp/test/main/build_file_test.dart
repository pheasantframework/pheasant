// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

@TestOn('browser')
@Tags(['browser'])

import 'package:test/test.dart';
import 'package:pheasant_temp/pheasant_build.dart';

import 'dart:html';

class TestComponent extends PheasantTemplate {
  TestComponent({super.template});

  @override
  String? template = '''
<div>
  <p>Hello</p>
  <p>Welcome to Pheasant Template Tests</p>
</div>
''';

  @override
  Element render(String temp, [TemplateState? state]) {
    return DivElement()
      ..children = [
        ParagraphElement()..text = "Hello",
        ParagraphElement()..text = "Welcome to Pheasant Template Test"
      ];
  }
}

void main() {
  group('html group tests', () {
    var testComponent = TestComponent();
    test('html test', () {
      assert(testComponent.template != null);

      querySelector('#input')
          ?.children
          .add(testComponent.render(testComponent.template!));

      expect(document.body?.children, isNotEmpty);
      expect(querySelector('#input')?.children, isNotEmpty);

      expect(
          querySelector('#input')?.innerHtml, contains(testComponent.template));
    });
  });
}
