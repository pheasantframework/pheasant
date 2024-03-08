// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may not use this file except in compliance with the License.
  
import 'dart:io';
import 'package:io/ansi.dart';
import 'filesearch.dart';
import '../../../config/configfile.dart';

String get configFile {
  if (searchFile('pheasant.yaml', '.')) {
    if (searchFile('pheasant.json', '.')) {
      stderr.writeln('${wrapWith('Error:', [
            styleBold,
            red
          ])} Only one pheasant config file can be used per project.');
      exit(2);
    } else {
      return './pheasant.yaml';
    }
  } else {
    if (searchFile('pheasant.json', '.')) {
      return './pheasant.json';
    } else {
      stderr.writeln('${wrapWith('Error:', [
            styleBold,
            red
          ])} Could not find config file - ${red.wrap('pheasant.yaml/pheasant.json')} - in current directory.');
      exit(1);
    }
  }
}

PheasantConfigFile get configFileType {
  return configFile.contains('pheasant.yaml')
      ? PheasantConfigFile.yaml
      : PheasantConfigFile.json;
}
