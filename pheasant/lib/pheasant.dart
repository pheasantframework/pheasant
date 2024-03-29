// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may not use this file except in compliance with the License.

/// The library used in all main entrypoints of a pheasant application.
///
/// The only function exposed by this library is the `createApp` function, used to "create" the application.
///
/// NOTE: In further versions, there will be more libraries to expose other APIs such as plugin support, custom component supports and custom library support.
library pheasant;

export 'package:pheasant_build/pheasant_build.dart' show createApp, PheasantApp;
