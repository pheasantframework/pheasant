import 'package:html/dom.dart' show Element;
import '../../../exceptions/exceptions.dart';
import 'cc.dart' show serveSingleComponents;

/// Function to help in rendering custom components
///
/// Custom components, much like normal element components can be self-closing or paired (with opening and closing tags).
/// But because the `parse` function doesn't know the component, it will automatically render all of them as paired.
///
/// In order to mitigate this, we have to manually render all intended self-closing custom components (of the form `<Component />`) to the intended form (with no children).
///
/// Here is an instance
/// ```html
/// <!--Intended Creation-->
/// <Component />
/// <p>Hello</p>
/// <p>Aloha</p>
/// <!-- to parent -->
/// ```
///
/// This is what it is intended to be. Below is what `parse` renders:
/// ```html
/// <!--Actual Creation before fun-->
/// <Component>
///   <p>Hello</p>
///   <p>Aloha</p>
/// </Component>
/// <!-- to parent -->
/// ```
/// This is code before [formatCustomComponents]
///
/// This is the renderable code after [formatCustomComponents]
/// ```html
/// <!--Actual Creation after fun-->
/// <Component></Component> <!-- this is equally rendered as the intended <Component /> -->
/// <p>Hello</p>
/// <p>Aloha</p>
/// <!-- to parent -->
/// ```
void formatCustomComponents(
    Map<String, String> importMap, String template, Element pheasantHtml) {
  String componentName = "";
  for (var element in importMap.keys) {
    componentName = element;
    var regen = RegExp(
        '<(?<component>$componentName)([^>]*)\\s*(?:/|></\\k<component>)?>');
    try {
      Iterable<Match> regexMatches = regen.allMatches(template);
      regexMatches.map((e) => e[0]).forEach((el) {
        if ((el ?? '').contains('/')) {
          serveSingleComponents(pheasantHtml, componentName);
        }
      });
    } catch (e) {
      throw PheasantTemplateException('Error Rendering Custom Component: $e');
    }
  }
}
