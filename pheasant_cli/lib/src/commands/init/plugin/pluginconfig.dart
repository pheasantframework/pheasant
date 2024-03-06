import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:pheasant_cli/src/commands/init/app/appgen.dart';
import 'package:pheasant_cli/src/commands/init/interface.dart';
import 'package:pheasant_cli/src/config/config.dart';

Future<void> fileGenConfig(Logger logger, String projName, String proj,
    String resolvedPath, ProcessManager manager,
    {required Map<String, dynamic> filesRef,
    required ArgResults results}) async {
  var genProgress = logger.progress('Validating Options');
  Iterable answers = pluginanswers.values.first.toList();
  if (answers.isEmpty) {
    stderr.writeln(wrapWith(
        '\nYou must provide one plugin type to create', [red, styleBold]));
    exit(1);
  } else if (answers
      .where((element) => element.contains("components"))
      .isEmpty) {
    stderr.writeln(wrapWith(
        '\nSorry, but the plugin types: ${answers.join(", ")}, are not supported yet. Please check the Pheasant Framework on pub.dev for any updates.',
        [green]));
    exit(0);
  } else {
    if (answers
        .where((element) => element.contains("(not supported)"))
        .isNotEmpty) {
      stderr.writeln(wrapWith(
          '\nSorry, but the plugin types: ${answers.where((element) => element.contains("(not supported)")).join(", ")}, are not supported yet. Please check the Pheasant Framework on pub.dev for any updates.',
          [green]));
    }
  }
  genProgress.finish(showTiming: true);
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
  genProgress = logger.progress('Writing Project');
  File componentfile =
      await File('$proj/lib/components.dart').create(recursive: true);
  File('$proj/pheasant.plugin').create(recursive: true);
  await componentfile.writeAsString(mainFilePlaceholder);

  logger.trace('Generating Example Implementation');
  await Directory('$proj/example').delete(recursive: true);
  await initAppGenerate(logger, results, manager, 'example',
      projPath: '$projName/example',
      plugin: true,
      config: PheasantCliBaseConfig(
          plugins: [
        PheasantPlugin(
            name: projName,
            source: 'path',
            sourcesupp: '..',
            sourcesuppName: 'path')
      ].toList()));

  String phsReplacePlaceholder = '''
<script>
import 'package:$projName/components.dart';

String statement = "Hello World";
</script>

<template>
<div>
  <h1>Example Project for $projName</h1>
  <PlaceholderPlugin />
</div>
</template>

<style>
</style>
''';
  await (await File('$proj/example/lib/App.phs').create())
      .writeAsString(phsReplacePlaceholder);
  await Directory('$proj/example/lib/components').delete(recursive: true);
  await File('$proj/example/CHANGELOG.md').delete();
  await File('$proj/example/.gitignore').delete();
  logger.trace('Rewriting Files');
  String readmePlaceholder = '''
# Example Project for $projName
This is an example implementing the given plugin. Run the following command to get it started:

```bash
pheasant run
```
''';
  await File('$proj/example/README.md').writeAsString(readmePlaceholder);
  String pubspecPlaceholder = '''
name: example

environment:
  sdk: '>=3.0.0'

dependencies:
  web: ^0.4.0
  pheasant: any

dev_dependencies:
  build_runner: ^2.4.0
  build_web_compilers: ^4.0.0
  lints: ^3.0.0
''';
  await File('$proj/example/pubspec.yaml').writeAsString(pubspecPlaceholder);
  logger.trace('Getting pheasant package');
  var getprocess = await manager.spawnDetached('dart', ['pub', 'get']);
  getprocess.stderr.listen((event) {
    logger.trace(red.wrap(utf8.decode(event))!);
  });
  logger.trace('Done');
  genProgress.finish(showTiming: true);
}
