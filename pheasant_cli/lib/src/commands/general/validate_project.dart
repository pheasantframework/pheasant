// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.  
// You may use this file only in accordance with the license.
  
import 'dart:io';

import 'package:cli_config/cli_config.dart';
import 'package:cli_util/cli_logging.dart';

import '../run/getters/configfile.dart';
import '../run/handle_config.dart';
import '../run/prereq/precheck.dart';
import '../../config/config.dart';
import '../../config/configfile.dart';

Future<AppConfig> validateProject(Logger logger, List<String> configArgs,
    {bool plugin = false}) async {
  await checkConfigFiles(logger);
  logger.trace('Reading Data for Config File');
  var configFileData = File(configFile).readAsStringSync();
  var config = Config.fromConfigFileContents(
      fileContents: configFileData,
      commandLineDefines: configArgs,
      environment: Platform.environment);
  var appConfig = configFileType == PheasantConfigFile.yaml
      ? PheasantCliBaseConfig.fromYaml(configFileData, configOverrides: config)
      : PheasantCliBaseConfig.fromJson(configFileData, configOverrides: config);
  handleConfig(config, appConfig: appConfig);
  // Verify you are in right directory
  await checkProject(logger, appConfig, plugin: plugin);
  return appConfig;
}
