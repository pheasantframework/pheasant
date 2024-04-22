import 'package:analyzer/dart/ast/ast.dart'
    show FunctionDeclaration, VariableDeclaration;
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_builder/code_builder.dart'
    show Code, FieldModifier, MethodModifier;

FieldModifier modifier(VariableDeclaration vd) {
  String mod = vd.beginToken.isModifier ? vd.beginToken.toString() : 'dynamic';
  if (mod == 'const') {
    return FieldModifier.constant;
  } else if (mod == 'final') {
    return FieldModifier.final$;
  } else {
    return FieldModifier.var$;
  }
}

Code? funBody(FunctionDeclaration fd) {
  String body = _getFunBody(fd);
  if (funModifier(fd) != null) {
    switch (funModifier(fd)!) {
      case MethodModifier.async:
        body = body.replaceFirst("async", "");
        break;
      case MethodModifier.asyncStar:
        body = body.replaceFirst("async*", "");
        break;
      case MethodModifier.syncStar:
        body = body.replaceFirst("sync*", "");
        break;
    }
  }
  if (body.startsWith(RegExp(r'\s*=>'))) {
    body = '${body.replaceFirst(RegExp(r'\s*=>'), 'return')};';
  }
  return body.isEmpty ? null : Code(body);
}

MethodModifier? funModifier(FunctionDeclaration function) {
  String body = _getFunBody(function);
  if (body.startsWith("async")) {
    return MethodModifier.async;
  } else if (body.startsWith("async*")) {
    return MethodModifier.asyncStar;
  } else if (body.startsWith("sync*")) {
    return MethodModifier.syncStar;
  } else {
    return null;
  }
}

String _getFunBody(FunctionDeclaration function) {
  var body = function.functionExpression.body.toSource();
  body = body.replaceRange(body.length - 1, null, '').replaceFirst('{', '');
  return body;
}
