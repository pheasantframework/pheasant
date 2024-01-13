# Pheasant

![Pub Version](https://img.shields.io/pub/v/pheasant?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant) ![Pub Publisher](https://img.shields.io/pub/publisher/pheasant?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant)

Pheasant is a modern-day, progressive, fast-reload, powerful frontend web framework written, and operated with in the Dart Language, with support for JavaScript. It grants all the features of modern web development (Web Components, HTML Rendering and more) with the dynamic power of Dart.

```
<script>
int myNum = 9;

void addNum() {
    myNum++;
}
</script>

<template>
<div id="output">
    <p>Hello World, Welcome to Pheasant</p>
    <p>{{myNum}}</p>
</div>
</template>

<style syntax="scss">
$primary-color: red;

#output {
    font-family: verdana;
    color: blue;
    background-color: powderblue;
}

p {
    color: $primary-color;
}
</style>
```
## New to Pheasant?
Get started quickly and take the next step to making your greatest apps with [this guide](). 

<!-- JS Support Not ready yet -->
<!-- If you are a JavaScript Developer, you can check out [here]() on how to make use of this framework with the power of dart and javascript together -->

## How Does It Work?
Pheasant works by rendering components in `.phs` files. These files consist of three parts: 
1. The **template** which contains html-like syntax, backed in with special pheasant components to help easily and dynamically render code in your web app
```html
<template>
<div id="output">
    <p>Hello World, Welcome to Pheasant</p>
    <p>{{myNum}}</p>
</div>
</template>
```
2. The **script** which contains Dart data located inside it, which can be used in the **template** part for rendering
```dart
<script>
int myNum = 9;

void addNum() {
    myNum++;
}
</script>
```

3. The **style** which contains either global or local styling for the **template** components
```scss
<style syntax="scss">
$primary-color: red;

#output {
    font-family: verdana;
    color: blue;
    background-color: powderblue;
}

p {
    color: $primary-color;
}
</style>
```

## Using this Package
This package is very minimal, and depends on the functionality of it's children packages - [pheasant_temp](https://github.com/pheasantframework/pheasant_temp); the templating engine, [pheasant_assets](https://github.com/pheasantframework/pheasant_assets); the styles and assets engine, [pheasant_build](https://github.com/pheasantframework/pheasant_build); the build system, and [pheasant_meta](https://github.com/pheasantframework/pheasant_meta); the metadata package. This package itself only provides an api to work with the functionality used and exposed by these packages. 

The main library found and used in every main entry page is the `pheasant` library, which acts as an api library to expose the `createApp` function, a function used to create and render the Pheasant Application.

```dart
import 'package:pheasant/pheasant.dart';

import 'package:<your-lib>/main.phs.dart';

void main() {
    createApp(App);
}
```

The second library used in the project is the `build` library, which is not mainly used by the end user, but is imported and used in all compiled/generated files rendered by the framework (used in the compiled dart code generated from Pheasant Files, and the main entry file `main.phs.dart`).

In future versions, other libraries will be created to expose etra functionality such as support for making plugins, libraries and much more.

## Resources
- Pub packages: [pheasant](https://pub.dev/packages/pheasant), [pheasant_temp](https://pub.dev/packages/pheasant_temp), [pheasant_assets](https://pub.dev/packages/pheasant_assets), [pheasant_build](https://pub.dev/packages/pheasant_build), [pheasant_meta](https://pub.dev/packages/pheasant_meta).
- Github Repo: [source](https://github.com/pheasantframework/pheasant), [issues](https://github.com/pheasantframework/pheasant/issues) and [contributor guidelines](https://github.com/pheasantframework/pheasant/blob/development/CONTRIBUTING.md).

If you have any issues, suggestions, or bigger ideas that may not be properly encapsulated in github, [send me an email](raven@tech.nugegroup.com).