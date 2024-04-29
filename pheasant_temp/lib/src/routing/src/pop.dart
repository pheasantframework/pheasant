import 'dart:html';

void _onPageChange(void Function(Event event) func, [bool? useCapture]) {
  return window.addEventListener(
      'popstate', (event) => func(event), useCapture);
}

void onBack(void Function(Event event) func) => _onPageChange(func);
