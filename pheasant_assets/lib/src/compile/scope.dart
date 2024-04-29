import '../exceptions/exceptions.dart';

import '../css/extract.dart';
import '../css/id_scope.dart';

import '../assets.dart';
import '../sass/logger.dart';

import 'package:sass/sass.dart' as sass
    show SassException, compileStringToResult, Syntax;

/// Function used to scope components.
///
/// This is the final and one of the most important tasks the negine must perform in order to help in processing the css styles syntax.
///
/// It first of all compiles the css data through the use of the [css] function, with the [pheasantStyle].
/// Then it creates the unique class ID to distinguish, and locally scope the component through the use of [makeId].
/// Finally it performs scoping with the help of the `sass` library - [sass].
///
/// Once scoping is finished, the function returns a scoped version of the [PheasantStyle] object - [PheasantStyleScoped].
///
/// Throws a [PheasantStyleException] if the scoping doesn't work
PheasantStyleScoped scopeComponents(PheasantStyle pheasantStyle,
    {bool isDev = false, final String? appPath, bool sassEnabled = false}) {
  String cssData = css(pheasantStyle,
      dev: isDev, appPath: appPath ?? 'lib', sassEnabled: sassEnabled);
  String specialid = makeId(pheasantStyle);

  String scopableCssData = '''
$specialid {
  $cssData
}
''';

  String scopedCssData = "";
  try {
    scopedCssData = sass
        .compileStringToResult(scopableCssData,
            syntax: sass.Syntax.scss, logger: sassLogger)
        .css;
  } on sass.SassException catch (exception) {
    sassLogger.warn(exception.message);
    throw PheasantStyleException(
        'Error while scoping css data: ${exception.message}');
  } catch (genExc, stackTrace) {
    throw PheasantStyleException(
        'Error while scoping css data. \nError Type: $genExc \nStack Trace: $stackTrace');
  }

  return PheasantStyleScoped(
      id: makeId(pheasantStyle).replaceFirst('.', ''),
      pheasantStyle: pheasantStyle,
      css: pheasantStyle.scope == StyleScope.global ? cssData : scopedCssData,
      scoped: pheasantStyle.scope == StyleScope.local);
}
