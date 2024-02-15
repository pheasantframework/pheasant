import 'dart:io';

import 'package:args/args.dart';
import 'package:io/ansi.dart';
import '../../constants/clidoc.dart';

void printUsage(ArgParser argParser) {
  stdout.writeln('Usage: pheasant <options> [arguments]\n');
  stdout.writeln(styleBold.wrap('Commands'));
  cmdInfo.forEach(
    (key, value) {
      stdout.writeln('   ${key.padRight(13)} $value');
    },
  );
  stdout.writeln(styleBold.wrap('\nGlobal Options'));
  stdout.writeln(argParser.usage);
}

String commandUsage(ArgParser argParser, String command) {
  StringBuffer buffer = StringBuffer();
  buffer.writeln(cmdInfo[command]);
  buffer.writeln();
  buffer.writeln(
      'Usage: pheasant $command <options> ${command == 'init' ? '<name>' : '[arguments]'}');
  buffer.write(argParser.commands[command]?.usage);

  return buffer.toString();
}
