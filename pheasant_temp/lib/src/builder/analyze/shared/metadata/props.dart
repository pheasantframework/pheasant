// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
import 'package:code_builder/code_builder.dart' show Field;
import 'annotation_info.dart';

/// Class to encapsulate data for a prop field.
///
/// This class contains info about the field as a [Field], and information about the `@prop` annotation encapsulated as [AnnotationInfo].
class PropField {
  final Field fieldDef;
  final AnnotationInfo annotationInfo;

  const PropField({required this.fieldDef, required this.annotationInfo});

  @override
  String toString() => "Annotation: $annotationInfo \nField: $fieldDef";
}

/// An extended class of AnnotationInfo for sole usage for the `@prop` and `@Prop()` annotations.
class PropAnnotationInfo extends AnnotationInfo {
  const PropAnnotationInfo({super.data = const {}}) : super(name: 'prop');
}
