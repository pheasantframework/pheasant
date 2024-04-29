import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart' show DartFormatter;

/// Simple Function to render the `main` pheasant file entry.
///
/// This function writes the code used to create the `App` getter that is used in the `cerateApp` function defined in the `pheasant_build` package that is eventually used in the `main.dart` file.
///
/// This function writes code to define a getter `App` which returns the main app rendered pheasant component [appName] originally defined at [mainEntry].
///
/// The function does not require any parameters to run, as all parameters are optional and set to standard options unless defined otherwise in the pheasant config file.
///
/// Therefore, [appName] is set to `'AppComponent'` by default,
/// [mainEntry] is set to `'App.phs'` by default, and
/// [fileExtension], the file extension for all generated dart files from pheasant components, is set to `'.phs.dart'` by default.
///
/// Here is how the returned string code for a main file (defaultly computed to `main.phs.dart`)
/// ```dart
/// // ignore_for_file: no_leading_underscores_for_library_prefixes
/// import 'package:pheasant/build.dart' as _i1;
/// import 'App.phs.dart';
///
/// _i1.PheasantTemplate get App {
///   return AppComponent();
/// }
/// ```
String renderMain(
    {String appName = 'AppComponent',
    String fileExtension = '.phs.dart',
    String mainEntry = 'App.phs'}) {
  final formatter = DartFormatter();
  final emitter = DartEmitter.scoped();
  var item = LibraryBuilder();

  item.directives.addAll([
    Directive.import('${mainEntry.replaceFirst('.phs', '')}$fileExtension'),
  ]);
  item.body.add(Method((m) => m
    ..name = 'App'
    ..returns = refer('PheasantTemplate', 'package:pheasant/build.dart')
    ..type = MethodType.getter
    ..body = Code('return $appName();')));

  return formatter.format("${item.build().accept(emitter)}");
}
