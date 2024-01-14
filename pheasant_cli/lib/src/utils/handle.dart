import 'dart:io';
import 'package:args/args.dart';

import '../commands/handle.dart';

import 'parse.dart';
import '../constants/constants.dart';
import 'src/usage.dart';

void handleArguments(List<String> arguments) {
  final ArgParser argParser = buildPheasantParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }

    if (results.wasParsed('version')) {
      print('pheasant version -> $version');
      return;
    }

    handleCommand(results, argParser);
  
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
    exit(1);
  } on Exception {
    print('An error occured: ');
    exit(2);
  }
}
