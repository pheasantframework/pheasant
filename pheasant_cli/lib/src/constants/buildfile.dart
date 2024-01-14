import 'package:pheasant_cli/src/config/config.dart';
import 'package:yaml_edit/yaml_edit.dart';

String genBuildFile(PheasantCliBaseConfig pheasantConfig,) {
  Map<String, dynamic> buildConfig = {
    'targets': {
      r'$default': {
        'builders': {
          'pheasantMainBuilder': {
            'options': {
              'entry': pheasantConfig.entrypoints['app'],
              'sass': pheasantConfig.generalConfigs['sass']
            }
          }
        }
      }
    },
    'builders': {
      'pheasantMainBuilder': {
        'import': "package:pheasant_build/src/build/builder.dart",
        'builder_factories': ["pheasantMainBuilder"],
        'build_extensions': {
          r"$package$": ["lib/main.phs.dart"]
        },
        'build_to': 'cache',
        'auto_apply': 'root_package'
      },
      'pheasantFileBuilder': {
        'import': "package:pheasant_build/src/build/builder.dart",
        'builder_factories': ["pheasantFileBuilder"],
        'build_extensions': {
          ".phs": [".phs.dart"]
        },
        'build_to': 'cache',
        'auto_apply': 'root_package'
      }
    }
  };
  var yaml = YamlEditor('');
  yaml.update([], buildConfig);
  return yaml.toString();
}