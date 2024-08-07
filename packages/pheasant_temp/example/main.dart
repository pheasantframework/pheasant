// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org


import 'package:pheasant_temp/pheasant_temp.dart';

void main() {
  print(compilePhs(script: """
import './Component.phs' as Component;
import '../fruit/fruit.phs' as fruit;

var number = 9;

List<int> nums = [1, 2, 3, 4];

void addNum() {
  number++;
}

void subtractNum() {
  number -= 1;
}

@JS('console.log')
external void log(String data);

""", template: """
<div class="foo" p-for="var value in nums">
  Welcome to Pheasant
  <p>Hello World {{number}}</p>
  <a href="#" class="fee" id="me">Click Here</a>
  <p>Aloha</p>
  <p>{{nums[0]}}</p>
  <fruit class="fred" id="foo"/>
  <md>
# Hello
Welcome to the Pheasant Template Example Base
It's quite fun here, and this text here was actually originally markdown.
We can write single `code` and multiblock code like this
```dart
void main() {
  print("Hello World");
}
```
  </md>
  <Component />
</div>
""", buildExtension: '.phs.dart', appDirPath: "App.phs"));
  print(renderMain());
}
