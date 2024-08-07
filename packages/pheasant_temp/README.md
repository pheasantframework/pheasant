# <center>The Pheasant Framework Template Engine</center>

![Pub Version](https://img.shields.io/pub/v/pheasant_temp?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_temp)  ![Pub Publisher](https://img.shields.io/pub/publisher/pheasant_temp?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_temp) ![Pub Points](https://badgen.net/pub/points/pheasant_temp?icon=https://upload.wikimedia.org/wikipedia/commons/9/91/Dart-logo-icon.svg&labelColor=yellow) ![GitHub License](https://img.shields.io/github/license/pheasantframework/pheasant?labelColor=rgb(245%2C%20193%2C%2066))

Welcome to the Pheasant Templating engine package. 

This package is used to render content from .phs files into dart template files to be used during build time.

This resource is not intended for use by the end user or for general use, but mainly for the background/behind-the-scenes working of the Pheasant Framework. 
It can be used for low-level handling of pheasant file data.

This package is constantly under development, and may not be perfect. If you have any issues with this package, or any packages that depend on it because of this package, please feel free to raise an issue, and we will work on it. Ensure to [follow the guidelines](./CODE_OF_CONDUCT.md), though. 

If you have any contributions to make, feel free, just [follow the contribution guidelines](./CONTRIBUTING.md), and make your contributions as guided. All contributions concerning this package are welcome and are reviewed in order to constantly give performant features.

## Features

For basic usage of this package, there really isn't much to it. 

There are only two basic functions. One of them is the rendering function, `renderFunc`, which takes in two required and one optional parameter: **`script`**, which represents the script portion of a '.phs' file, **`template`** which represents the template part of a '.phs' file, and the optional **`buildExtension`** parameter, which must represent the extension of built pheasant files (when building them to dart files) when using this package as a part of the much larger Pheasant Framework - by default, it is set to `'.phs.dart'`.

The function returns the desired Dart Code Composition for the built pheasant file, including all necessary imports and the Component Class. In the later future, the code will be optimized, and there may be alternative ways to achieve this effect, but would be presented differently. The Dart Code Composition is formatted and returned as a `String`.

The second function, `renderMain`, is used to render the main pheasant dart file - `main.phs.dart`. There are no required parameters, although there are some optional parameters that can customize the rendering process

## Getting started

In order to install this package, you can use the `dart pub` command as you would with any other pheasant package.

```bash
dart pub add dev:pheasant_temp # Dev Dependency

dart pub add pheasant_temp # Dependency
```

You can also clone this git repository and work with it from there.

Afterwards, you can make use of the features in the package by adding the necessary import

```dart
import 'package:pheasant_temp/pheasant_temp.dart';
```

## Usage
Here is an example usage of the `renderFunc` function.

```dart
import 'package:pheasant_temp/pheasant_temp.dart';


void main() {
  print(
    renderFunc(script: """
String myData = "Hello World";
""", template: """
<div>
  Welcome to Pheasant
  <p>{{myData}}</p>
</div>
""")
  );
}

```

## Contributing

All contributions are welcome, and we continuously review them to make necessary and important changes to our framework.

Please read the [contribution file](./CONTRIBUTING.md) for more information on how you can make a contribution.

## License
This package is licensed under the same license as the Pheasant Framework. For more info [check it out](./LICENSE)

## Additional information

For more information on how this package is used in the Pheasant Framework, please check out the full framework on [Github](https://github.com/pheasantframework/pheasant) or on [Dart Pub]().

For more information on this particular package, including it's api reference, you can check it out on [dart pub here]().
