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
