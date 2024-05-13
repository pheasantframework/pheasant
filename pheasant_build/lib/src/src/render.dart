// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


import 'dart:html' show Element, querySelector;

import 'package:pheasant_temp/pheasant_build.dart'
    show PheasantTemplate, AppState, ElementChangeWatcher;

/// Function used to encapsulate the injection of the processed [PheasantTemplate] into the DOM
///
/// This function injects the [PheasantTemplate] into the DOM, and makes use of the [AppState] to watch for changes in the [app].
/// Whenever a change is emitted, the application is rerendered in the DOM.
///
/// If [appState] is not provided, then the state is generated in the beginning of the app lifecycle.
void _renderElement(PheasantTemplate app,
    {AppState? appState, String? selector}) {
  AppState state = appState ??
      AppState(component: app, watchers: List.empty(growable: true));
  PheasantTemplate appObj = app;
  Element elementApp = appObj.render(appObj.template!, state);
  querySelector(selector ?? '#output')?.children.add(elementApp);

  state.stateStream.listen(
    (event) {
      elementApp = appObj.render(appObj.template!, state);
      querySelector(selector ?? '#output')?.children.first = elementApp;
      state.watchers
          .whereType<ElementChangeWatcher>()
          .forEach((element) => element.reflectChanges());
    },
  );
}

/// Function used to create a Pheasant Application
///
/// The function accepts a pheasant file object - [PheasantTemplate] - and then processes the application.
/// Once it is done, then it is injected into the DOM.
void createApp(PheasantTemplate pheasantTemplate,
    {AppState? appState, String? selector}) {
  _renderElement(pheasantTemplate, appState: appState);
}
