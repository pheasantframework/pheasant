// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'dart:js_interop';

/// Get the current path of the page
@JS('window.location.pathname')
external String get currentPath;
