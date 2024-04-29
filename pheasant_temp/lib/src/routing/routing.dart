// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'dart:async';
import 'dart:html';

import 'package:pheasant_meta/pheasant_meta.dart';
import 'package:pheasant_temp/src/routing/src/route.dart';
import 'package:pheasant_temp/src/routing/src/shared/current_path.dart';
import 'unknown/unknown.dart';
import 'package:pheasant_temp/src/base.dart';
import 'package:pheasant_temp/src/state/state.dart';

export 'src/route.dart';

/// The class used for obtaining and setting the current route on the website
///
/// This class contains functionality for receiving changes to the current route ofthe pages and is used in route views in order to get the current component for the given route view.
@sealed
class GlobalRoute {
  // Prevent instantiation
  GlobalRoute._();

  static String _currentRoute = '/';

  /// Get the current route of the page
  static String get currentRoute => _currentRoute;

  /// Used to set the current route of the page
  ///
  /// Do not use this directly, it is used by the compiler.
  static set currentRoute(String newRoute) {
    _currentRoute = newRoute;
    _controller.add(newRoute);
  }

  static final _controller = StreamController<String>.broadcast();

  /// The stream used to subscribe to global route changes
  static Stream<String> get _sub => _controller.stream;

  static getChanges(Element element, [TemplateState? state]) {
    GlobalRoute._sub.listen((event) {
      _routeChanged(element, event, state);
    });
  }
}

/// Get the current route of the page
String get currentRoute => GlobalRoute.currentRoute;

/// A Router object used in creating/instantiating a new router.
///
/// A router is used in registering new routes and the corresponding components to be used in the given routes. A router is used for basic routing in an application to move between pages.
/// Whenever the route of a page changes, the router issues the given [PheasantTemplate] for the new page and transmits it to any components with the `p-route:view` directive to render the given component in place of the view.
///
/// The router object consists of the [initialRoute] of the application, and the [routes] that the router uses, which is a list of [RouteBase].
///
/// ```dart
/// var router = Router(
///   initialRoute: '/',
///   routes: <RouteBase>[
///     Route(
///       path: '/',
///       // References the generated component for the given file at that path
///       component: RouteTo('src/Body.phs')
///     )
///   ]
/// );
/// ```
class Router {
  /// The global routes set by the application
  static Map<String, PheasantTemplate> globalRoutes = {};

  /// The initial route set by the router
  final String initialRoute;

  /// The routes registered for this router
  Iterable<RouteBase> routes;

  /// The routes and their corresponding components as a [Map]
  Map<String, PheasantTemplate> get mappedRoutes =>
      {for (var r in routes) r.path: r.component};

  Router({this.initialRoute = '/', this.routes = const []});
}

/// A base class representation of a Route
///
/// Every route must contain a [path], the url to the route,
/// and a corresponding [component] to be rendered at that [path]
abstract class RouteBase {
  /// The path for the route
  String path;

  /// The component to be rendered at the route
  PheasantTemplate component;

  RouteBase({required this.path, required this.component});
}

/// A Route used in standard Routing in a Pheasant Application
class Route extends RouteBase {
  Route({
    required super.path,
    required super.component,
  });
}

/// Function used to get the current route of the application
///
/// This is meant to be a much more desirable api to get the current route than referencing the router itself.
PheasantTemplate getCurrentRoute([String? path]) {
  return Router.globalRoutes[path ?? GlobalRoute.currentRoute] ??
      UnknownPheasantTemplate();
}

/// Function called whenever the route changes in an application
void _routeChanged(Element target, [String? path, TemplateState? state]) {
  PheasantTemplate? routeComponent = getCurrentRoute(path);
  target
      .querySelector('#router-view')!
      .children
      .first
      .replaceWith(routeComponent.render(routeComponent.template!, state));
}

/// Function used to set pop/backward state during page routing
///
/// The function is used to update the [GlobalRoute.currentRoute] with the new route when moving back a page in a Pheasant Application.
void setpopState() {
  onBack((event) {
    GlobalRoute.currentRoute = currentPath;
  });
}
