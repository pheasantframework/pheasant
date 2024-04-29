// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
/// This library is not intended for use within this package, but is used by sibling packages like pheasant_build for the [createApp] function.
/// This is also the library used in all compiled pheasant files cached during development.
///
/// The reason this library is separate from [pheasant_temp] is becuase of unsupported libraries like "dart:html".
///
/// In this library, the base definition for [RavenTemplate] is defined here, and so is used for external functions or processes,
/// like the files built from the text returned by [renderFunc] and [renderMain], in order to make use of the functionality during build processes.
///
/// This library also contains the definitions for the `State` classes, which are used for state management.
/// The main classes used in the application are [TemplateState] and [AppState].
library pheasant_build;

export 'src/base.dart';
export 'src/routing/routing.dart';
export 'src/routing/unknown/unknown.dart';
export 'src/state/state.dart'
    hide
        StateTarget,
        ChangeEmitter,
        ChangeReceiver,
        ExtraFunctionality,
        TimedState;
export 'package:pheasant_meta/src/meta/pheasant_temp/props.dart'
    hide BuildAnnotationObject;
