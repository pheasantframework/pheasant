import 'dart:async' show FutureOr;
import 'package:build/build.dart' show AssetId, BuildStep, Builder;
import 'package:pheasant_temp/pheasant_temp.dart' show renderMain;

/// Builder Class used in building the `main.phs.dart` file, used as a bridge between the main entrypoint (`web/main.dart` for instance), and the compiled Pheasant Files (`App.phs.dart` for instance).
class PheasantMainBuilder extends Builder {
  String fileExtension;
  String appName;
  String mainEntry;
  String? entrypoint;

  PheasantMainBuilder({
    this.fileExtension = '.phs.dart',
    this.appName = 'AppComponent',
    this.mainEntry = 'App.phs',
    this.entrypoint,
  });

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await buildStep.writeAsString(
        AssetId(
            buildStep.inputId.package, entrypoint ?? 'lib/main$fileExtension'),
        renderMain(
            appName: appName,
            fileExtension: fileExtension,
            mainEntry: mainEntry));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$package$': [entrypoint ?? 'lib/main$fileExtension']
      };
}
