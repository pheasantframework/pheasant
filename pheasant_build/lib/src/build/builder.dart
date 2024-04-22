import 'package:build/build.dart' show Builder, BuilderOptions;
import 'package:path/path.dart' show basenameWithoutExtension;

import '../tools/config.dart' hide relativeFilePath;
import 'src/pheasant_router_builder.dart' show PheasantRouterBuilder;
import 'src/pheasant_main_builder.dart';
import 'src/pheasant_file_builder.dart';

Builder pheasantRouterBuilder(BuilderOptions builderOptions) =>
    PheasantRouterBuilder();

/// The Pheasant File Builder used to render Pheasant Files during build.
Builder pheasantFileBuilder(BuilderOptions builderOptions) {
  AppConfig config = PheasantAppConfig.fromYamlMap(builderOptions.config);
  return PheasantFileBuilder(
    js: config.js,
    sass: config.sass,
  );
}

/// The Pheasant Builder used to render the `main.phs.dart` file during build.
Builder pheasantMainBuilder(BuilderOptions builderOptions) {
  AppConfig config = PheasantAppConfig.fromYamlMap(builderOptions.config);
  return PheasantMainBuilder(
    mainEntry: config.mainEntry,
    appName: '${basenameWithoutExtension(config.appEntryPoint)}Component',
    fileExtension: '${config.extension}.dart',
  );
}
