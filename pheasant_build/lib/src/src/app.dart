// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org


import 'package:pheasant_build/src/src/render.dart';
import 'package:pheasant_temp/pheasant_build.dart';

/// A base Pheasant Application. This can be used instead of the [createApp] function to extend your application and its functionality, like by adding routers.
///
/// This base class shouldn't be used directly by the user, but can be used via the plugins API for adding functionality to your application either via extending this class or by adding extensions.
///
/// Every Pheasant Application has a [build] method, which builds the application and then renders it into the DOM.
abstract class PheasantBaseApp {
  /// The Application as a [PheasantTemplate] (i.e as the `App` getter or your Application Component)
  PheasantTemplate app;

  /// The state of the application as [AppState]
  AppState state;

  PheasantBaseApp(this.app, {AppState? appState})
      : state = appState ??
            AppState(component: app, watchers: List.empty(growable: true));

  /// Builds the pheasant application and renders it into the dom.
  /// Specify [selector] to choose to render to a specific component like one with an `id` of `"out"` (`"#out"`). Defaults to `"#output"`.
  void build([String selector = '#output']) {
    createApp(app, appState: state, selector: selector);
  }
}

/// The Standard Pheasant Application used in creating and rendering applications in a Pheasant Web App.
///
/// This is the MVP Application object used for basic, and plugin-less rendering of pheasant applications.
///
/// ```dart
/// import 'package:pheasant/pheasant.dart';
/// ...
/// void main() {
///   final app = PheasantApp();
///   // Builds application and attaches to "#output" by default on DOM.
///   app.build();
/// }
/// ```
///
/// For configuration, you can either extend this class with extensions, or for more complicated functionality inherit [PheasantBaseApp].
/// Check the docs for more info on this.
class PheasantApp extends PheasantBaseApp {
  /// Used to set the router for the pheasant application.
  set router(Router newRouter) {
    Router.globalRoutes = newRouter.mappedRoutes;
    setpopState();
    initPage(newRouter.initialRoute);
  }

  PheasantApp(super.app, {super.appState});

  /// Constructor used to initialise a Pheasant Application, as well as with a router.
  PheasantApp.router(super.app, {required Router router, super.appState}) {
    this.router = router;
  }
}
