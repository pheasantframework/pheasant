import 'package:pheasant_meta/pheasant_meta.dart' show PheasantException;

/// Pheasant Style Implementation of [PheasantException] for use in this package
/// When build runs, and an exception occurs, the [message] is printed out to the build cli, as seen in the [toString] override.
class PheasantStyleException extends PheasantException {
  /// Default Constructor
  PheasantStyleException(super.message);

  /// Prints out the error message
  @override
  String toString() {
    return "Pheasant Style Exception: $message";
  }
}
