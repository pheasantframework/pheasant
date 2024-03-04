import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';

import 'log/analyze_log.dart';
import '../general/errors.dart';

Future<void> mainProcess(ProcessManager manager, Logger logger,
    {String port = '8080',
    Iterable<String> options = const [],
    String? output}) async {
  List<String> runOptions = [];
  for (String item in options) {
    if (item == 'output' || item == 'release') {
      runOptions.add('--$item');
      if (item == 'output' && output != null) runOptions.add(output);
    } else if (item.contains('auto')) {
      runOptions
          .addAll(item.split('--').map((e) => e == 'auto' ? '--auto' : e));
    }
  }
  String outputOption =
      options.singleWhere((element) => element == 'output', orElse: () => "");
  var validateProgress = logger.progress('Getting App Ready');

  Process process;
  if (Process.runSync('webdev', []).exitCode != 0) {
    logger.trace('Activating webdev');
    process = await manager
        .spawnDetached('dart', ['pub', 'global', 'activate', 'webdev']);
    await errorCheck(process, logger, validateProgress);
  }

  validateProgress.finish(showTiming: true);

  var webdev = logger.progress('Running Build in Web');

  logger.trace('Running App using Webdev');
  int log = 0;
  await Future.delayed(Duration(milliseconds: 1200));
  process = await manager.spawnBackground('webdev', [
    'serve',
    'web:$port',
    ...runOptions,
    ...(outputOption.isNotEmpty && output != null
        ? [outputOption, outputOption]
        : [])
  ], runInShell: true)
    ..stdout.transform(utf8.decoder).forEach((stream) {
      if (stream.contains('WARNING') || stream.contains('SEVERE')) {
        logger.stdout(wrapWith(
            analyzeLog(stream), [stream.contains('WARNING') ? yellow : red])!);
      }
      if (stream.contains('--------------') && log == 0) {
        log = 1;
        logger.trace('Web server started successfully!');
        webdev.finish(showTiming: true);
        logger.stdout(styleBold.wrap('Build Successful!')!);
        logger.stdout(wrapWith(
            'Web App running on ${wrapWith('http://localhost:$port', [
                  styleUnderlined
                ])}',
            [yellow])!);
      }
      if (stream.contains('failed')) {
        logger.trace('Web server failed!');
        logger.trace(stream);
        logger
            .stdout(wrapWith('Web Server Failed to Load: ', [red, styleBold])!);
        logger.stdout(wrapWith(analyzeStream(stream), [styleBold])!);
      }
    })
    ..stderr.transform(utf8.decoder).forEach((stream) {
      if (stream.contains('failed') || stream.contains('Exception')) {
        logger.trace('Web server failed!');
        logger.trace(stream);
        logger
            .stdout(wrapWith('Web Server Failed to Load: ', [red, styleBold])!);
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

/** Build options
 * --release
 */
