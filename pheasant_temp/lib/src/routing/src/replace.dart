import 'dart:js_interop';

@JS('history.replaceState')
external void _replaceState(JSObject? state, String? title, String path);

/// Function used in replacing state
void replaceState(Object? state, String? title, String path) {
  _replaceState(
      state == null ? JSObject() : state.jsify() as JSObject, title, path);
}
