import 'dart:js_interop';

@JS('history.go')
external void _go(int index);

void _routeTo(int index) => _go(index);

/// Function used to refresh the current page
void refreshPage() => _routeTo(0);
