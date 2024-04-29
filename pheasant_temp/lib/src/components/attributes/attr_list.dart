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
