# Routing 
The Pheasant Framework includes built-in support for single-page application routing out of the box. That way you can have fast and efficient page routing in your application.

```dart
import '<name>.routes.dart';

import '<name>.routes.dart' show RouteTo;
```

```dart
RouteTo()
```

```dart
var router = Router(
    initialLocation: '/',
    routes: <RouteBase>[
        Route(
            path: '/',
            component: RouteTo('src/Body.phs') // Using standard .phs files. 
            // You must add "import '<name>.routes.dart';" to use this function.
        ),
        Route(
            path: '/files',
            component: MyComponent(); // Importing/Using custom components
        )
    ]
)
```

TODO: Complete Documentation