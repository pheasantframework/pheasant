// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'package:build_test/build_test.dart';
import 'package:pheasant_build/src/build/src/pheasant_file_builder.dart';
import 'package:test/test.dart';

import 'package:pheasant_build/src/build/src/pheasant_router_builder.dart'
    show PheasantRouterBuilder;

void main() {
  group('normal builder', () {
    test('router builder', () async {
      var assets = {
        'a|lib/source.dart': '''
          import 'package:pheasant/router.dart';

          import 'source.routes.dart' show RouteTo;

          var routes = Router(
            initialLocation: '/',
            routes: [
              Route(
                path: '/',
                component: RouteTo('src/App.phs')
              )
            ]
          );
        '''
      };

      await testBuilder(PheasantRouterBuilder(), assets, onLog: print);
    });

    test('render file', () async {
      var assets = {
        'a|lib/App.phs': '''
<template>
<div>
    <h2>Hello World</h2>
    <p>Welcome to the first test</p>
</div>
</template>
''',
        'b|lib/App.phs': '''
<script>
int number = 9;
</script>

<template>
<div>
    <div p-for="int i = 0; i < number; ++i">
        <p>My number {i}</p>
    </div>
    <div>
        <p>Hello World Again</p>
    </div>
</div>
</template>
'''
      };

      await testBuilder(
        PheasantFileBuilder(sass: true, js: true),
        assets,
        onLog: print,
      );
    });

    test('main file', () async {
      return null;
    });
  });
}
