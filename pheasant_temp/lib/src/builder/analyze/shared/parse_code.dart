import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart' show parseString;
import '../../../exceptions/exceptions.dart';

ParseStringResult parseCode(String script) {
  final result = parseString(content: script);
  if (result.errors.isNotEmpty) {
    throw PheasantTemplateException(
      '''
Error Reading Script Component: Variable Error: ${result.errors.map((e) => e.problemMessage)} 
  Fix: ${result.errors.map((e) => e.correctionMessage)} 
  ''',
      exitCode: result.errors.map((e) => e.errorCode.numParameters).first,
    );
  }
  return result;
}
