/// The library used in all main entrypoints of a pheasant application.
/// 
/// The only function exposed by this library is the `createApp` function, used to "create" the application.
/// 
/// NOTE: In further versions, there will be more libraries to expose other APIs such as plugin support, custom component supports and custom library support.
library pheasant;

export 'package:pheasant_build/pheasant_build.dart' show createApp;
