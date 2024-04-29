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
