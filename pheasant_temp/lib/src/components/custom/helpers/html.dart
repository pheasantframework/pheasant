// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

import 'dart:html';

import 'package:markdown/markdown.dart' as md;

Element html(String html,
    {String parent = 'div', Map<String, String> attributes = const {}}) {
  return _html(parent, html, attributes);
}

Element _html(String parent, String html, Map<String, String> attributes) {
  return Element.tag(parent)
    ..innerHtml = html
    ..attributes = attributes;
}

Element markdown(String markdown,
    {String parent = 'div', Map<String, String> attributes = const {}}) {
  return _md(parent, markdown, attributes);
}

Element _md(String parent, String markdown, Map<String, String> attributes) {
  return Element.tag(parent)
    ..innerHtml = md.markdownToHtml(markdown)
    ..attributes = attributes;
}
