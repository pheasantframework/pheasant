import '../assets.dart' hide StyleScope;

/// Small function to help in the creation of ids used to identify and scope component styles in a pheasant component.
///
/// This function is used in the conversion of styles from [PheasantStyle] to [PheasantStyleScoped].
///
/// The id produced is unique to each component.
String makeId(PheasantStyle pheasantStyle) {
  String pheasantPrefix = "phs-";
  String specialid = ".$pheasantPrefix${pheasantStyle.hashCode}";
  return specialid;
}
