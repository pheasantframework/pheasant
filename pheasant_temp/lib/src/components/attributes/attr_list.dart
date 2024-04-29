// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
// 
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.
  
import 'package:pheasant_temp/src/components/attributes/attr.dart';

List<PheasantAttributeType> _attributes = PheasantAttribute.values;

List<PheasantEventHandlingAttributeType> _eventAttributes =
    PheasantEventHandlingAttribute.values;

/// Total number of attributes used in the application
List<PheasantAttributeType> get attributes => _attributes;

/// Total number of event handling attributes used in the application
List<PheasantEventHandlingAttributeType> get eventAttributes =>
    _eventAttributes;

/// Function to add attributes to the register for the application. Usually implemented for custom attributes.
void addAttribute(PheasantAttributeType attribute) {
  _attributes.add(attribute);
}

/// Function to add event-handling attributes to the register for the application. Usually implemented for custom attributes.
void addEventHandlingAttribute(PheasantEventHandlingAttributeType attribute) {
  _eventAttributes.add(attribute);
}
