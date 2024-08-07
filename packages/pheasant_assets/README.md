# <center>The Pheasant Framework Assets Engine</center>

![Pub Version](https://img.shields.io/pub/v/pheasant_assets?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_assets) ![Pub Publisher](https://img.shields.io/pub/publisher/pheasant_assets?labelColor=rgb(245%2C%20193%2C%2066)&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fpheasant_assets)


This is the Pheasant Framework Asset Engine, used to render and process styles and assets. The Pheasant Framework has inbuilt support for css styles through the `styles` component of the pheasant file, as well as support for `sass` and `scss`. 

This package deals with the parsing, processing and scoping of these styles defined or imported in the `styles` component of pheasant files.

This package is not intended for direct use by the end-user, but just as a supporting dependency for the Pheasant Framework and its sibling packages - [pheasant_temp](https://github.com/pheasantframework/pheasant_temp) and [pheasant_build](https://github.com/pheasantframework/pheasant_build).

### Some things to note

This package is constantly under development. If you have any issues with this package, or any packages in the Pheasant Framework, please feel free to raise an issue, and we will work on it in due time. Don't forget to [follow the guidelines](./CODE_OF_CONDUCT.md), though. 

If you have any contributions to make, feel free, just [follow the contribution guidelines](./CONTRIBUTING.md), and make your contributions as guided. All contributions concerning this package are welcome and are reviewed in order to constantly give performant features.

## Features

There are four main functions exposed by this package, and they represent the three steps denoted in the Pheasant Asset Rendering Process: **parse - compile - scope**.

## Getting started

Note that this package is not intended for direct use by the end user.

In order to get started with this package, you can simply add it as a dev dependency to your project:
```bash
dart pub add dev:pheasant_assets
```

Then you can import it into your project. 
There are two libraries: **pheasant_assets** (`package:pheasant_assets/pheasant_assets.dart`), which contains all functionality needed to get the most out of the package, and **pheasant_assets_build** (`package:pheasant_assets/pheasant_build.dart`) which is much smaller, and was originally designed as a safe api for the `pheasant_build` package, and should be used for more web-inclined environment cases.

## Usage

### Parse
In order to parse the css, the package makes use of the `getStyleInput` to parse the stlyesheet, as well as the style configuration declared in the `<style>` tags.

### Compile
The css styles are compiled and alayzed through various functions. All sass/scss stylesheets are compiled to raw css. All file paths are resolved, and the compiler compiles the data located in the files.

### Scope
In order to ensure certain styles do not leak into other components (they are locally scoped to the component by which it is defined to), the engine takes a second step to scope and recompile the css. The `scopeComponets` function takes care of this.

For more info on how these work, check out the API Documentation.

## Additional information

This package uses [the same license](./LICENSE) as the Pheasant Framework.
