// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.  
// You may use this file only in accordance with the license.

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
