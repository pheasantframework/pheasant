import 'dart:io';
import 'package:args/args.dart';
import 'package:io/ansi.dart';
import 'package:pheasant_cli/src/utils/src/usage.dart';

void welcome(ArgParser argParser) {
  stdout.writeln(wrapWith('Pheasant\n', [styleBold, yellow]));
  stdout.writeln(
      'Welcome to the Pheasant CLI. Get started with your ${wrapWith('new web app!', [
        lightYellow
      ])}');
  printUsage(argParser);
}
