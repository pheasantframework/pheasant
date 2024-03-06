// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may not use this file except in compliance with the License.
  
String? extractExpressionInBrackets(String input) {
  RegExp regExp = RegExp(
      r'\((.*?)\)'); // Regular expression to match content within parentheses

  Match? match = regExp.firstMatch(input);

  if (match != null) {
    return match.group(1); // Group 1 contains the content within parentheses
  } else {
    return null; // No match found
  }
}
