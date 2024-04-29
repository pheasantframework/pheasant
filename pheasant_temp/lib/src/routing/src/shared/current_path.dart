import 'dart:js_interop';

/// Get the current path of the page
@JS('window.location.pathname')
external String get currentPath;
