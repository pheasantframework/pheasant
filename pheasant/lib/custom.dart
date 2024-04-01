// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.  
// You may use this file only in accordance with the license.
// https://mit-license.org

/// The Pheasant Framework Plugins/Custom Components API
///
/// This is the library for creating and defining custom functionality for your Pheasant Application.
/// With this library, you can make your own plugins for others to use (check [this link](https://github.com/pheasantframework/pheasant/blob/main/docs/custom/introduction.md) for a guided introduction), or add some custom functionality to your application.
///
/// Currently, the custom API includes support for the following:
/// - Creating your own Custom Components to use in Pheasant Files and Applications via the [PheasantComponent] class.
/// - Extending your Pheasant Application to include custom functionality such as custom routing via the [PheasantBaseApp] and [PheasantApp] classes.
///
/// In the neartime future, we plan to support some other functionality.
library custom;

export 'package:pheasant_temp/pheasant_custom.dart'
    show PheasantComponent, html;
export 'dart:html';
export 'package:pheasant_temp/pheasant_build.dart' show TemplateState, State;
export 'package:pheasant_build/pheasant_build.dart'
    show PheasantApp, PheasantBaseApp;
