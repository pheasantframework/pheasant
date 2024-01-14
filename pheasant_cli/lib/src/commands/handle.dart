import 'package:args/args.dart';

import 'general/welcome.dart';
import 'commands.dart';

void handleCommand(ArgResults argResults, ArgParser argParser) {
  if (argResults.command == null) {
    welcome(argParser);
  }
  if (argResults.command?.name == 'init' || argResults.command?.name == 'create') {
    initCommand(argResults);
  }
  if (argResults.command?.name == 'doctor') {
    doctorCommand(argResults);
  }
  if (argResults.command?.name == 'help') {
    helpCommand(argResults, argParser);
  }
  if (argResults.command?.name == 'run' || argResults.command?.name == 'serve') {
    runCommand(argResults);
  }

}
