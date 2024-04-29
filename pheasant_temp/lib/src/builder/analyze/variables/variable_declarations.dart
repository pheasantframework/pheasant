// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'package:analyzer/dart/ast/ast.dart';
import 'variable_extractor_visitor.dart';
import 'variable_info.dart';

List<VariableDefinition> getVariableDeclarations(CompilationUnit newUnit) {
  List<VariableDefinition> outputList = [];
  VariableExtractorVisitor visitor = VariableExtractorVisitor();

  for (var element in newUnit.declarations) {
    element.accept(visitor);
    outputList.addAll(
        visitor.variableList.map((e) => e..annotations = element.metadata));
    visitor = VariableExtractorVisitor();
  }
  return outputList
      .where((element) =>
          element.declaration.parent?.parent?.parent?.parent is! FunctionBody)
      .toList();
}
