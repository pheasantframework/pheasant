// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.

// ignore_for_file: constant_identifier_names

/// Base class for a Pheasant Attribute/Directive in a '.phs' template file
///
/// The class encapsulates the base info of all attributes:
abstract class PheasantAttributeType {
  final String name;
  final PheasantAttributeType? dependsOn;

  const PheasantAttributeType({required this.name, this.dependsOn});
}

/// Enhanced enum class based on the base abstract [PheasantAttributeType]
///
/// In this enum, the different kind of Attributes that can be used on a [PheasantComponent] are listed out here.
/// Each attribute type has a [name] variable, and linked attributes also have a [dependsOn] variable, which links to another [PheasantAttributeType].
/// This shows what a [PheasantAttribute] is linked to.
///
/// Any other attribute not listed here is therefore placed as [PheasantAttribute.unknown].
enum PheasantAttribute implements PheasantAttributeType {
  p_await(name: 'p-await'),
  p_bind(name: 'p-bind'),
  p_html(name: 'p-html'),
  p_if(name: 'p-if'),
  p_else(name: 'p-else', dependsOn: PheasantAttribute.p_if),
  p_elseif(name: 'p-elseif', dependsOn: PheasantAttribute.p_if),
  p_fetch(name: 'p-fetch'),
  p_for(name: 'p-for'),
  p_obj(name: 'p-obj'),
  p_once(name: 'p-obj'),
  p_on(name: 'p-on'),
  p_route(name: 'p-route'),
  p_route_to(name: 'p-route:to'),
  p_route_view(name: 'p-route:view'),
  p_show(name: 'p-show'),
  p_slot(name: 'p-slot'),
  p_state(name: 'p-state'),
  p_text(name: 'p-text'),
  p_while(name: 'p-while'),
  unknown(name: 'nil');

  const PheasantAttribute({required this.name, this.dependsOn});

  @override
  final String name;

  @override
  final PheasantAttributeType? dependsOn;
}

/// Class for Pheasant Event Handling Attributes
///
/// This class forms the basis of the enum [PheasantEventHandlingAttribute] by extending an ordinary [PheasantAttributeType] for event handling attributes.
/// These attributes include `p-on:click`, `p-on:abort` and much more.
///
/// There is an extra variable which references the [PheasantAttribute] it is based on, which goes by the name [basedOn].
abstract class PheasantEventHandlingAttributeType
    extends PheasantAttributeType {
  final PheasantAttributeType basedOn;

  const PheasantEventHandlingAttributeType(
      {required super.name, required this.basedOn, super.dependsOn});
}

/// Enhanced Enum Class based on the [PheasantEventHandlingAttributeType] class.
///
/// These values represent attributes used for event changes, and are meant to be an extension of a few of the values/attributes in [PheasantAttribute],
/// mainly [PheasantAttribute.p_on].
enum PheasantEventHandlingAttribute
    implements PheasantEventHandlingAttributeType {
  p_on_abort(name: 'p-on:abort', basedOn: PheasantAttribute.p_on),
  p_on_click(name: 'p-on:click', basedOn: PheasantAttribute.p_on),
  p_on_change(name: 'p-on:change', basedOn: PheasantAttribute.p_on),
  p_on_blur(name: 'p-on:blur', basedOn: PheasantAttribute.p_on),
  p_on_beforeCopy(name: 'p-on:beforeCopy', basedOn: PheasantAttribute.p_on),
  p_on_beforeCut(name: 'p-on:beforeCut', basedOn: PheasantAttribute.p_on),
  p_on_beforePaste(name: 'p-on:beforePaste', basedOn: PheasantAttribute.p_on),
  p_on_canPlay(name: 'p-on:beforePaste', basedOn: PheasantAttribute.p_on),
  p_on_canPlayThrough(
      name: 'p-on:beforePaste', basedOn: PheasantAttribute.p_on),
  p_on_keyUp(name: 'p-on:keyUp', basedOn: PheasantAttribute.p_on),
  p_on_keyDown(name: 'p-on:keyDown', basedOn: PheasantAttribute.p_on),
  p_on_mouseUp(name: 'p-on:mouseUp', basedOn: PheasantAttribute.p_on),
  p_on_mouseDown(name: 'p-on:mouseDown', basedOn: PheasantAttribute.p_on),
  p_on_input(name: 'p-on:input', basedOn: PheasantAttribute.p_on),
  p_on(name: 'p-on', basedOn: PheasantAttribute.p_on),
  p_on_hover(name: 'p-on:hover', basedOn: PheasantAttribute.p_on),
  p_on_ended(name: 'p-on:ended', basedOn: PheasantAttribute.p_on),
  p_on_custom(name: 'p-on:custom', basedOn: PheasantAttribute.p_on),
  ;

  const PheasantEventHandlingAttribute(
      {required this.name, required this.basedOn})
      : dependsOn = null;

  @override
  final String name;

  @override
  final PheasantAttributeType basedOn;

  @override
  final PheasantAttributeType? dependsOn;
}
