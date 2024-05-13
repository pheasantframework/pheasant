// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


/// The major and general library containing all functionality to parse, scope and process css/sass in a Pheasant Component
///
/// This library helps with the parsing, analyzing, rendering and scoping of styles located in the `styles` part of a pheasant file.
///
/// The library includes support for not only css, but also for scss and sass.
/// If you want to use a different preprocessor, you may want to look at the npm version of this project. Check it out for how you can add support for other css preprocessors.
///
/// Support for sass and scss is built in (you won't need to configure support for it).
///
/// Every `style` component has three options - `syntax`, `src` (if the data is in a separate file) and then the scope: `global` or `local`.
///
/// All styles are first parsed an analayzed as [PheasantStyle] objects, then scoped and rendered as [PheasantStyleScoped] objects
library pheasant_assets;

export 'src/assets.dart';
export 'src/compile/compile.dart';
export 'src/compile/scope.dart';
export 'src/compile/parse.dart';
export 'src/exceptions/errors.dart';
export 'src/exceptions/exceptions.dart';
