import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

import 'package:pheasant_build/src/build/src/pheasant_router_builder.dart'
    show PheasantRouterBuilder;

void main() {
  group('router builder', () {
    test('build routes internal', () async {
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
  });
}
