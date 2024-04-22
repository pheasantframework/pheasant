import 'package:pheasant_assets/pheasant_build.dart'
    hide PheasantStyleScoped, StyleScope;

import '../tools/input.dart' hide PheasantFile;

/// Function used in rendering the input from a pheasant file.
///
/// The function parses [phsData], which represents the string representation of the pheasant data, and then separates it into it's constituent segments.
///
/// Returns a [PheasantComposedInput], which encapsulates each item involved in the parsing of the pheasant file.
PheasantComposedInput renderInput(
    {String phsData = '<script></script><template></template><style></style>',
    bool sassEnabled = false}) {
  return _renderFileInput(phsData, sassEnabled);
}

PheasantComposedInput _renderFileInput(String phsData, bool sassEnabled) {
  String script;
  String template;
  String style;
  PheasantStyle pheasantStyle = PheasantStyle();
  if (!phsData.contains('</script>')) {
    script = "";
    if (!phsData.contains('</template>')) {
      template = '';
      if (!phsData.contains('</style>')) {
        style = "";
      } else {
        pheasantStyle = getStyleInput(phsData, sassEnabled: sassEnabled);
        style = phsData
            .replaceFirst(PheasantStyle.styleRegex, '')
            .replaceFirst('</style>', '');
      }
    } else {
      List<String> templateSplit = phsData.split('</template>');
      template = templateSplit[0].replaceFirst('<template>', '');
      if (!phsData.contains('</style>')) {
        style = "";
      } else {
        pheasantStyle =
            getStyleInput(templateSplit.last, sassEnabled: sassEnabled);
        style = templateSplit.last
            .replaceFirst(PheasantStyle.styleRegex, '')
            .replaceFirst('</style>', '');
      }
    }
  } else {
    List<String> scriptSplit = phsData.split('</script>');
    script = scriptSplit[0].replaceFirst('<script>', '');
    if (!phsData.contains('</template>')) {
      template = '';
      if (!phsData.contains('</style>')) {
        style = "";
      } else {
        pheasantStyle =
            getStyleInput(scriptSplit.last, sassEnabled: sassEnabled);
        style = scriptSplit.last
            .replaceFirst(PheasantStyle.styleRegex, '')
            .replaceFirst('</style>', '');
      }
    } else {
      List<String> templateSplit = scriptSplit.last.split('</template>');
      template = templateSplit[0].replaceFirst('<template>', '');
      if (!phsData.contains('</style>')) {
        style = "";
      } else {
        pheasantStyle =
            getStyleInput(templateSplit.last, sassEnabled: sassEnabled);
        style = templateSplit.last
            .replaceFirst(PheasantStyle.styleRegex, '')
            .replaceFirst('</style>', '');
      }
    }
  }
  template = template.replaceFirst('\n\n', '');
  style = style.replaceFirst('\n\n', '');

  return PheasantComposedInput(
      input: PheasantInput(script: script, template: template, styles: style),
      style: pheasantStyle);
}
