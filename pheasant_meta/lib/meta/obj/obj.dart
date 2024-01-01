import 'package:pheasant_meta/meta/objects.dart';

/// Declares objects that are not supported in HTML5 Standard. These should therefore not be used in a HTML5 interface.
/// The build system takes note of this and excludes all instances of the object this annotation is annotated to.
/// 
/// The [info] field gives information about what alternative can be used instead.
class NoHTML5 extends RestrictedAnnotation {
  const NoHTML5({required super.info});
}

/// Declares function or object alternatives to certain functionality in a package.
/// 
/// This indicates that from the version - [version] - the current annotated function should replace [functionName].
/// 
/// An optional [info] field is provided, which calls to the super constructor - [AnnotationObject].
class AltVersion extends AnnotationObject {
  final String version;
  final String functionName;

  const AltVersion(this.functionName, {required this.version, String info = 'This is an updated version of the function, so the old one is deprecated'})
  : super(info: info);
}

/// Annotation object which declares that a certain function or object is not optimized/perfect, and should be replaced by alternative functionality during production, or at a later time.
/// 
/// The object indicates that the given functionality, for [reason] reason, should not be used, and should be replaced by [suggestedFunc] from [suggestedVersion].
/// 
/// An optional [info] field is provided to give more detailed information, which calls to the super constructor - [AnnotationObject].
class Change extends AnnotationObject {
  final String? suggestedFunc;
  final String reason;
  final String? suggestedVersion;

  const Change(this.reason, {this.suggestedFunc, this.suggestedVersion, String info = 'Do not make use of this in later versions'})
  : super(info: info);
}