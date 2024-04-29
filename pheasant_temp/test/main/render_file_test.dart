// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'package:pheasant_assets/pheasant_assets.dart';
import 'package:pheasant_temp/pheasant_temp.dart';
import 'package:test/test.dart';

RegExp variableNameRegExp = RegExp(r'newChild\d{1}_\d{8,10}');
RegExp cssClassNameRegExp = RegExp(r'\.phs-\d{9}(?:\s+\S+)*');
RegExp styleVariableNameRegExp = RegExp(r'styleElement_\d{8,10}');

void main() {
  group('small case', () {
    String script = '''
import 'components/Component.phs' as Component;

int myInt = 5;
''';
    String template = '''
<div>
  <h1>Hello, and Welcome to the first Pheasant Test</h1>
  <h2>CASE I</h2>
  <div p-for="int i = 0; i < 2; ++i">
    <p>Test Subject</p>
    <a preventDefault>Test Link</a>
  </div>
  <h2>CASE II</h2>
  <md class="test">
# CASE TWO
This is the second component of this group, written in `markdown`.

Markdown is a language very similar to html, and it even allows html to be written in it. 

It also allows for code to be written in it
```dart
void main() {
  print("Hello World")
}
```
  </md>
  <Component />
</div>
''';
    String style = '''
  .test {
    color: gold;
  }
''';

    PheasantStyle testStyle = PheasantStyle(data: style);
    test('prerequisite functions', () {
      assert(testStyle.src == null);

      PheasantScript testScript = PheasantScript(
          varDef: extractVariable(script),
          funDef: extractFunction(script),
          impDef: extractImports(script));

      expect(testScript.fields.length, equals(1));
      expect(testScript.imports.length, equals(1));
      expect(testScript.methods, isEmpty);
    });

    String output = compilePhs(
        script: script,
        template: template,
        pheasantStyle: testStyle,
        sass: false);

    test('main body', () {
      expect(output, contains("import 'dart:html'"));
      expect(output, contains("import 'package:pheasant/build.dart'"));
      expect(output,
          contains("import 'components/Component.phs.dart' as Component;"));

      expect(output, contains('int myInt = 5;'));
      expect(output, contains('AppComponent({super.template});'));
      expect(output, contains('''@override
  _i2.Element render(
    String temp, [
    _i1.TemplateState? state,
  ])'''));
    });

    test('render function', () {
      assert(RegExp(r'_i2.Element ' +
              variableNameRegExp.pattern +
              r" = _i2\.Element\.tag\(\'div\'\)")
          .hasMatch(output));
      assert(RegExp(variableNameRegExp.pattern +
              r'\.append\(_i2\.Text\(\"\"\"\n\"\"\"\)\)')
          .hasMatch(output));
      assert(RegExp(r'_i2.Element ' +
              variableNameRegExp.pattern +
              r" = _i2\.Element\.tag\(\'h1\'\)")
          .allMatches(output)
          .isNotEmpty);
      assert(RegExp(r'_i2.Element ' +
                  variableNameRegExp.pattern +
                  r" = _i2\.Element\.tag\(\'h2\'\)")
              .allMatches(output)
              .length >=
          2);
      assert(RegExp(r'_i2.Element ' +
                  variableNameRegExp.pattern +
                  r" = _i2\.Element\.tag\(\'div\'\)")
              .allMatches(output)
              .length >=
          2);
      assert(RegExp(r'_i2.Element ' +
                  variableNameRegExp.pattern +
                  r" = _i2\.Element\.tag\(\'a\'\)")
              .allMatches(output)
              .length >=
          2);
      expect(output, contains('for (int i = 0; i < 2; ++i) {'));
      assert(RegExp(r'\<code\>markdown\<\/code\>').hasMatch(output));
      assert(RegExp(r'_i2.StyleElement ' +
              styleVariableNameRegExp.pattern +
              r" = _i2\.StyleElement\(\)")
          .hasMatch(output));
      assert(RegExp(styleVariableNameRegExp.pattern).hasMatch(output));
      assert(RegExp(variableNameRegExp.pattern +
              r'component = Component\.ComponentComponent\(\)')
          .hasMatch(output));
      assert(RegExp(r'_i2.Element ' +
              variableNameRegExp.pattern +
              r' = ' +
              variableNameRegExp.pattern +
              r'component')
          .hasMatch(output));
    });
  });

  group('larger case', () {
    String script = '''
import 'src/Body.phs' as Body;
import 'src/Header.phs' as Header;
import 'src/Footer.phs' as Footer;
import 'src/folder/Component.phs' as Component;

@prop
int count;

@Prop(defaultTo: "none specified", optional: true)
String userFruit;

@JS('window.alert')
external void alert(String message);

List<String> fruits = ['coconut', 'apple', 'mango', 'orange'];

bool isKnownFruit(String fruit) {
  return fruits.contain(fruit);
}
''';
    String template = '''
<div>
  <Header>
    <h1>Hello, and Welcome to the Second Pheasant Test</h1>
    <div p-if="count % 2 == 0" class="test">
      <p>Count is odd</p>
    </div>
  </Header>
  <Body class="test">
    <input @userFruit>
    <button p-on:click="if (isKnownFruit(userFruit)) alert('Known Fruit');">
      Click This Button
    </button>
    <Component />
    <button p-on:click="freezeState">
      Once clicked nothing should work
    </button>
    <button p-on:click="unfreezeState" preventDefault>
      Once clicked all should start working
    </button>
    <button p-on:click="reloadState" preventDefault>
      Reload Page
    </button>
  </Body>
</div>
''';
    String style = '''
\$font: 'Lato';
\$monoFont: 'Roboto Mono';
\$primary-color: red;

.test {
  color: rgb(245, 193, 66);
  align-content: flex-start;
  font-family: \$font, sans-serif;

  button {
      color: silver;
      font-style: italic;
      font-weight: 300;
  }

  p {
      font-weight: 100;
  }

  code {
      font-family: \$monoFont, monospace;
  }
}
''';

    PheasantStyle testStyle =
        PheasantStyle.sassEnabled(data: style, syntax: 'scss');
    test('prerequisite functions', () {
      assert(testStyle.src == null);
      assert(testStyle.syntax == 'scss');

      PheasantScript testScript = PheasantScript(
          varDef: extractVariable(script),
          funDef: extractFunction(script),
          impDef: extractImports(script));

      expect(testScript.fields.length, equals(3));
      expect(testScript.imports.length, equals(4));
      expect(testScript.nonjsMethods.length, equals(1));
      expect(testScript.jsMethods.length, equals(1));
      expect(testScript.props.length, equals(2));
    });

    String output = compilePhs(
        script: script,
        template: template,
        pheasantStyle: testStyle,
        sass: true);

    test('main body', () {
      expect(output, contains("import 'dart:html'"));
      expect(output, contains("import 'package:pheasant/build.dart'"));
      expect(output,
          contains("import 'src/folder/Component.phs.dart' as Component;"));
      expect(output, contains("import 'src/Body.phs.dart' as Body;"));
      expect(output, contains("import 'src/Footer.phs.dart' as Footer;"));
      expect(output, contains("import 'src/Header.phs.dart' as Header;"));

      expect(output, contains('@_i1.prop\n  int count;'));
      expect(output, contains('''  AppComponent({
    super.template,
    required this.count,
    this.userFruit = "none specified",
  });
'''));
      expect(output, contains('''@override
  _i2.Element render(
    String temp, [
    _i1.TemplateState? state,
  ])'''));
    });

    test('render function', () {
      assert(RegExp(r'_i2.Element ' +
              variableNameRegExp.pattern +
              r" = _i2\.Element\.tag\(\'div\'\)")
          .hasMatch(output));
      assert(RegExp(variableNameRegExp.pattern +
              r'\.append\(_i2\.Text\(\"\"\"\n\"\"\"\)\)')
          .hasMatch(output));
      assert(RegExp(r'_i2.Element ' +
              variableNameRegExp.pattern +
              r" = _i2\.Element\.tag\(\'h1\'\)")
          .allMatches(output)
          .isNotEmpty);
      assert(RegExp(r'_i2.Element ' +
              variableNameRegExp.pattern +
              r" = _i2\.Element\.tag\(\'input\'\)")
          .allMatches(output)
          .isNotEmpty);
      assert(RegExp(r'_i2.Element ' +
                  variableNameRegExp.pattern +
                  r" = _i2\.Element\.tag\(\'button\'\)")
              .allMatches(output)
              .length >=
          4);
      assert(
          RegExp(variableNameRegExp.pattern + r'\.on\w+\.listen\(\(event\) \{')
                  .allMatches(output)
                  .length >=
              4);
      assert(RegExp(variableNameRegExp.pattern +
                  r'\.onClick\.listen\(\(event\) \{')
              .allMatches(output)
              .length >=
          4);
      assert(RegExp(r'_i2.StyleElement ' +
              styleVariableNameRegExp.pattern +
              r" = _i2\.StyleElement\(\)")
          .hasMatch(output));
      assert(RegExp(styleVariableNameRegExp.pattern).hasMatch(output));
      expect(output, contains('if (count % 2 == 0) {'));
      expect(output, contains('event.preventDefault();'));
      expect(output, contains('state?.freeze()'));
      expect(output, contains('state?.unfreeze()'));
      expect(output, contains('state?.reload()'));
      expect(output, contains('''
      if (!(state?.onPause ?? false)) {
        if (isKnownFruit(userFruit)) alert('Known Fruit');
        ;
        state?.emit(event, templateState: this);
      }
'''));
      assert(RegExp(variableNameRegExp.pattern +
              r'component = Component\.ComponentComponent\(\)')
          .hasMatch(output));
      assert(RegExp(variableNameRegExp.pattern +
              r'component = Body\.BodyComponent\(\)')
          .hasMatch(output));
      assert(RegExp(variableNameRegExp.pattern +
              r'component = Header\.HeaderComponent\(\)')
          .hasMatch(output));
      assert(RegExp(r'_i2.Element ' +
              variableNameRegExp.pattern +
              r' = ' +
              variableNameRegExp.pattern +
              r'component')
          .hasMatch(output));
    });
  });
}
