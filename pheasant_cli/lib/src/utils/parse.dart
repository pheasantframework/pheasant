library pheasant_commands;

import 'package:args/args.dart';

/// General Parser for CLI Commands and arguments in the Pheasant CLI
/// The CLI Commands are wrapped in an [ArgParser].
ArgParser buildPheasantParser() {
  return ArgParser()
  // Generic Flags
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
      abbr: 'V',
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
        help: 'The directory to create your new project',
      )
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Applies "yes" to all "yes/No" questions asked for configuring the project.'
      )
      ..addFlag(
        'force',
        abbr: 'f',
        negatable: false,
        help: 'Force Creation of this Project.'
      )
    )

    ..addCommand(
      'create',
      ArgParser()
      ..addOption(
        'directory',
        abbr: 'd',
        valueHelp: 'directory',
        help: 'The directory to create your new project',
      )
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Applies "yes" to all "yes/No" questions asked for configuring the project.'
      )
      ..addFlag(
        'force',
        abbr: 'f',
        negatable: false,
        help: 'Force Creation of this Project.'
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
        abbr: 'r',
        help: 'Build with release mode for this app'
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'A directory to write the results of the build to.'
      )
    )

    ..addCommand(
      'run',
      ArgParser()
      ..addOption(
        'port',
        abbr: 'p',
        defaultsTo: '8080',
        help: 'The port to run the web app on.'
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'A directory to write the results of the build to.'
      )
      ..addFlag(
        'release',
        abbr: 'r',
        negatable: true,
        help: 'Whether to run the release version of the application.'
      )
      ..addFlag(
        'auto-restart',
        negatable: false,
        help: 'Whether to automatically restart the "main" function during rebuild.'
      )
      ..addFlag(
        'auto-refresh',
        negatable: false,
        help: 'Whether to automatically make a full page refresh during rebuild.'
      )
    )

    ..addCommand(
      'serve',
      ArgParser()
      ..addOption(
        'port',
        abbr: 'p',
        defaultsTo: '8080',
        help: 'The port to run the web app on'
      )
      ..addFlag(
        'auto-restart',
        negatable: false,
        help: 'Whether to automatically restart the "main" function during rebuild.'
      )
      ..addFlag(
        'auto-refresh',
        negatable: false,
        help: 'Whether to automatically make a full page refresh during rebuild.'
      )
    )
    ;
}
