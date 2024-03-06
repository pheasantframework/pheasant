import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:io/ansi.dart';

Map<String, Type> get _appquestions => <String, Type>{
      "Would you like to use a CSS Preprocessor (Sass)?": bool,
      "Would you like to add JS?": bool,
      "Would you like to add support for Pheasant Components?": bool,
      "Would you like to enable Dart Linting Rules?": bool,
      "Would you like to enable Dart Formatting?": bool
    };

Map<String, Type> get _pluginquestions => <String, Type>{
      [
        "Select the plugins you want to develop:",
        "Use the left and right arrow keys to scroll through options.",
        'Press "Space" to select an option.',
        'Press "Enter" to finish:\n'
      ].join("\n"): List,
      "Would you like to add JS?": bool,
    };

Map<String, dynamic> appanswers = Map.fromIterable(_appquestions.keys);

Map<String, dynamic> pluginanswers = Map.fromIterable(_pluginquestions.keys);

void initAppInterface(ArgResults results) {
  if (results.command!.wasParsed('yes')) {
    appanswers.updateAll((key, value) => true);
  } else {
    _appquestions.forEach((key, value) {
      stdout.writeAll(
          [lightBlue.wrap(key)!, styleBold.wrap(value == bool ? '(y/N) ' : '')],
          " ");
      final ans = stdin.readLineSync();
      if (ans == null) {
        appanswers[key] = false;
      } else {
        appanswers[key] = ans == 'y';
      }
    });
  }
  stdout.writeln();
}

Future<void> initPluginInterface(ArgResults results, {Logger? logger}) async {
  final pluginOptions = [
    "components",
    "state (not supported)",
    "app extensions (not supported)"
  ];
  if (results.command!.wasParsed('yes')) {
    pluginanswers[pluginanswers.keys.first] = pluginOptions;
    pluginanswers[pluginanswers.keys.last] = true;
  } else {
    final initList = [
      "components",
      "state (not supported)",
      "app extensions (not supported)"
    ];
    final _initList = [
      "components",
      "state (not supported)",
      "app extensions (not supported)"
    ];
    final choices = await optionSelector(
        pluginOptions, initList, _initList, " : ",
        color: cyan);
    pluginanswers[_pluginquestions.keys.first] = choices;
    var key = _pluginquestions.keys.last;
    stdout.writeAll([lightBlue.wrap(key)!, styleBold.wrap('(y/N) ')], " ");
    final ans = stdin.readLineSync();
    if (ans == null) {
      pluginanswers[key] = false;
    } else {
      pluginanswers[key] = ans == 'y';
    }
  }
  stdout.writeln();
}

Future<Iterable<String>> optionSelector(
  List<String> objects,
  List<String> initObjects,
  List<String> previousInit,
  String separator, {
  String? preamble,
  String? ending,
  AnsiCode color = red,
}) async {
  void resetOptions(List<String> objects, String separator) {
    stdout.write('\r');
    stdout.writeAll(objects, separator);
    stdout.write("    ");
    stdout.write('\b' * 4);
  }

  stdout.write(preamble ?? "");
  Completer completer = Completer<Iterable<String>>();
  stdout.writeAll(objects, separator);
  stdin.lineMode = false;
  int index = 1;
  List<int> coloured = [];
  late StreamSubscription<List<int>> sub;
  var stdinbroadcast = stdin.asBroadcastStream();
  sub = stdinbroadcast.listen((event) {
    String character = utf8.decode(event);
    if (character == '\x1B[D') {
      if (index >= 1) {
        --index;
        objects.setAll(0, initObjects);
        objects[index] = color.wrap(objects[index])!;
      }
      resetOptions(objects, separator);
    } else if (character == '\x1B[C') {
      if (index < (objects.length - 1)) {
        ++index;
        objects.setAll(0, initObjects);
        objects[index] = color.wrap(objects[index])!;
      }
      resetOptions(objects, separator);
    } else if (character == ' ') {
      if (!coloured.contains(index)) {
        coloured.add(index);
      } else {
        coloured.remove(index);
        objects.setAll(0, previousInit);
        objects = objects.map<String>((e) {
          if (coloured.contains(objects.indexOf(e))) {
            return color.wrap(e)!;
          } else {
            return e;
          }
        }).toList();
      }
      initObjects.setAll(0, objects);
      resetOptions(objects, separator);
    } else if (event.length == 1 && event[0] == 10) {
      if (!coloured.contains(index)) coloured.add(index);
      stdout.write(ending ?? "");
      stdin.lineMode = true;
      sub.cancel();
      completer.complete(coloured.map((e) => previousInit[e]));
    } else {
      resetOptions(objects, separator);
    }
  });

  return completer.future.then<Iterable<String>>((value) {
    return value;
  });
}
