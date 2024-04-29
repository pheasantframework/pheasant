/// Minified version of the general `pheasant_assets` library for use during build.
///
/// This library is usually used in the `pheasant_build` package, but you can use it for simple and quick encapsulation of asset processing code.
///
/// This library gives the functionality needed to run the pheasant web app on the web without importing VM functionality, which could prevent the app from not running.
library pheasant_assets_build;

export 'src/assets.dart';
export 'src/compile/parse.dart';
