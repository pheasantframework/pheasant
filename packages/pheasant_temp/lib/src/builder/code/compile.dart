// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


import 'package:code_builder/code_builder.dart'
    show
        Class,
        Code,
        CodeExpression,
        Constructor,
        DartEmitter,
        Field,
        LibraryBuilder,
        Method,
        Parameter,
        refer,
        Directive;
import 'package:dart_style/dart_style.dart'
    show DartFormatter, FormatterException;
import 'package:pheasant_assets/pheasant_assets.dart'
    show PheasantStyle, scopeComponents;

import '../analyze/analyze.dart';

import 'create_render.dart';

/// Function to render class function code during build
///
/// This is the main function behind rendering Pheasant Code to Dart Code.
/// In this function, we basically convert the data from the `script` part and the `template` part of a pheasant component into a Component class.
///
/// This class, which has a name of [componentName] which defaults to `'AppComponent'`, extends the [RavenTemplate] class, and therefore overrides two main functionality.
///
/// The key functionality that this function generates is the [render] function, which is generated via the [createRenderFunc], in order to return the desired html component to be rendered in the DOM.
///
/// This HTML component can be rerendered through state changes that may occur in the code.
///
/// This function returns a string, which is the composition for the generated dart file with the extension [buildExtension] which defaults to `'.phs.dart'`.
///
/// The [appDirPath] field is for use by the [scopeComponents] function alongside the [PheasantStyle] object in the event that css/scss/sass files are being imported.
///
/// The function also gives way for configuration options such as [js] and [sass] to denote whether javascript and sass have been enabled on the project respectively.
///
/// The function does the following, in the given order:
/// 1. Adds the required directives needed for the code: It starts off with the directives needed for every instance of a component, then adds imports included in the pheasant file.
///
/// 2. Generates the class with name [componentName] to extend `RavenTemplate`.
///
/// 3. Adds all variable and function definitions in the class, from the `script` part of the pheasant file.
///
/// 4. Creates the constructor, to call super, and overrides the `template` variable from the parent class.
///
/// 5. Generates the definition for, and overrides, the `render` function in the parent class, to return an element of type `Element`
///
String compilePhs(
    {required String script,
    required String template,
    String componentName = 'AppComponent',
    String buildExtension = '.phs.dart',
    final String? appDirPath,
    PheasantStyle pheasantStyle = const PheasantStyle(),
    bool sass = false,
    bool js = false}) {
  // Get emitter and formatter
  final formatter = DartFormatter();
  final emitter = DartEmitter.scoped();

  // Create library to generate dart code
  var item = LibraryBuilder();

  // Add necessary imports
  var parsedScript = PheasantScript.parse(script);
  item.directives.addAll(parsedScript.imports.where(
      (element) => fileExtension(element.url) == 'dart')); // Dart imports
  item.directives
      .addAll(parsedScript.dartedNonDartImports(newExtension: buildExtension));
  if (parsedScript.jsMethods.isNotEmpty) {
    item.directives.add(Directive.import('dart:js_interop',
        as: '_i0')); // Non-dart imports - importing dartified (dart-generated) files
  }

  if (js) {
    item.body.addAll(parsedScript.jsMethods);
  }

  // Create class for template
  item.body.add(Class((c) => c
    ..name = componentName
    ..extend = refer('PheasantTemplate', 'package:pheasant/build.dart')
    // Add methods generated from `script` file
    ..methods.addAll(parsedScript.nonjsMethods // Add Non-JavaScript Methods
        )
    // Add fields generated from `script` file
    ..fields.addAll(parsedScript.fields)
    // Override `template` variable
    ..fields.add(Field((f) => f
      ..name = 'template'
      ..annotations.add(CodeExpression(Code('override')))
      ..type = refer('String?')
      ..assignment = Code("'''$template'''")))

    // Create Constructor to call `super`
    ..constructors.add(Constructor((con) => con
      ..optionalParameters.add(Parameter((p) => p
        ..toSuper = true
        ..name = 'template'
        ..named = true))
      ..optionalParameters.addAll(parsedScript.props.map<Parameter>((e) {
        return Parameter((p) => p
          ..named = true
          ..toThis = true
          ..name = e.fieldDef.name
          ..required = !(e.annotationInfo.data['optional'] as bool)
          ..defaultTo = e.annotationInfo.data['defaultTo'] == '' ||
                  e.annotationInfo.data['defaultTo'] == null
              ? null
              : Code("${e.annotationInfo.data['defaultTo']}"));
      }))))
    // Override and generate definition for `render` function
    ..methods.add(Method((m) => m
      ..annotations.add(CodeExpression(Code('override')))
      ..name = 'render'
      ..requiredParameters.addAll([
        Parameter((p) => p
          ..name = 'temp'
          ..type = refer('String')),
      ])
      ..optionalParameters.addAll([
        Parameter((p) => p
          ..name = 'state'
          ..type = refer('TemplateState?', 'package:pheasant/build.dart'))
      ])
      ..returns = refer('Element', 'dart:html')
      ..docs.addAll(['  // Override function for creating an element'])
      ..body = createRenderFunc(
          template: template,
          pheasantScript: parsedScript,
          pheasantStyle: pheasantStyle,
          appDirPath: appDirPath ?? 'lib',
          sass: sass)))));
  // Return complete class instance as formatted string
  var source = "${item.build().accept(emitter)}";
  source += parsedScript.unchanged.enums.join("\n");
  try {
    return formatter.format(source, uri: appDirPath);
  } on FormatterException catch (e) {
    print(e.message(color: true));
    print(e.errors.map((a) => a.correctionMessage));
    return source;
  }
}
