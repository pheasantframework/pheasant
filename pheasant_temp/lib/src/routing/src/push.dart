// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'dart:js_interop';

import 'shared/helpers.dart';

@JS('history.pushState')
external void _pushState(JSObject? state, String? title, String path);

@JS('history.state')
external JSObject get _histState;

/// Function used in pushing state
void pushState(Object? state, String? title, String path) {
  _pushState(
      state == null ? JSObject() : state.jsify() as JSObject, title, path);
}

/// Function used in getting current state data.
dynamic getStateData() {
  return _histState.toDartMap;
}
