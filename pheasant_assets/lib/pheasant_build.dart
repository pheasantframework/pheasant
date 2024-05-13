// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


/// Minified version of the general `pheasant_assets` library for use during build.
///
/// This library is usually used in the `pheasant_build` package, but you can use it for simple and quick encapsulation of asset processing code.
///
/// This library gives the functionality needed to run the pheasant web app on the web without importing VM functionality, which could prevent the app from not running.
library pheasant_assets_build;

export 'src/assets.dart';
export 'src/compile/parse.dart';
