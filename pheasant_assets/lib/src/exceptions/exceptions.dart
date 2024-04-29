// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'package:pheasant_meta/pheasant_meta.dart' show PheasantException;

/// Pheasant Style Implementation of [PheasantException] for use in this package
/// When build runs, and an exception occurs, the [message] is printed out to the build cli, as seen in the [toString] override.
class PheasantStyleException extends PheasantException {
  /// Default Constructor
  PheasantStyleException(super.message);

  /// Prints out the error message
  @override
  String toString() {
    return "Pheasant Style Exception: $message";
  }
}
