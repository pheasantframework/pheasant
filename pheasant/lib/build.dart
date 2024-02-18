/// This is the library used in all generated pheasant files, from the compiled dart code generated from the Pheasant Components to the `main.phs.dart` file also.
///
/// This library only exposes the two functions from the `html` library used in the compiled dart code, and the `PheasantTemplate` class, which represents the backbone for all Pheasant-Compiled File Components
library build;

export 'package:pheasant_temp/pheasant_build.dart'
    show PheasantTemplate, TemplateState, ChangeWatcher, ElementChangeWatcher, AppState, Prop, prop, noprop;
export 'package:html/parser.dart' show parse, parseFragment;
