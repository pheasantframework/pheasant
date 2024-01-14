Map<String, String> get cmdInfo => {
  'init': 'Create or start a new Pheasant project',
  'doctor': 'Ensures all requirements and prerequisites are met to run the framework',
  'create': 'Alias for "init"',
  'help': 'Get help for any command',
  'run': 'Run a project from the server',
  'serve': 'Alias for "run"',
  'build': 'Build a project for deployment',
  'test': 'Run tests for the pheasant project'
};

Map<String, String> get cmdDetailed => {
  'doctor': '''Check for any issues that may inhibit the working of the framework. 
  Ensures all requirements and prerequisites are met to run the framework.'''
};