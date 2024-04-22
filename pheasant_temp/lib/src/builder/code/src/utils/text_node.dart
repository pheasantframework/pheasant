import 'package:html/dom.dart' show Node;

String textNodeRendering(
    Node element, String beginningFunc, String elementName) {
  if ((element.text ?? '').contains(RegExp(r'\{\{([^\}]+)\}\}'))) {
    // Remove interpolation and add desired value
    final regex = RegExp(r'\{\{([^\}]+)\}\}');
    element.text = '${element.text?.splitMapJoin(
      regex,
      onMatch: (m) => '\${${m[1]}}',
    )}';
  } else if ((element.text ?? '').contains(RegExp(r'\{([^\}]+)\}'))) {
    // Remove interpolation and add desired value
    final regex = RegExp(r'\{([^\}]+)\}');
    element.text = '${element.text?.splitMapJoin(
      regex,
      onMatch: (m) => '\${${m[1]}}',
    )}';
  }
  beginningFunc += '$elementName.append(_i2.Text("""${element.text}"""));';
  return beginningFunc;
}
