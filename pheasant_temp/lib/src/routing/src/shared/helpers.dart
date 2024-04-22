import 'dart:convert';
import 'dart:js_interop';

@JS('JSON.stringify')
external String _stringify(JSObject object);

extension MapObj on JSObject {
  dynamic get toDartMap => json.decode(_stringify(this));
}
