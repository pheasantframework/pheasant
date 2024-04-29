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
