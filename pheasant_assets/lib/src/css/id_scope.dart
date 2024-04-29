// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import '../assets.dart' hide StyleScope;

/// Small function to help in the creation of ids used to identify and scope component styles in a pheasant component.
///
/// This function is used in the conversion of styles from [PheasantStyle] to [PheasantStyleScoped].
///
/// The id produced is unique to each component.
String makeId(PheasantStyle pheasantStyle) {
  String pheasantPrefix = "phs-";
  String specialid = ".$pheasantPrefix${pheasantStyle.hashCode}";
  return specialid;
}
