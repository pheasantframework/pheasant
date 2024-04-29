// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
import 'package:analyzer/dart/ast/ast.dart'
    show CompilationUnit, FunctionDeclaration;

/// Function used for extracting function info from a [CompilationUnit] and then return a List of [FunctionDeclaration] containing these declarations.
List<FunctionDeclaration> extractFunctions(CompilationUnit unit) {
  final functions = <FunctionDeclaration>[];

  for (var declaration in unit.declarations) {
    if (declaration is FunctionDeclaration) {
      functions.add(declaration);
    }
  }

  return functions;
}
