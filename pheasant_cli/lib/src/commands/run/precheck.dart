import 'dart:io';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:pheasant_cli/src/commands/run/getters/configfile.dart';
import '../../config/config.dart';

Future<void> checkConfigFiles(Logger logger) async {
  logger.trace('Searching for Pubspec File');
  bool pubspec = await File('pubspec.yaml').exists();
  if (!pubspec) {
    stderr.writeln('${wrapWith('Error:', [styleBold, red])} Could not find pubspec file in current directory.');
    exit(1);
  }
  logger.trace('Searching for Config File');
  if (!File(configFile).existsSync()) {
    stderr.writeln('${wrapWith('Error:', [styleBold, red])} Could not find config file - ${red.wrap('pheasant.yaml/pheasant.json')} - in current directory.');
    exit(1);
  }
}

Future<void> checkProject(Logger logger, PheasantCliBaseConfig appConfig) async {
  logger.trace('Ensuring program is running in correct directory');
  bool appFile = await File(appConfig.entrypoints['main']!).exists();
  bool mainFile = await File(appConfig.entrypoints['app']!).exists();
  
  if (!appFile) {
    stderr.writeln('${wrapWith('Error:', [styleBold, red])} Could not find app entry point - ${red.wrap(appConfig.entrypoints['app'])} - in current directory.');
    exit(1);
  }
  if (!mainFile) {
    stderr.writeln('${wrapWith('Error:', [styleBold, red])} Could not find main entry point - ${red.wrap(appConfig.entrypoints['main'])} - in current directory.');
    exit(1);
  }
}
