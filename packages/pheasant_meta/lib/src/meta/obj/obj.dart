// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


import 'package:pheasant_meta/src/meta/basic/objects.dart';

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
  /// The start version of the new functionality
  final String version;

  /// The name of the function to be replaced
  final String functionName;

  const AltVersion(this.functionName,
      {required this.version,
      super.info =
          'This is an updated version of the function, so the old one is deprecated'});
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

  const Change(this.reason,
      {this.suggestedFunc,
      this.suggestedVersion,
      super.info = 'Do not make use of this in later versions'});
}

/// Annotation object used to denote functionality that will be used from [s], the given version.
class From extends AnnotationObject {
  const From(String s,
      {super.info = "This functionality takes effect from the given version."});
}
