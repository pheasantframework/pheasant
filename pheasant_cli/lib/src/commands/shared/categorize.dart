// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.  
// You may use this file only in accordance with the license.
// https://mit-license.org

import 'package:io/ansi.dart';

String categorize(String str) => wrapWith(str.replaceFirst(str[0], str[0].toUpperCase()), [styleBold, styleUnderlined])!;
