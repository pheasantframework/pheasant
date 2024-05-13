// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org


import 'package:analyzer/dart/ast/ast.dart';
import 'package:pheasant_temp/src/builder/analyze/variables/variable_info.dart';

/// Class used to encapsulate the result of complete parsing of a script source file.
class PheasantExtractorResult {
  final List<VariableDefinition> variables;
  final List<FunctionDeclaration> functions;
  final List<ImportDirective> imports;
  final List<EnumDeclaration> enums;

  PheasantExtractorResult(
      this.variables, this.functions, this.imports, this.enums);
}
