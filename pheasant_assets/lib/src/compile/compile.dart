// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


import 'dart:io' show Directory;

import 'package:csslib/parser.dart' as css show Message, compile;
import 'package:path/path.dart' show join;
import 'package:sass/sass.dart' as sass
    show SassException, compileStringToResult, compileToResult, Syntax;

import '../exceptions/exceptions.dart';
import '../sass/logger.dart';
import '../assets.dart' show PheasantStyle;
import '../constants/syntax.dart' as syn;

/// Function used to compile css.
/// This function is the second step after the `css()` function, when it comes to compiling css.
///
/// Here, the [PheasantStyle] object only serves the purpose of denoting the configuration (`syntax` and so on) of the compiler function.
///
/// The [cssString] represents the string to be compiled.
///
/// The function first of all confirms the syntax given is valid, via the [syn.syntax] list, and throws a [PheasantStyleException] if it is not included.
///
/// Afterwards, the function is compiled. If the syntax is already css, then the [css.compile] compiler has the sole purpose of validating the code.
/// If the css is invalid, then it will write out [css.Message] messages, and all will be written to the console, then [PheasantStyleException] will be thrown.
///
/// If the synax isn't css, then the [sass] compiler will compile the css. Returns the compiled css as a String, throws a [PheasantStyleException] if the code didn't compile.
String compileCss(PheasantStyle pheasantStyle, String cssString,
    {bool sassEnabled = false}) {
  var cssErrors = <css.Message>[];
  if (!syn.syntax.contains(pheasantStyle.syntax)) {
    throw PheasantStyleException('Syntax is invalid: ${pheasantStyle.syntax}');
  }

  if (pheasantStyle.syntax == 'css') {
    css.compile(
      cssString,
      errors: cssErrors,
    );
    if (cssErrors.isNotEmpty) {
      for (var element in cssErrors) {
        print("Error compiling css: ${element.message}");
        print("Error Description: ${element.describe}");
      }
      throw PheasantStyleException(
          "Error(s) Occured while Compiling CSS: ${cssErrors.map((e) => e.message)}\n $pheasantStyle");
    } else {
      return cssString;
    }
  } else {
    if (!sassEnabled) {
      throw PheasantStyleException(
          'Sass is not enabled on this project. Set sass to true in your pheasant.yaml or pheasant.json file in your project to use sass');
    }
    try {
      final cssData = sass.compileStringToResult(cssString,
          syntax: pheasantStyle.syntax == 'scss'
              ? sass.Syntax.scss
              : sass.Syntax.sass,
          logger: sassLogger);
      return cssData.css;
    } on sass.SassException catch (exception) {
      throw PheasantStyleException(
          "Error occured while Compiling ${pheasantStyle.syntax == 'scss' ? "SCSS" : "SASS"} : ${exception.message}");
    }
  }
}

/// Function to compile css given the file path.
///
/// This is similar to the [compileCss] function, but this compiles given the file path, rather than a raw string. So all parts except the final compilation are similar.
///
/// The css, regardless of syntax, is compiled with the [sass] compiler,
/// and on the throw of a [sass.SassException], the function will then also throw a [PheasantStyleException].
///
/// The [sassPath] contains the relative path of the css/sass/scss file to the pheasant file.
///
/// The [componentDirPath] is the directory path of the pheasant file (or the css/sass/scss file) relative to the project. It defaults to `'lib'`.
///
/// The [devDirPath] is exclusively a gateway for the example code of this project, and should not be used outside the api.
String compileSassFile(PheasantStyle pheasantStyle, String sassPath,
    {String componentDirPath = 'lib',
    String? devDirPath,
    bool sassEnabled = false}) {
  String absPath =
      join(Directory.current.path, (devDirPath ?? componentDirPath), sassPath);
  if (!syn.syntax.contains(pheasantStyle.syntax)) {
    throw PheasantStyleException('Syntax is invalid: ${pheasantStyle.syntax}');
  }

  if ((sassPath.contains('.sass') || sassPath.contains('.scss')) &&
      !sassEnabled) {
    throw PheasantStyleException(
        'Sass is not enabled on this project. Set sass to true in your pheasant.yaml or pheasant.json file in your project to use sass');
  }

  try {
    final cssData = sass.compileToResult(absPath, logger: sassLogger);
    return cssData.css;
  } on sass.SassException catch (exception) {
    throw PheasantStyleException(
        "Error occured while Compiling ${pheasantStyle.syntax == 'scss' ? "SCSS" : (pheasantStyle.syntax == 'sass' ? "SASS" : "CSS")} : ${exception.message}");
  }
}
