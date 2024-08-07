// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org


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
