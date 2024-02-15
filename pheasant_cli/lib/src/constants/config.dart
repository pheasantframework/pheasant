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
