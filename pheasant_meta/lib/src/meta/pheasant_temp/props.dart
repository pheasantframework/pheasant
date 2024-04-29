import 'package:pheasant_meta/src/meta/basic/objects.dart';

/// Annotation object used in pheasant compiled build files.
///
/// This is the base annotation object for code written in `script` tags that are used for certain functionality.
/// During compilation, these annotation objects are analyzed and then rendered during the build process in order to process her functionality.
class BuildAnnotationObject extends AnnotationObject {
  const BuildAnnotationObject()
      : super(
            info: 'This is a metadata object used in Pheasant Generated Files');
}

/// This is an object used in denoting prop variables passed as arguments in a pheasant component.
///
/// This annotation object is used to denote variables that may not be initialised in the `script` part of the component, and represent data passed from the parent component encapsulating the component to the child.
/// This allows dynamic data to be bound and passed from the parent to the child component.
///
/// In every [Prop] object, there are two variables:
/// the [defaultTo], which represents the default value of the prop if not passed through the child component,
/// the [optional] value, which denotes whether the prop is optional or not.
///
/// ```dart
/// @Prop(defaultTo: 9, optional: true)
/// int myNum;
/// ```
///
/// The following variable is processed and then the constructor of the compiled pheasant object is converted into
/// ```dart
/// AppComponent({super.template, this.myNum = 9});
/// ```
///
/// Whenever this object is passed, if [optional] is set to true, then a [defaultTo] must be passed.
///
/// By defualt, any uninitialised variables without the `@Prop()` annotation has no default value, and [optional] is set to `false`.
///
/// None of the variables are required, and all are optional. If you do not want to use such, and want to go to default settings, then you can use the ordinary `@prop` object.
class Prop extends BuildAnnotationObject {
  final dynamic defaultTo;

  final bool optional;

  const Prop({this.defaultTo, this.optional = false});
}

class _NoProp {
  const _NoProp();
}

typedef PheasantAnnotation = BuildAnnotationObject;

/// This object serves the same purpose as the [Prop] object, and is actually derived from such.
/// This annotation is a default setting of the [Prop] object, where the default value `defaultValue` is `null`, while `optional` is false.
///
/// ```dart
/// @prop
/// int myNum;
/// ```
///
/// This converts to this:
/// ```dart
/// AppComponent({super.template, required this.myNum});
/// ```
///
/// This is also the default for any object that does not contain the annotation, but still is uninitialised.
const prop = Prop(defaultTo: null, optional: false);

/// By default, all uninitialised variables are automatically passed as props (i.e constructor arguments) for the component during compilation.
///
/// This annotation object here does the opposite of [prop] - this object tells the compiler that the following variable is not intended to be a prop, and should not be included as a constructor argument.
///
/// This can be helpful, usually when the user plans for the variable to be initialised later on in the code.
const noprop = _NoProp();
