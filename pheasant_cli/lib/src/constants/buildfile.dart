// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may not use this file except in compliance with the License.
  
import 'package:cli_util/cli_logging.dart';
import 'package:pheasant_cli/src/config/config.dart';
import 'package:yaml_edit/yaml_edit.dart';

String genBuildFile(PheasantCliBaseConfig pheasantConfig,
    {String? projNameFromPubspec, Logger? logger}) {
  logger?.trace('Generating Build Files');
  Map<String, dynamic> buildConfig = {
    'targets': {
      r'$default': {
        'builders': {
          '${projNameFromPubspec ?? pheasantConfig.projName}|pheasantMainBuilder':
              {
            'options': {
              'entry': pheasantConfig.entrypoints?['app'],
              'web': pheasantConfig.entrypoints?['main'],
            }
          },
          '${projNameFromPubspec ?? pheasantConfig.projName}|pheasantFileBuilder':
              {
            'options': {
              'entry': pheasantConfig.entrypoints!['app'],
              'sass': pheasantConfig.generalConfigs['sass'],
              'phsComponents': pheasantConfig.generalConfigs['phsComponents'],
              'js': pheasantConfig.generalConfigs['js'],
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
