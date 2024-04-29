import 'package:pheasant_assets/pheasant_build.dart' show PheasantStyle;

/// Base Class for a Pheasant File.
abstract class PheasantFile {
  /// The data from the `script` component of the file
  String script;

  /// The data from the `template` component of the file
  String template;

  /// The data from the `style` component of the file
  String styles;

  PheasantFile(
      {required this.script, required this.template, required this.styles});
}

/// Class used to accept the main input of a pheasant file during build.
class PheasantInput extends PheasantFile {
  PheasantInput(
      {required super.script, required super.template, required super.styles});
}

/// Class used to extend [PheasantInput] to encapsulate styles too, with the use of [PheasantStyle]
class PheasantComposedInput {
  /// The class object used to encapsulate the data from the `template` and `script` components of the file
  final PheasantInput input;

  /// The class object used to encapsulate the data from the `style` component of the file
  final PheasantStyle style;

  PheasantComposedInput({required this.input, required this.style});

  @override
  String toString() {
    return "Template: ${input.template} \nStyle: ${input.styles} \nScript: ${input.script}";
  }
}
