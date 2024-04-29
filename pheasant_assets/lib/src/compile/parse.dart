// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.

import 'package:pheasant_assets/pheasant_assets.dart';

import '../assets.dart' hide PheasantStyleScoped;

/// Code to extract a [PheasantStyle] from a `style` component in a pheasant file.
///
/// The function extracts relevant information about the component using the [RegExp].
/// The data from the opening tag and the internal data is then processed and then used to create a new [PheasantStyle] object.
///
/// If [sassEnabled] is set to true, then the `syntax` of the [PheasantStyle] can be adjusted. Else, the `syntax` is set to `"css"` despite what may have been denoted in the style tag.
/// By default, [sassEnabled] is set to `true`.
PheasantStyle getStyleInput(String style, {bool sassEnabled = true}) {
  RegExp regex = RegExp(
    r'<style\s*' // Match the opening tag '<style' and one or more whitespaces
    r'(?:src="([^"]*)")?\s*' // Optional src attribute and its value
    r'(?:syntax="([^"]*)")?\s*' // Optional syntax attribute and its value
    r'(?:(local|global))?' // Optional local attribute
    r'>', // Match the closing angle bracket '>'
  );
  if (!style.contains(regex)) {
    throw PheasantStyleException("There seems to be an error in the source parsed. There's no <style> opening tag");
  }
  if (!style.contains("</style>")) {
    throw PheasantStyleException("There seems to be an error in the source parsed. There's no <style> closing tag");
  }
  Match mainMatch = regex.allMatches(style).first;
  String data =
      style.replaceFirst(regex, '').replaceFirst('</style>', '').trim();
  return sassEnabled
      ? PheasantStyle.sassEnabled(
          syntax: mainMatch[2] ?? 'css',
          src: mainMatch[1],
          data: data.isEmpty ? null : data,
          scope:
              mainMatch[3] == 'global' ? StyleScope.global : StyleScope.local)
      : PheasantStyle(
          src: mainMatch[1],
          data: data.isEmpty ? null : data,
          scope:
              mainMatch[3] == 'global' ? StyleScope.global : StyleScope.local);
}
