// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
import 'package:analyzer/dart/ast/ast.dart'
    show Annotation, VariableDeclaration;

/// The class used as an encapsulated extension for [VariableDeclaration]
///
/// The main difference here is just the presence of the [dataType] variable, a [String] that represents the variable data type.
class VariableDefinition {
  VariableDeclaration declaration;
  String dataType;
  List<Annotation> annotations;

  VariableDefinition(
      {required this.declaration,
      required this.dataType,
      this.annotations = const []});

  @override
  String toString() => "$dataType $declaration";
}
