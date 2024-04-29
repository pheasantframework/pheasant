// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart' show parseString;
import '../../../exceptions/exceptions.dart';

ParseStringResult parseCode(String script) {
  final result = parseString(content: script);
  if (result.errors.isNotEmpty) {
    throw PheasantTemplateException(
      '''
Error Reading Script Component: Variable Error: ${result.errors.map((e) => e.problemMessage)} 
  Fix: ${result.errors.map((e) => e.correctionMessage)} 
  ''',
      exitCode: result.errors.map((e) => e.errorCode.numParameters).first,
    );
  }
  return result;
}
