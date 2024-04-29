import 'package:analyzer/dart/ast/ast.dart';

/// Function used to get enum declarations from a [CompilationUnit]
List<EnumDeclaration> getEnums(CompilationUnit unit) {
  final enumerations = <EnumDeclaration>[];

  for (var declaration in unit.declarations) {
    if (declaration is EnumDeclaration) {
      enumerations.add(declaration);
    }
  }

  return enumerations;
}
