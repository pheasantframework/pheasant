/// A base annotation object
class AnnotationObject extends Object {
  /// The info portrayed by the object
  final String info;

  const AnnotationObject({required this.info});
}

/// An annotation object used to represent restricted functionality.
class RestrictedAnnotation extends AnnotationObject {
  const RestrictedAnnotation({required super.info});
}

/// An annotation object for the sole purpose of portaying information
class InfoAnnotation extends AnnotationObject {
  const InfoAnnotation({required super.info});
}

/// Annotation Object used for all annotations requiring and dealing with state management.
///
/// This is not used directly, but used in constant objects to declare state annotation objects.
class StateAnnotation extends AnnotationObject {
  const StateAnnotation({required super.info});
}
