import 'package:analyzer/dart/ast/ast.dart';

List<ImportDirective> getImports(CompilationUnit newUnit) {
  return newUnit.directives.whereType<ImportDirective>().toList();
}
