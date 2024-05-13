// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


library;

import 'dart:core' hide Enum;

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart' hide Directive;

import 'package:code_builder/code_builder.dart'
    show
        Code,
        CodeExpression,
        Directive,
        DirectiveBuilder,
        Field,
        FieldBuilder,
        Method,
        MethodType,
        Parameter,
        refer;

import 'shared/extractor_result.dart';
import 'shared/parse_code.dart';
import 'shared/metadata/props.dart';

import '../../exceptions/exceptions.dart';

import '../analyze/imports/combinators.dart';
import '../analyze/imports/extension.dart';

import 'enums/get_enums.dart';

import 'functions/functions.dart';
import 'functions/deps.dart';

import 'variables/variable_info.dart';
import 'variables/variable_declarations.dart';

import 'imports/get_imports.dart';

export 'imports/extension.dart';

/// The `PheasantScript` class, a class used to encapsulate code defined in the `<script>` part of a pheasant file.
/// Code defined in the script consist of none or at least one of the following:
///
/// 1. Variable Definitions: Definition of variables used for either code manipulation in the script part, or for interpolation and manipulation in the template part.
/// In future versions, variables may also be used in sass-enabled style parts (PSM).
/// ```dart
/// int myNum = 9
/// ```
///
/// 2. Function Definitions: Perform similar purposes with variables, but they are functions (of course), and they can also be used in situations such as onclick events, input events and others.
/// In future versions, functions may also be used in sass-enabled style parts (PSM).
/// ```dart
/// void addNum() {
///   myNum++;
/// }
/// ```
///
/// 3. Import Directives: These are used to import at least one of the following:
/// dart files used in the code,
/// pheasant components used in the **template** section of the file,
/// (future version) dart-pheasant components used in the **template** section of the file.
/// ```dart
/// import 'file.dart';
/// ```
///
/// The [PheasantScript] class contains three variables used to store these declarations respectively, which are lists of ASTs - [VariableDefinition], [FunctionDeclaration] and [ImportDirective].
/// The difference between [VariableDefinition] and [VariableDeclaration] is the fact that [VariableDefinition] is an encapsulated extension of [VariableDeclaration] that includes the variable's type.
///
/// The functions [extractVariable], [extractFunction] and [extractImport] are used to get these definitions and store them in the class.
///
/// In order to translate these to desired code blocks, we have getters [fields], [methods] and [imports].
class PheasantScript {
  final List<VariableDefinition> _varDef;
  final List<FunctionDeclaration> _funDef;
  final List<ImportDirective> _impDef;

  /// Get functionality not rooted in the `PheasantComponent` class and so are standalone in the generated file.
  ///
  /// Check [PheasantScriptUnchanged] for more information.
  final PheasantScriptUnchanged unchanged;

  /// Constructor to instantiate a [PheasantScript] object.
  ///
  /// None of the parameters are required, so you can therefore parse only the ones required for your use case (getter).
  PheasantScript({
    List<VariableDefinition> varDef = const [],
    List<FunctionDeclaration> funDef = const [],
    List<ImportDirective> impDef = const [],
    List<EnumDeclaration> enumDef = const [],
  })  : _impDef = impDef,
        _funDef = funDef,
        _varDef = varDef,
        unchanged = PheasantScriptUnchanged(enums: enumDef);

  /// Const constructor used to initialise an empty [PheasantScript].
  const PheasantScript.empty()
      : _impDef = const [],
        _funDef = const [],
        _varDef = const [],
        unchanged = const PheasantScriptUnchanged();

  /// Parse a given string source and generate a pheasant script from it.
  factory PheasantScript.parse(String script) {
    PheasantExtractorResult result = extractAll(script);
    return PheasantScript(
        varDef: result.variables,
        funDef: result.functions,
        impDef: result.imports,
        enumDef: result.enums);
  }

  /// Getter to get the fields for the desired pheasant app component.
  ///
  /// This method translates the ast definition [_varDef] stored in the class to the `code_builder` type [Field] to use in the `renderFunc` function.
  List<Field> get fields {
    return List.generate(_varDef.length, (index) {
      final variable = _varDef[index];
      var field = FieldBuilder()
        ..name = "${variable.declaration.name}"
        ..type = refer(variable.dataType)
        ..late = variable.declaration.isLate
        ..modifier = modifier(variable.declaration)
        ..annotations
            .addAll(List.generate(variable.annotations.length, (index) {
          return CodeExpression(Code(
              variable.annotations[index].toSource().replaceAll('@', '_i1.')));
        }));
      if (variable.declaration.initializer == null &&
          !variable.dataType.contains('?')) {
      } else {
        field.assignment = Code(
            '${variable.declaration.initializer == null && variable.dataType.contains('?') ? variable.declaration.initializer : (variable.declaration.initializer ?? "")}');
      }
      return field.build();
    });
  }

  /// Code to get the "prop fields" in a class
  /// The prop fields are fields uninitialised in a class, and therefore will be passed as parameters into the constructor.
  ///
  /// These fields are encapsulated in a [PropField] class, which gives relevant information as to how these fields are presented in the constructor.
  ///
  /// These feilds are usually denoted with an `@prop` or `@Prop()` annotation on them.
  /// By default all uninitialised variables, except those bearing an `@noprop` annotation are passed as props.
  ///
  /// The `@Prop()` annotation helps define the kind of prop field it is (whether it has a default value or not), and this information is stored in the [PropField] class.
  List<PropField> get props {
    List<PropField> initList = List<PropField>.generate(
        _varDef.where((element) {
          return element.annotations
              .where((el) =>
                  el.name.toSource() == 'prop' || el.name.toSource() == 'Prop')
              .isNotEmpty;
        }).length, (index) {
      final variable = _varDef
          .where((element) => element.annotations
              .where((el) =>
                  el.name.toSource() == 'prop' || el.name.toSource() == 'Prop')
              .isNotEmpty)
          .toList()[index];
      var field = FieldBuilder()
        ..name = "${variable.declaration.name}"
        ..type = refer(variable.dataType)
        ..late = variable.declaration.isLate
        ..modifier = modifier(variable.declaration);
      if (variable.declaration.initializer == null &&
          !variable.dataType.contains('?')) {
      } else {
        field.assignment = Code(
            '${variable.declaration.initializer == null && variable.dataType.contains('?') ? variable.declaration.initializer : (variable.declaration.initializer ?? "")}');
      }
      Iterable<Annotation> propAnnotations = variable.annotations.where(
          (element) =>
              element.name.toSource() == 'prop' ||
              element.name.toSource() == 'Prop');
      return PropField(
          fieldDef: field.build(),
          annotationInfo: PropAnnotationInfo(data: {
            'defaultTo': propAnnotations.first.name.toSource() == 'prop' ||
                    propAnnotations.first.arguments!.arguments
                        .where((element) =>
                            element.beginToken.toString() == 'defaultTo')
                        .isEmpty
                ? ''
                : propAnnotations.first.arguments?.arguments
                    .singleWhere((element) =>
                        element.beginToken.toString() == 'defaultTo')
                    .childEntities
                    .last
                    .toString(),
            'optional': propAnnotations.first.name.toSource() == 'prop' ||
                    propAnnotations.first.arguments!.arguments
                        .where((element) =>
                            element.beginToken.toString() == 'optional')
                        .isEmpty
                ? false
                : bool.parse(propAnnotations.first.arguments?.arguments
                        .singleWhere((element) =>
                            element.beginToken.toString() == 'optional')
                        .childEntities
                        .last
                        .toString() ??
                    "false"),
          }));
    });

    List<PropField> indirectList = List<PropField>.generate(
        fields.where((element) {
          return element.annotations.where((p0) {
                return p0.toString().contains('noprop') &&
                    !p0.toString().contains('prop') &&
                    !p0.toString().contains('Prop');
              }).isEmpty &&
              element.assignment == null &&
              !((element.type?.symbol ?? 'var').contains('?') ||
                  ['var', 'final', 'const', 'dynamic']
                      .contains(element.type?.symbol ?? 'var')) &&
              !initList.map((e) => e.fieldDef.name).contains(element.name);
        }).length, (index) {
      return PropField(
          fieldDef: fields.where((element) {
            return element.annotations.where((p0) {
                  return p0.toString().contains('noprop') &&
                      !(p0.toString() == 'prop') &&
                      !(p0.toString() == 'Prop');
                }).isEmpty &&
                element.assignment == null &&
                !((element.type?.symbol ?? 'var').contains('?') ||
                    ['var', 'final', 'const', 'dynamic']
                        .contains(element.type?.symbol ?? 'var')) &&
                !initList.map((e) => e.fieldDef.name).contains(element.name);
          }).toList()[index],
          annotationInfo:
              PropAnnotationInfo(data: {'defaultTo': '', 'optional': false}));
    });
    return (initList + indirectList);
  }

  /// Getter to get the methods for the desired pheasant app component.
  ///
  /// This method translates the ast definition [_funDef] stored in the class to the `code_builder` type [Method] to use in the `renderFunc` function.
  List<Method> get methods {
    return List.generate(_funDef.length, (index) {
      final function = _funDef[index];
      return Method((m) => m
        ..name = function.name.toString()
        ..returns = refer(function.returnType?.toSource() ?? 'dynamic')
        ..modifier = funModifier(function)
        ..requiredParameters.addAll(List.generate(
            function.functionExpression.parameters?.parameters
                    .where((element) => !element.isOptional)
                    .length ??
                0, (index) {
          final param =
              function.functionExpression.parameters!.parameters[index];
          return Parameter((p) => p
            ..name = param.name.toString()
            ..covariant = param.covariantKeyword == null ? false : true
            ..named = param.isNamed
            ..required = param.requiredKeyword == null ? false : true
            ..type = refer('${param.name?.previous}'));
        }))
        ..optionalParameters.addAll(List.generate(
            function.functionExpression.parameters?.parameters
                    .where((element) => element.isOptional)
                    .length ??
                0, (index) {
          final param =
              function.functionExpression.parameters!.parameters[index];
          return Parameter((p) => p
            ..name = param.name.toString()
            ..covariant = param.covariantKeyword == null ? false : true
            ..named = param.isNamed
            ..defaultTo = param.childEntities.length > 2
                ? Code('${param.childEntities.last}')
                : null
            ..type = refer('${param.name?.previous}'));
        }))
        ..annotations.addAll(List.generate(function.metadata.length, (index) {
          return CodeExpression(!function.metadata[index]
                  .toString()
                  .contains('JS')
              ? Code(function.metadata[index].toString().replaceAll('@', ''))
              : Code(
                  function.metadata[index].toString().replaceAll('@', '_i0.')));
        }))
        ..external = function.externalKeyword == null ? false : true
        ..type = function.isGetter
            ? MethodType.getter
            : (function.isSetter ? MethodType.setter : null)
        ..body = funBody(function));
    });
  }

  List<Method> get jsMethods => methods.where((element) {
        return element.annotations.where((p0) {
          return p0.code.toString().contains('JS');
        }).isNotEmpty;
      }).toList();

  // List<Method> get internaljsMethods;

  List<Method> get nonjsMethods => methods.where((element) {
        return !element.annotations.where((p0) {
          return p0.code.toString().contains('JS');
        }).isNotEmpty;
      }).toList();

  /// Getter to get the imports for the desired pheasant app component.
  ///
  /// This method translates the ast definition [_impDef] stored in the class to the `code_builder` type [Directive] to use in the `renderFunc` function.
  List<Directive> get imports {
    return List.generate(_impDef.length, (index) {
      final import = _impDef[index];
      return Directive.import(import.uri.toSource().replaceAll('\'', ''),
          as: import.prefix?.toSource(),
          show: getShowCombinators(import),
          hide: getHideCombinators(import));
    });
  }

  /// Getter to get the pheasant component imports
  ///
  /// Since pheasant component files are not dart files by nature, the generated file instead should be imported.
  /// Therefore this method gets the formatted imports for the dart files generated for the pheasant components.
  List<Directive> get nonDartImports {
    return imports
        .where((element) => fileExtension(element.url) != 'dart')
        .toList();
  }

  /// Function to format the extensions created by [nonDartImports] for use in the `renderFunc` function.
  List<Directive> dartedNonDartImports({String newExtension = '.phs.dart'}) {
    List<Directive> imports = nonDartImports;
    List<Directive> output = [];
    for (var element in imports) {
      DirectiveBuilder rebuild = element.toBuilder();
      rebuild.url = rebuild.url?.replaceAll('.phs', newExtension);
      output.add(rebuild.build());
    }
    return output;
  }
}

/// Class used to define other functionality not included in the main class in a .phs.dart file
///
/// Functionality defined here include: enumerations, classes [not supported yet], etc.
///
/// These functionality cannot be placed in the main class and so are declared atandalone with the use of this class.
class PheasantScriptUnchanged {
  final List<EnumDeclaration> _enumDef;

  const PheasantScriptUnchanged({List<EnumDeclaration> enums = const []})
      : _enumDef = enums;

  List<String> get enums => _enumDef.map((e) => e.toString()).toList();
}

/// Function used to extract variable definitions from the [script] of a pheasant component file.
///
/// Throws a [PheasantTemplateException] in the event of any errors during parsing.
List<VariableDefinition> extractVariable(String script) {
  ParseStringResult result = parseCode(script);
  CompilationUnit newUnit = result.unit;

  return getVariableDeclarations(newUnit);
}

/// Function used to extract function definitions from the [script] of a pheasant component file.
///
/// Throws a [PheasantTemplateException] in the event of any errors during parsing.
List<FunctionDeclaration> extractFunction(String script) {
  ParseStringResult result = parseCode(script);
  return extractFunctions(result.unit);
}

/// Function used to extract import directives from the [script] of a pheasant component file.
///
/// Throws a [PheasantTemplateException] in the event of any errors during parsing.
List<ImportDirective> extractImports(String script) {
  ParseStringResult result = parseCode(script);
  CompilationUnit newUnit = result.unit;
  return getImports(newUnit);
}

/// Function used to extract enum declarations from the [script] of a pheasant component file.
///
/// Throws a [PheasantTemplateException] in the event of any errors during parsing.
List<EnumDeclaration> extractEnumerations(String script) {
  ParseStringResult result = parseCode(script);
  CompilationUnit unit = result.unit;
  return getEnums(unit);
}

/// Function used to extract all supported declarations from the [script] of a pheasant component file and save it in a [PheasantExtractorResult].
///
/// Throws a [PheasantTemplateException] in the event of any errors during parsing.
PheasantExtractorResult extractAll(String script) {
  ParseStringResult result = parseCode(script);
  CompilationUnit newUnit = result.unit;
  return PheasantExtractorResult(getVariableDeclarations(newUnit),
      extractFunctions(newUnit), getImports(newUnit), getEnums(newUnit));
}
