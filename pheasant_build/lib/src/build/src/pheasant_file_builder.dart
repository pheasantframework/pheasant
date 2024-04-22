import 'dart:async' show FutureOr;

import 'package:build/build.dart' show BuildStep, Builder;
import 'package:path/path.dart' show basenameWithoutExtension, dirname;
import 'package:pheasant_temp/pheasant_temp.dart' show compilePhs;

import '../../src/base.dart';
import '../../tools/input.dart' hide PheasantInput;

/// Builder Class used in building, processing and creating the dart-type Pheasant Files.
///
/// This class is used in compiling Pheasant Files to dart-html component files to inject into the DOM, through the use of [compilePhs].
class PheasantFileBuilder extends Builder {
  String fileExtension;
  bool js;
  bool sass;

  PheasantFileBuilder({
    this.fileExtension = '.phs.dart',
    this.sass = false,
    this.js = false,
  });

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    var inpId = buildStep.inputId;
    var filename = basenameWithoutExtension(inpId.path);

    var data = await buildStep.readAsString(inpId);

    final String pathAtLib = dirname(inpId.path);
    var outId = inpId.changeExtension(fileExtension);

    PheasantComposedInput composedInput =
        renderInput(phsData: data, sassEnabled: sass);
    PheasantFile myIn = composedInput.input;

    final dartCode = compilePhs(
        script: myIn.script,
        template: myIn.template,
        componentName: "${filename}Component",
        pheasantStyle: composedInput.style,
        appDirPath: pathAtLib,
        js: js,
        sass: sass);

    await buildStep.writeAsString(outId, dartCode);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.phs': [fileExtension]
      };
}
