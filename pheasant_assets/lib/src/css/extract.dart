// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import '../assets.dart' show PheasantStyle;
import '../compile/compile.dart';
import '../exceptions/exceptions.dart';

/// Function used to extract and compile css.
/// It gets the required parameters needed for specific compilation from the [PheasantStyle] object, and uses it to compile the css.
///
/// Throws a [PheasantStyleException] if exception occurs (if `data` and `src` are both null).
String css(PheasantStyle pheasantStyle,
    {bool dev = false, String appPath = 'lib', bool sassEnabled = false}) {
  String styleData = pheasantStyle.data ?? "";
  if (pheasantStyle.data == null) {
    if (pheasantStyle.src == null) {
      return '';
    } else {
      styleData = compileSassFile(pheasantStyle, pheasantStyle.src!,
          devDirPath: dev ? 'example' : null,
          componentDirPath: appPath,
          sassEnabled: sassEnabled);
      return styleData;
    }
  }
  return compileCss(pheasantStyle, styleData, sassEnabled: sassEnabled);
}
