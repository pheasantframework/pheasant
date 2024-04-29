// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

@Timeout(Duration(seconds: 1))

import 'dart:developer';

import 'package:pheasant_temp/pheasant_temp.dart';
import 'package:test/test.dart';

void main() {
  log('Pheasant Benchmark Tests for: renderMain');
  group('speed test', () {
    List<String> results = List<String>.filled(5, '');

    test('speed run', () {
      final Stopwatch stopwatch = Stopwatch()..start();

      results[0] = renderMain();
      log('Result 1: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[1] = renderMain(appName: "HomeComponent");
      log('Result 2: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[2] = renderMain(
          appName:
              "ThisIsAnExtremelyLongClassNameThatServesNoPracticalPurposeButIsUsedHereForDemonstrationPurposesComponent");
      log('Result 3: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[3] = renderMain(appName: "HomeComponent", mainEntry: "Home.phs");
      log('Result 4: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[4] = renderMain(
          appName:
              "ThisIsAnExtremelyLongClassNameThatServesNoPracticalPurposeButIsUsedHereForDemonstrationPurposesComponent",
          mainEntry:
              "ThisIsAnExtremelyLongClassNameThatServesNoPracticalPurposeButIsUsedHereForDemonstrationPurposes.phs");
      log('Result 5: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.stop();
    });
  });
}
