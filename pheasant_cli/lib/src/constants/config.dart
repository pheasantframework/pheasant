// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may not use this file except in compliance with the License.
  
Map<String, dynamic> get pheasantDemo => {
      'project': 'projName',
      'version': '1.0.0',
      'env': 'dart',
      'entry': {'main': 'web/main.dart', 'app': 'lib/App.phs'},
      'config': {
        'sass': true,
        'js': true,
        'linter': true,
        'formatter': true,
        'phsComponents': true
      },
      'plugins': [
        {
          'pheasant-router': {'version': '1.0.0'}
        },
        {
          'pheasant-styles': {'version': '1.0.0'}
        },
      ],
      'dependencies': [
        {
          'pheasant-lints': {'version': '1.0.0'}
        },
        {
          'pheasant-wasm': {'version': '1.0.0'}
        },
      ]
    };
