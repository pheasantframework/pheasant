import 'dart:io';
import 'package:args/args.dart';
import 'package:io/ansi.dart';

Map<String, Type> get questions => <String, Type>{
      "Would you like to use a CSS Preprocessor (Sass)?": bool,
      "Would you like to add JS?": bool,
      "Would you like to add support for Pheasant Components?": bool,
      "Would you like to enable Dart Linting Rules?": bool,
      "Would you like to enable Dart Formatting?": bool
    };

Map<String, dynamic> answers = Map.fromIterable(questions.keys);

void initInterface(ArgResults results) {
  if (results.command!.wasParsed('yes')) {
    answers.updateAll((key, value) => true);
  } else {
    questions.forEach((key, value) {
      stdout.writeAll(
          [lightBlue.wrap(key)!, styleBold.wrap(value == bool ? '(y/N) ' : '')],
          " ");
      final ans = stdin.readLineSync();
      if (ans == null) {
        answers[key] = false;
      } else {
        answers[key] = ans == 'y';
      }
    });
  }
  stdout.writeln();
}
