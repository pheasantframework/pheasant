// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
/// A temporary class containing the new `beginningFunc` String [value] and the new `closebracket` integer [number].
///
/// This class is not intended for public use and is only for one singular purpose - to get a return value for the `pheasantAttributes` function
class TempPheasantRenderClass extends _PheasantTempClass {
  int number;
  String value;

  TempPheasantRenderClass({required this.number, required this.value});
}

class _PheasantTempClass {}
