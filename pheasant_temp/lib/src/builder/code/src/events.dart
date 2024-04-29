import 'package:html/dom.dart' show Element;
import 'package:pheasant_meta/pheasant_meta.dart' show From;
import '../../../components/attributes/attr.dart'
    show PheasantEventHandlingAttribute;

/// Pre-defined functions that can be used to manipulate the state of an object.
///
/// Normal state operations can be undergone through the use of event-handling attributes - [PheasantEventHandlingAttribute]
///
/// In the case you want more control over the state, such as to activate and deactivate the state, then you can apply the following constant functions in order to perform such operations.
///
/// These options have the choice of activating, deactivating and reloading state altogether, as well as other more interesting features.
///
/// This getter returns a [Map] connecting the constant function names to the appropiate statements to apply.
@From('0.1.0')
Map<String, String> get defaultStateAttributes => {
      'freezeState': 'state?.freeze();',
      'reloadState': 'state?.reload();',
      'unfreezeState': 'state?.unfreeze();'
    };

bool preventDefaultCheck(Element pheasantHtml, String name) {
  if ((pheasantHtml.attributes.keys).contains('preventdefault')) {
    return true;
  } else if ((pheasantHtml.attributes.keys).contains('preventdefaults') &&
      (pheasantHtml.attributes.entries
          .firstWhere((element) => element.key == 'preventdefaults')
          .value
          .split(' ')
          .contains(name))) {
    return true;
  }
  return false;
}
