import 'dart:html';

import '../../base.dart';
import '../../state/state.dart';

/// A base implementation for any unknown component, mostly used as a displayable error message.
class UnknownPheasantTemplate extends PheasantTemplate {
  UnknownPheasantTemplate() : super(template: "");

  @override
  Element render(String temp, [TemplateState? state]) {
    return _errorMessage();
  }

  DivElement _errorMessage() =>
      DivElement()..text = "This Component Does not Exist";
}
