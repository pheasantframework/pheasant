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
