import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:path/path.dart';
import 'package:pheasant_cli/src/commands/general/errors.dart';
import 'package:pheasant_cli/src/commands/init/app/appgen.dart';
import 'package:pheasant_cli/src/commands/init/interface.dart';

import '../config.dart';


FutureOr<void> initPluginGenerate(Logger logger, ArgResults results, ProcessManager manager, String projName, Map<String, dynamic> pluginanswers, {required linter}) async {
  final baseProject = await baseGeneration(logger, results, projName, manager);
  var proj = baseProject.proj;
  var spawn = baseProject.process;
  var genProgress = baseProject.progress;
  var resolvedPath = baseProject.path;

  await pubspecConfig(logger, proj, spawn, manager, genProgress);
  genProgress.finish(showTiming: true);

  await fileGenConfig(logger, projName, proj, resolvedPath, filesRef: pluginanswers);

  // Configure pheasant.yaml file
  await createYamlConfig(logger, proj, projName, cliAnswers: pluginanswers);

  genProgress.finish(showTiming: true);
}

Future<ProjGenClass> baseGeneration(Logger logger, ArgResults results, String projName, ProcessManager manager) async {
  var genProgress = logger.progress('Generating Project');
  // Create directory if stated
  final dirPath = results.command?['directory'];
  String resolvedPath = projName;
  if (dirPath != null) {
    resolvedPath = normalize(absolute(dirPath));
    Directory(resolvedPath).createSync(recursive: true);
  }

  // Create base project
  logger.trace('Generating base project');
  var proj = (dirPath == null ? resolvedPath : '$resolvedPath/$projName');
  var spawn = await manager.spawnDetached('dart', [
    'create',
    '-t',
    'package',
    proj,
    results.command!.wasParsed('force') ? '--force' : ''
  ]);
  // Check for errors in spawn
  await errorCheck(spawn, logger, genProgress);
  logger.trace('Base Project Generated');

  return ProjGenClass(
    logger: logger,
    progress: genProgress,
    path: resolvedPath,
    proj: proj,
    process: spawn
  );
}

Future<void> fileGenConfig(Logger logger, String projName, String proj, String resolvedPath, {required Map<String, dynamic> filesRef}) async {
  List<String> answers = pluginanswers.values.first;
  if (answers.isEmpty) {
    stderr.writeln(wrapWith('You must provide one plugin type to create', [red, styleBold]));
    exit(1);
  } else if (answers.where((element) => element.contains("components")).isEmpty) {
    stderr.writeln(wrapWith('Sorry, but the plugin types: ${answers.join(", ")}, are not supported yet. Please check the Pheasant Framework on pub.dev for any updates.', [green]));
    exit(0);
  } else {
    if (answers.where((element) => element.contains("(not supported)")).isNotEmpty) {
      stderr.writeln(wrapWith('Sorry, but the plugin types: ${answers.join(", ")}, are not supported yet. Please check the Pheasant Framework on pub.dev for any updates.', [green]));
    }
  }

  String mainFilePlaceholder = '''
import 'package:pheasant/custom.dart';

/// This is the name of your plugin component.
/// 
/// Change this, or make a function to call the constructor in order to change the name of the component when rendered
/// 
/// For more guidelines on making your custom component check: https://github.com/pheasantframework/pheasant/blob/patch/docs/custom/components.md
class PlaceholderPlugin extends PheasantComponent {
  // You can add attribute definitions as well to your component

  // This function must always be overriden to provide the element.
  @override
  Element renderComponent([TemplateState? state]) {
    return ParagraphElement()..text = "Hello World!";
  }
}

// You can add more components, but it is recommended to export them all into one file for ease of access by the framework renderer.
''';
  File componentfile = await File('$proj/lib/components.dart').create(recursive: true);
  await componentfile.writeAsString(mainFilePlaceholder);

  await Directory('$proj/example').delete();
  
}
