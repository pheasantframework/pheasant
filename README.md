# <center><div style="color:gold">Pheasant</div></center>

![Pub Version](https://img.shields.io/pub/v/pheasant?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant)  ![Pub Publisher](https://img.shields.io/pub/publisher/pheasant?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant)

Pheasant is a modern-day, progressive, fast-reload, powerful frontend web framework and platform written, and operated with in the [Dart Language](https://dart.dev), with support for JavaScript. It grants all the features of modern web development (Web Components, HTML Rendering and more) with the dynamic power of Dart.

## What's All The Hype?
When it comes to web development, developers are constantly looking for better ways to make powerful apps faster. That's why the Pheasant Framework is here:

- **Use JavaScript and Dart Together**: Pheasant is a powerful framework for building progressive web applications with the power, speed and versatility of the Dart Language, while also giving room to JavaScript Developers by allowing you to extend your Dart, and Pheasant, code with the strength of JavaScript. That way, Pheasant appeals to all kinds of web developers.

- **Fast Reload and Build Process**: The Pheasant Framework is able to work the way it does thanks to the power of the Dart Language, as it has **out-of-the-box** fast-reloading, and fast building of code. Pheasant projects can easily be made, configured and built with one-liner commands. The Framework automatically watches all files and updates the UI once a change is made, eliminating the need for external build frameworks, so you can focus on your application. Creating your projects are also much faster, as the framework doesn't use so many libraries, nor does it need to depend on `node_modules` like other similar JavaScript Frameworks.

- **In-Buiilt CSS Preprocessing**: The Pheasant Framework contains in-built support for CSS Preprocessing using `sass`, as well as a simple API for **web components** and the ability to statically generate sites with in-built support for **markdown** rendering.

- **Zero Virtual DOM**: The Pheasant Framework also *compiles* your code, so there is no need to ship a virtual DOM, instead all pheasant code is compiled to Dart code, with some pheasant-specific modifications, that can be injected directly into the HTML DOM. 

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
2. The **script** which contains Dart data located inside it, which can be used in the **template** part for rendering. Here you can simply write plain Dart Code, and import dart libraries as well as other Pheasant Files/Components.
```
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

## Getting Started
In order to get started with the web framework, you will need to install the pheasant command line interface - `pheasant`.

### Clone this repository
You can clone this repository to your local system, then you can go ahead and do the following:
1. Install the pheasant cli by compiling the compiler:
```bash
dart compile pheasant_cli/bin/pheasant.dart -o pheasant
```

2. Export the executable to your `PATH` variable, in order to use it anywhere in your code.

3. Start using the pheasant cli and make use of it. You can check the version of the cli by using the following command:
```bash
pheasant -v
```

### Install the CLI
You can also install the pheasant cli through various means, but for now we only support using [pub.dev](https://pub.dev):
```bash
dart pub global activate pheasant_cli
```

Then you can confirm the CLI is working
```bash
pheasant -v
```

For more information on how the cli works, you can check it out [here](pheasant_cli/README.md)

## Documentation
Read our [documentation]() in order to see how the framework works. 

Check out the [Getting Started]() page for a quick overview.

## Example Usage
Here is an example pheasant file, and how the `main.dart` file looks like:

### Pheasant File
```pheasant
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

<style>
#output {
    font-family: verdana;
    color: blue;
    background-color: powderblue;
}

p {
    color: red;
}
</style>
```

### Dart Main File
```dart
import 'package:pheasant/pheasant.dart';

// File will be generated.
import 'package:<pkg-name>/main.phs.dart';

void main() {
  createApp(App);
}
```

## Composition
The Pheasant Framework, as of the current version, contains 4 packages:
1. **pheasant_temp**: The Pheasant Framework Templating package. This is where the main functionality of the Pheasant Framework operates. You can check it out [here](https://github.com/pheasantframework/pheasant_temp).

2. **pheasant_build**: The Pheasant Framework Build package. This is the building process for the Pheasant Framework. You can check it out [here](https://github.com/pheasantframework/pheasant_build).

3. **pheasant_meta**: The Pheasant Framework Metadata package. This is where the metadata or annotations used in sibling packages (packages used in the framework) are defined. You can check it out [here](https://github.com/pheasantframework/pheasant_meta).

4. **pheasant_assets**: The Pheasant Framework Assets/Styles Engine. This is used for rendering, processing and scoping styles indicated in the `<style>` part of a pheasant file. It has inbuilt support for not only css, but also for sass and scss (for more on sass, check them out [here](https://sass-lang.com)).


| Source Code | Published Version | Pre-Release Version |
| ----------- | ----------------- | ------------------- |
| [pheasant_temp](https://pub.dev/packages/pheasant_temp) | ![Pub Version](https://img.shields.io/pub/v/pheasant_temp?link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_temp) | ![Pub Version](https://img.shields.io/pub/v/pheasant_temp?link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_temp) |
| [pheasant_assets](https://pub.dev/packages/pheasant_assets) | ![Pub Version](https://img.shields.io/pub/v/pheasant_assets?link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_assets) | ![Pub Version](https://img.shields.io/pub/v/pheasant_assets?include_prereleases&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_assets) |
| [pheasant_build](https://pub.dev/packages/pheasant_build) | ![Pub Version](https://img.shields.io/pub/v/pheasant_build?link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_build) | ![Pub Version](https://img.shields.io/pub/v/pheasant_build?include_prereleases&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_build) |
| [pheasant_meta](https://pub.dev/packages/pheasant_meta) | ![Pub Version](https://img.shields.io/pub/v/pheasant_meta?link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_meta) | ![Pub Version](https://img.shields.io/pub/v/pheasant_meta?include_prereleases&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_meta) |

## Contributing
All contributions are welcome, and we continuously review them to make necessary and important changes to our framework.

Please read the [contribution file](./CONTRIBUTING.md) for more information on how you can make a contribution.

## License
This package is licensed under the [MIT License](./LICENSE).
