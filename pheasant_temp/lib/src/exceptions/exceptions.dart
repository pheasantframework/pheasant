import 'package:pheasant_meta/pheasant_meta.dart' show PheasantException;

/// Pheasant Style Implementation of [PheasantException] for use in this package
/// When build runs, and an exception occurs, the [message] is printed out to the build cli, as seen in the [toString] override.
class PheasantTemplateException extends PheasantException {
  int exitCode;
  late PheasantTemplateExceptionLevel? level;

  PheasantTemplateException(super.message,
      {this.exitCode = 1, int levelNo = 0}) {
    switch (levelNo) {
      case 0:
        level = null;
        break;
      case 1:
        level = PheasantTemplateExceptionLevel.info;
        break;
      case 2:
        level = PheasantTemplateExceptionLevel.warning;
        break;
      default:
        level = PheasantTemplateExceptionLevel.severe;
        break;
    }
  }
}

enum PheasantTemplateExceptionLevel { info, warning, severe }
