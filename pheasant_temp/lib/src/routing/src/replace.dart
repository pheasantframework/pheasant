// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'dart:js_interop';

@JS('history.replaceState')
external void _replaceState(JSObject? state, String? title, String path);

/// Function used in replacing state
void replaceState(Object? state, String? title, String path) {
  _replaceState(
      state == null ? JSObject() : state.jsify() as JSObject, title, path);
}
