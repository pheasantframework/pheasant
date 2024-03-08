// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may not use this file except in compliance with the License.
  
Map<String, String> get cmdInfo => {
      'init': 'Create or start a new Pheasant project',
      'doctor':
          'Ensures all requirements and prerequisites are met to run the framework',
      'create': 'Alias for "init"',
      'help': 'Get help for any command',
      'run': 'Run a project from the server',
      'serve': 'Alias for "run"',
      'build': 'Build a project for deployment',
      'test': 'Run tests for the pheasant project',
      'add': 'Add Plugins/Dependencies to your project'
    };

Map<String, String> get cmdDetailed => {
      'doctor':
          '''Check for any issues that may inhibit the working of the framework. 
  Ensures all requirements and prerequisites are met to run the framework.'''
    };
