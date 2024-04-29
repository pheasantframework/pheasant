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
