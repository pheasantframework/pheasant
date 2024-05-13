// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org


import 'dart:html';

void _onPageChange(void Function(Event event) func, [bool? useCapture]) {
  return window.addEventListener(
      'popstate', (event) => func(event), useCapture);
}

void onBack(void Function(Event event) func) => _onPageChange(func);
