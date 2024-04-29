// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.   
// You may use this file only in accordance with the license.
// https://mit-license.org


import 'package:pheasant_meta/pheasant_meta.dart';
import 'package:test/test.dart';

void main() {
  group("Tests for metadata used in packages", () {
    test('Constant Metadata Tests', () => null);
    test('Class Metadata Tests', () {
      final fromObject = From('1.0.0');
      expect(fromObject.info,
          equals("This functionality takes effect from the given version."));
    });
  });
  group("Tests for metadata used in build files", () {
    test('"prop" Metadata', () {
      final testprop = prop;

      expect(testprop.defaultTo, isNull);
      expect(testprop.optional, isFalse);
    });

    test('"Prop" Metadata', () {
      final testprop = Prop(defaultTo: 8, optional: true);

      expect(testprop.defaultTo, isNotNull);
      assert(testprop.defaultTo is int);
      assert(testprop.defaultTo == 8);

      expect(testprop.optional, isTrue);
    });
  });
}
