// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


import 'package:analyzer/dart/ast/ast.dart' show ImportDirective;

/// Function to get the items placed in a `show` combinator in an import directive.
///
/// Returns a List of Strings which represent the items being 'shown' in the [ImportDirective]
List<String> getShowCombinators(ImportDirective directive) {
  List<String> items = <String>[];
  for (final item in directive.combinators) {
    if (item.keyword.toString() == 'show') {
      String stringList = item.toSource().replaceFirst('show ', '');
      items.addAll(stringList.split(', '));
    }
  }
  return items;
}

/// Function to get the items placed in a `hide` combinator in an import directive.
///
/// Returns a List of Strings which represent the items being 'hidden' in the [ImportDirective]
List<String> getHideCombinators(ImportDirective directive) {
  List<String> items = <String>[];
  for (final item in directive.combinators) {
    if (item.keyword.toString() == 'hide') {
      String stringList = item.toSource().replaceFirst('hide ', '');
      items.addAll(stringList.split(', '));
    }
  }
  return items;
}
