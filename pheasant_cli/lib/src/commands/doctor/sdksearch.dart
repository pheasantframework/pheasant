// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
import 'package:cli_util/cli_logging.dart';
import 'package:cli_util/cli_util.dart';
import 'package:io/ansi.dart';

Future<void> findSdk(Logger logger) async {
  var dartProgress =
      logger.progress(styleBold.wrap('Searching for the Dart SDK')!);
  await Future.delayed(Duration(milliseconds: 500));
  logger.trace('Searching for SDK');
  var sdkPath = getSdkPath();
  logger.trace('Dart SDK Found at $sdkPath');
  dartProgress.finish(showTiming: true);
}
