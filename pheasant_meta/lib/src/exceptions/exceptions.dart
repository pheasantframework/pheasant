// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


/// Base class for an exception in the Pheasant Framework
class PheasantException implements Exception {
  final dynamic message;

  PheasantException([this.message]);

  @override
  String toString() {
    return message;
  }
}

/// Base class for an error in the Pheasant Framework
class PheasantError extends Error {
  final dynamic what;

  PheasantError({this.what = ""});

  factory PheasantError.unsupported(String message) =>
      PheasantUnsupportedError(message);

  factory PheasantError.unimplemented() => PheasantUnimplementedError();
}

/// Implementation of Unsupported Error in the Pheasant Framework
class PheasantUnsupportedError extends UnsupportedError
    implements PheasantError {
  PheasantUnsupportedError(super.message);

  @override
  get what => message;
}

/// Implementation of Unimplemented Error in the Pheasant Framework
class PheasantUnimplementedError extends UnimplementedError
    implements PheasantError {
  PheasantUnimplementedError([String? message]) {
    if (message != null) what = message;
  }

  set what(String msg) => what = msg;
  @override
  String get what => "No implementation";
}
