// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org

@Timeout(Duration(seconds: 1))

import 'dart:developer';

import 'package:pheasant_assets/pheasant_assets.dart';
import 'package:pheasant_temp/pheasant_temp.dart';
import 'package:test/test.dart';

class PheasantTestObject {
  String script;
  String template;
  String style;

  PheasantTestObject(this.script, this.template, this.style);
}

void main() {
  log('Pheasant Benchmark Tests for: renderMain');
  group('speed test', () {
    List<String> results = List<String>.filled(5, '');
    List<PheasantTestObject> inputs = [
      PheasantTestObject("", "", ""),
      PheasantTestObject(
          "var number = 9;", "<div><p>{{number}}</p><p>Hello</p></div>", ""),
      PheasantTestObject("""
import 'display.phs' as display;

@JS('window.alert')
external void alert(String object);
""", """
<div>
    <display p-bind:count="9" />
    <p>Hello</p>
    <button p-on:click="alert('hello')">Hello there</button>
</div>
""", ""),
      PheasantTestObject("""
@prop
int count;

int number = 9;
""", """
<center>
    <button p-on:click="count++" onClick="console.log('Hello')">+</button>
    <div class="foo"><p>{{count}}</p></div>
    <button p-on:click="count--">-</button>
    <p>{{number}}</p>
</center>
""", """
@import url('https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;1,300&family=Roboto+Mono:wght@200&display=swap');

\$font: 'Lato';
\$monoFont: 'Roboto Mono';
\$primary-color: red;

.foo {
    color: rgb(245, 193, 66);
    align-content: flex-start;
    font-family: \$font, sans-serif;

    a {
        color: silver;
        font-style: italic;
        font-weight: 300;
    }

    p {
        font-weight: 100;
    }

    code {
        font-family: \$monoFont, monospace;
    }
}

div {
    align-items: flex-start;
    text-align: left;
    align-self: start;
}
"""),
      PheasantTestObject("""
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

""", """
<div class="foo">
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
    log("Hello World");
  }
  ```
  </md>
  <Component />
</div>
""", """
.foo {
  color: red;
}
""")
    ];

    test('speed run', () {
      final Stopwatch stopwatch = Stopwatch()..start();

      results[0] = compilePhs(
          script: inputs[0].script,
          template: inputs[0].template,
          pheasantStyle: PheasantStyle(data: inputs[0].style));
      log('Result 1: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[1] = compilePhs(
          script: inputs[1].script,
          template: inputs[1].template,
          pheasantStyle: PheasantStyle(data: inputs[1].style));
      log('Result 2: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[2] = compilePhs(
          script: inputs[2].script,
          template: inputs[2].template,
          pheasantStyle: PheasantStyle(data: inputs[2].style));
      log('Result 3: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[3] = compilePhs(
          script: inputs[3].script,
          template: inputs[3].template,
          pheasantStyle:
              PheasantStyle.sassEnabled(data: inputs[3].style, syntax: 'scss'),
          sass: true);
      log('Result 4: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();

      results[4] = compilePhs(
          script: inputs[4].script,
          template: inputs[4].template,
          pheasantStyle:
              PheasantStyle(data: inputs[4].style, scope: StyleScope.global));
      log('Result 5: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.stop();
    });
  });
}
