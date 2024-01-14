library pheasant_commands;

import 'package:args/args.dart';

/// General Parser for CLI Commands and arguments in the Pheasant CLI
/// The CLI Commands are wrapped in an [ArgParser].
ArgParser buildPheasantParser() {
  return ArgParser()
  /// Generic Flags
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the tool version.',
    )

    ..addFlag(
      'verbose',
      negatable: false,
      help: 'Print more defined info during commands'
    )

    ..addMultiOption(
      'define',
      abbr: 'D',
      splitCommas: true,
      help: 'Define and/or override configuration variables'
    )

    ..addCommand(
      'help',
      ArgParser()
      ..addFlag(
        'detailed',
        abbr: 'd',
        negatable: false,
        help: 'Produce Detailed help for this command'
      )
    )

    ..addCommand(
      'init',
      ArgParser()
      ..addOption(
        'directory',
        abbr: 'd',
        valueHelp: 'directory',
        // defaultsTo: '.',
        help: 'The directory to create your new project',
      )
    )

    ..addCommand(
      'create',
      ArgParser()
      ..addOption(
        'directory',
        abbr: 'd',
        valueHelp: 'directory',
        // defaultsTo: '.',
        help: 'The directory to create your new project',
      )
    )

    ..addCommand(
      'doctor',
      ArgParser()
      ..addFlag(
        'verbose',
        negatable: false,
        help: 'Print more defined info during commands'
      )
    )

    ..addCommand(
      'build',
      ArgParser()
      ..addFlag(
        'release',
        help: 'Build release version of this app'
      )
    )

    ..addCommand(
      'run',
      ArgParser()
      ..addOption(
        'port',
        abbr: 'p',
        defaultsTo: '8080',
        valueHelp: '8080',
        help: 'The port to run the web app on'
      )
      ..addFlag(
        'release',
        negatable: false,
        help: 'Whether to run the release version of the application.'
      )
    )

    ..addCommand(
      'serve',
      ArgParser()
      ..addOption(
        'port',
        abbr: 'p',
        defaultsTo: '8080',
        valueHelp: '8080',
        help: 'The port to run the web app on'
      )
    )
    ;
}
