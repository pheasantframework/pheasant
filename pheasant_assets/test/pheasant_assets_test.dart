// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'package:pheasant_assets/pheasant_assets.dart';
import 'package:test/test.dart';

void main() {
  String a = '''<style></style>''';
  String b = '''<style>
/* Reset some default styles */
body, h1, p {
  margin: 0;
  padding: 0;
}

/* Set a background color for the body */
body {
  background-color: #f0f0f0;
  font-family: Arial, sans-serif;
}
</style>''';
  String c = '''<style syntax="scss" global>
@import url('https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;1,300&family=Roboto+Mono:wght@200&display=swap');

\$font: 'Lato';
\$monoFont: 'Roboto Mono';
\$primary-color: red;

.foo {
    color: rgb(245, 193, 66);
    align-content: flex-start;
    font-family: \$font, sans-serif;

    a {
        color: #d9d9d9;
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
</style>''';
  String d = '''<style src="src/main.css"></style>''';
  String e = '''<style src="src/main.scss" syntax="scss"></style>''';
  String f = '''<style src="src/styles.scss" syntax="scss" global></style>''';
  String g = '''<style src="src/styles.sass" syntax="sass"></style>''';
  group('Get Styles Test', () {
    test("test function", () {
      expect(() => getStyleInput(''), throwsException);
      expect(() => getStyleInput(''), throwsA(isA<PheasantStyleException>()));
      expect(() => getStyleInput('<style>'),
          throwsA(isA<PheasantStyleException>()));
      expect(() => getStyleInput('</style>'),
          throwsA(isA<PheasantStyleException>()));
    });

    group("sass enabled", () {
      PheasantStyle sA = getStyleInput(a);
      PheasantStyle sB = getStyleInput(b);
      PheasantStyle sC = getStyleInput(c);
      PheasantStyle sD = getStyleInput(d);
      PheasantStyle sE = getStyleInput(e);
      PheasantStyle sF = getStyleInput(f);
      PheasantStyle sG = getStyleInput(g);

      test("Extract Styles Local", () {
        expect(sA.src, isNull);
        expect(sA.syntax, equals('css'));
        expect(sA.scope, equals(StyleScope.local));
        expect(sA.data, isNull);

        expect(sB.src, isNull);
        expect(sB.data, isNotEmpty);
        expect(sB.scope, equals('css'));

        expect(sC.src, isNull);
        expect(sC.scope, equals(StyleScope.global));
        expect(sC.syntax, equals('scss'));
      });

      test("Extract Styles in Files", () {
        assert(sD.data == null &&
            sE.data == null &&
            sF.data == null &&
            sG.data == null);

        expect(sD.src, equals('src/main.css'));
        expect(sD.syntax, equals('css'));

        expect(sE.src, equals('src/main.scss'));
        expect(sE.syntax, equals('scss'));
        expect(sE.scope, equals(StyleScope.local));

        expect(sF.src, equals('src/styles.scss'));
        expect(sF.syntax, equals('scss'));
        expect(sF.scope, equals(StyleScope.global));

        expect(sG.src, equals('src/main.sass'));
        expect(sG.syntax, equals('sass'));
      });
    });

    group("sass disabled", () {
      PheasantStyle sA = getStyleInput(a, sassEnabled: false);
      PheasantStyle sB = getStyleInput(b, sassEnabled: false);
      PheasantStyle sC = getStyleInput(c, sassEnabled: false);

      test("Extract Styles in Files (sass disabled)", () {
        expect(sA.src, isNull);
        expect(sA.syntax, equals('css'));
        expect(sA.scope, equals(StyleScope.local));
        expect(sA.data, isNull);

        expect(sB.src, isNull);
        expect(sB.data, isNotEmpty);
        expect(sB.scope, equals('css'));

        expect(sC.src, isNull);
        expect(sC.scope, equals(StyleScope.global));
        expect(sC.syntax, equals('css'));
      });

      test("Extract Styles in Files (sass disabled)", () {});
    });
  });
}
