// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
import 'package:analyzer/dart/ast/ast.dart'
    show CompilationUnit, VariableDeclaration, VariableDeclarationList;
import 'package:analyzer/dart/ast/visitor.dart' show RecursiveAstVisitor;
import 'variable_info.dart';

/// Visitor used to get variables from a [CompilationUnit]
///
/// The difference between this and a normal Variable Visitor, is the use of the class [VariableDefinition] rather than [VariableDeclaration]
class VariableExtractorVisitor extends RecursiveAstVisitor<void> {
  List<VariableDefinition> variableList = [];

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);
    try {
      variableList.add(VariableDefinition(
          declaration: node,
          dataType: (node.parent as VariableDeclarationList).type?.toSource() ??
              'dynamic'));
    } catch (e) {
      // Do not include
    }
  }
}
