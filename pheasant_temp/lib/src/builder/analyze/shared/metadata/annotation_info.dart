/// Class used to encapsulate compound annotation info.
///
/// This class is used to get and encapsulate annotation info in annotations where parameters are passed such as the `@Prop()` annotation.
///
/// The name of the annotation is passed into the [name] variable, while the data, including the parameter name and value, are passed as a [Map] to [data].
class AnnotationInfo {
  /// The name of the annotation
  final String name;

  /// Map connecting the parameter name to its value.
  final Map<String, dynamic> data;

  const AnnotationInfo({required this.name, this.data = const {}});

  /// Description of the annotation as a string
  @override
  String toString() => "$name : $data";
}
