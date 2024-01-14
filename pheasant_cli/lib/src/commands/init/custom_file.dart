import 'dart:io';

import 'package:cli_util/cli_logging.dart';

Future<void> componentFileConfig(Logger logger, String projName, String proj, String resolvedPath) async {
  logger.trace('Setting Up Main File');
  
  String mainDartFileData = '''
  import 'package:pheasant/pheasant.dart';
  
  // File will be generated.
  import 'package:$projName/main.phs.dart';
  
  void main() {
  createApp(App);
  }
  ''';
  await File('$proj/web/main.dart').writeAsString(mainDartFileData);
  
  logger.trace('Adding Base Components');
  File mainComponentFile = await File('$proj/lib/App.phs').create(recursive: true);
  File componentComponentFile = await File('$proj/lib/components/Component.phs').create(recursive: true);
  
  logger.trace('Adding Data to Base Components');
  String mainComponentFileData = '''
<script>
import 'component/Component.phs' as Component;
String helloWorld = "Hello, World!";
</script>

<template>
<div id="hello">
  <p>{{helloWorld}}</p>
  <Component />
</div>
</template>

<style>
#hello {
  color: aquamarine;
}
</style>
  ''';
  await mainComponentFile.writeAsString(mainComponentFileData);
  String componentComponentFileData = '''
<script>
</script>

<template>
<div>
  <p>Welcome to Raven</p>
  <p>Configure this project by editing <code>'lib/App.phs'</code></p>
</div>
</template>

<style>
</style>
  ''';
  await componentComponentFile.writeAsString(componentComponentFileData);
}
