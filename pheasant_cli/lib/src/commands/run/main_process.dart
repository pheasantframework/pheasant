import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import '../general/errors.dart';

Future<void> mainProcess(ProcessManager manager, Logger logger, [String port = '8080']) async {
  var validateProgress = logger.progress('Getting App Ready');
  
  Process process;
  if (Process.runSync('webdev', []).exitCode != 0) {
    logger.trace('Activating webdev');
    process = await manager.spawnDetached('dart', ['pub', 'global', 'activate', 'webdev']);
    await errorCheck(process, logger, validateProgress);
  }

  validateProgress.finish(showTiming: true);
  
  var webdev = logger.progress('Running Build in Web');
  
  logger.trace('Running App using Webdev');
  int log = 0;
  await Future.delayed(Duration(milliseconds: 1000));
  process = await manager.spawnDetached(
    'webdev', 
    ['serve', 'web:$port']
  )..stdout.transform(utf8.decoder).forEach((stream) {
    logger.stdout(wrapWith(analyzeLog(stream), [stream.contains('WARNING') ? yellow : red])!);
    if (stream.contains('--------------') && log == 0) {
      log = 1;
      logger.trace('Web server started successfully!');
      webdev.finish(showTiming: true);
      logger.stdout(styleBold.wrap('Build Successful!')!);
      logger.stdout(wrapWith('Web App running on ${wrapWith('http://localhost:$port', [styleUnderlined])}', [yellow])!);
    }
    if (stream.contains('failed')) {
      logger.trace('Web server failed!');
      logger.trace(stream);
      logger.stdout(wrapWith('Web Server Failed to Load: ', [red, styleBold])!);
      logger.stdout(wrapWith(analyzeStream(stream), [styleBold])!);
    }
  })
  ..stderr.transform(utf8.decoder).forEach((stream) {
    if (stream.contains('failed') || stream.contains('Exception')) {
      logger.trace('Web server failed!');
      logger.trace(stream);
      logger.stdout(wrapWith('Web Server Failed to Load: ', [red, styleBold])!);
      logger.stdout(wrapWith(analyzeStream(stream), [styleBold])!);
      exit(ExitCode.cantCreate.code);
    }
  });

  ProcessSignal.sigint.watch().listen((event) {
    stdout.write(styleItalic.wrap('\nExiting Web App...'));
    process.kill();
    exit(0);
  });
}

String analyzeLog(String stream) {
  StringBuffer buffer = StringBuffer();
  if (stream.contains('WARNING')) {
    String newstream = stream.replaceFirst('[WARNING]', 'WARN -');
    if (stream.contains('AssetNotFoundException')) {

    } else if (stream.contains('AssetNotFoundException')){

    }
    else {
      buffer.write(newstream);
    }
  } else if (stream.contains('SEVERE')) {
    String newstream = stream.replaceFirst('[SEVERE]', 'PROBLEM -');
    if (stream.contains('AssetNotFoundException')) {
      String filename = "${stream.split(':').last.split('/').last.split('.').first}.phs";
      buffer.writeAll([
        'Failed to build $filename.'
        '\nIt seems there is an error in $filename: '
      ]);
    } else {
      buffer.write(newstream);
    }
  }
  return buffer.toString();
}

String analyzeStream(String stream) {
  StringBuffer buffer = StringBuffer();
  buffer.writeln(extractExpressionInBrackets(stream));
  // if (stream.contains('Error')) {

  // }
  return buffer.toString();
}

String? extractExpressionInBrackets(String input) {
  RegExp regExp = RegExp(r'\((.*?)\)'); // Regular expression to match content within parentheses

  Match? match = regExp.firstMatch(input);

  if (match != null) {
    return match.group(1); // Group 1 contains the content within parentheses
  } else {
    return null; // No match found
  }
}