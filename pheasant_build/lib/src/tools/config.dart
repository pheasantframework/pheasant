import 'package:path/path.dart' as path show normalize, relative;

/// Class for Pheasant App Configuration
///
/// This class is used to encapsulate important configurations made when using the pheasant cli.
///
/// It gets the info essential during build from the `pheasant.yaml` or `pheasant.json` file, and parses it from the config to the build.
class PheasantAppConfig {
  /// The main entry point of the dart project in general (the `"main.dart"` file)
  String mainEntryPoint;

  /// The entry point of the Pheasant Application (the `.phs` file to be rendered)
  String appEntryPoint;

  /// The file extension being used here
  String extension;

  /// The name of the Pheasant Application
  String? appName;

  /// Whether sass/scss preprocessing is being enabled.
  bool sass;

  /// Whether JavaScript has been enabled on this project.
  bool js;

  PheasantAppConfig(
      {this.mainEntryPoint = 'web/main.dart',
      this.appEntryPoint = 'lib/App.phs',
      this.extension = '.phs',
      this.sass = false,
      this.js = false,
      this.appName});

  /// Constructor called when parsing info from the `build.yaml` file
  factory PheasantAppConfig.fromYamlMap(Map<String, dynamic> map) {
    return PheasantAppConfig(
        appEntryPoint: map['entry'] as String? ?? 'lib/App.phs',
        mainEntryPoint: map['web'] as String? ?? 'web/main.dart',
        sass: map['sass'] as bool? ?? false,
        js: map['js'] as bool? ?? false);
  }

  String get mainEntry {
    return relativeFilePath(appEntryPoint, 'lib');
  }
}

/// Simple type definition for Pheasant App Configurations
typedef AppConfig = PheasantAppConfig;

/// Function to get the relative file path of a file from a directory in a Pheasant Project.
String relativeFilePath(String filePath, String baseDirectory) {
  // Normalize the paths to handle platform-specific differences
  filePath = path.normalize(filePath);
  baseDirectory = path.normalize(baseDirectory);

  // Calculate the relative path
  String relativePath = path.relative(filePath, from: baseDirectory);

  // If the file is in the base directory, the relative path might be empty,
  // so we append './' to represent the current directory.
  return relativePath.isEmpty ? '.' : relativePath;
}
