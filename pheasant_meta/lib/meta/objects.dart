class AnnotationObject extends Object {
  final String info;

  const AnnotationObject({required this.info});
}

class RestrictedAnnotation extends AnnotationObject {
  const RestrictedAnnotation({required super.info});
}

class InfoAnnotation extends AnnotationObject {
  const InfoAnnotation({required super.info});
}