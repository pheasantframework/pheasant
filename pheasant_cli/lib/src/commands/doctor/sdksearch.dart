import 'package:cli_util/cli_logging.dart';
import 'package:cli_util/cli_util.dart';
import 'package:io/ansi.dart';

Future<void> findSdk(Logger logger) async {
  var dartProgress = logger.progress(styleBold.wrap('Searching for the Dart SDK')!);
  await Future.delayed(Duration(milliseconds: 500));
  logger.trace('Searching for SDK');
  var sdkPath = getSdkPath();
  logger.trace('Dart SDK Found at $sdkPath');
  dartProgress.finish(showTiming: true);
}