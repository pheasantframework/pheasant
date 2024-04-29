// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file. 
// You may use this file only in accordance with the license.

import 'css/id_scope.dart';

/// A basic enum to denote scope levels in a pheasant style component.
///
/// [global] represents styles that apply to the whole project, and do not need to be scoped to a particular component.
///
/// [local] represents styles that apply only to the specified component, and so are scoped to that component by the `pheasant_assets` engine.
///
/// [shared] is an unimplemented and not-yet-ready feature to represent styles that stem between components.
///
/// [hybrid] is an unimplemented and not-yet-ready feature to represent styles that can be scoped and global (at certain parts of the document).
enum StyleScope { local, shared, global, hybrid }

/// The base class for all pheasant styles under the `style` component of a pheasant file.
///
/// This class encapsulates all important data about a pheasant style segment, including its [syntax], [scope] (which can be between `global` and `local`), the [data] inside it, and, if imported from a file, its file path - [src].
///
/// ```scss
/// <style syntax="scss" global>
/// $primary-color: #3498db;
/// $font-family: 'Arial', sans-serif;
///
/// @mixin button-styles($bg-color: $primary-color) {
///   background-color: $bg-color;
///   color: #fff;
///   padding: 10px 20px;
///   border: none;
///   cursor: pointer;
/// }
///
/// body {
///   background-color: #f4f4f4;
///   color: #333;
///   font-family: \$font-family;
///
///   .container {
///     width: 80%;
///     margin: 0 auto;
///   }
///
///   .button {
///     @include button-styles;
///   }
/// }
/// </style>
/// ```
///
/// From the above, [data] would be everything in between the `<style>` tags, [syntax] would be `"scss"`, [scope] would be [StyleScope.global] and [src] would be `null`.
///
/// All parameters are optional, except the `style` itself (obviously). In such cases, [syntax] is set to `"css"` and [scope] is set to [StyleScope.local].
///
/// This object helps in the encapsulation and parsing of pheasant styles.
class PheasantStyle {
  /// The regular expression used in parsing the pheasant `style` tags.
  static RegExp styleRegex = RegExp(
    r'<style\s*' // Match the opening tag '<style' and one or more whitespaces
    r'(?:src="([^"]*)")?\s*' // Optional src attribute and its value
    r'(?:syntax="([^"]*)")?\s*' // Optional syntax attribute and its value
    r'(?:(local|global))?' // Optional local/global attribute
    r'>', // Match the closing angle bracket '>'
  );

  /// The data located in the style component. Can be null if [src] is provided.
  final String? data;

  /// The path to the css file containing data for the style component. Can be null if [data] is provided.
  final String? src;

  /// The syntax being used for the style component. Usually ranges from `css`, `scss` and `sass`.
  final String syntax;

  /// The scope applied to the style component. Can either be `global` - [StyleScope.global] or `local` - [StyleScope.local].
  final StyleScope scope;

  /// Default constructor for a [PheasantStyle] object
  const PheasantStyle({this.src, this.data, this.scope = StyleScope.local})
      : syntax = 'css';

  /// Constructor used if `sass` is enabled during project configuration.
  const PheasantStyle.sassEnabled(
      {required this.syntax,
      this.src,
      this.data,
      this.scope = StyleScope.local});

  /// Constructor to directly pass already scoped styles.
  /// Used mostly in parsing global styles that do not need scope.
  factory PheasantStyle.scoped(
      {String data = '',
      String src = '',
      String syntax = 'css',
      StyleScope scope = StyleScope.local,
      String css = ''}) {
    PheasantStyle pheasantStyle = PheasantStyle.sassEnabled(
        data: data, src: src, syntax: syntax, scope: scope);
    return PheasantStyleScoped(
        id: makeId(pheasantStyle),
        pheasantStyle: pheasantStyle,
        scoped: scope == StyleScope.local);
  }

  @override
  String toString() {
    return "PheasantStyle: syntax=$syntax, scope=${scope == StyleScope.global ? "global" : "local"}${(src == null ? "" : ", src=$src")}";
  }
}

/// The final result after adding scope and analyzing a [PheasantStyle] object.
///
/// This object extends [PheasantStyle] by doing two things:
/// It adds two new fields, [id] which represents the class id used to scope the css, which is later used in applying the scope to class declarations in the templating engine,
/// and it scopes the css using the [id], to create a new css string - [css].
///
/// Before the scoping is applied, all css presented by [PheasantStyle] is compiled down to vanilla css
/// (normal css is compiled and analyzed to check for errors, while sass and scss is compiled by the in-built sass preprocessor to vanilla css), then scoped using the power of the sass preprocessor, and recompiled.
///
/// Each `id` is final and is unique to each pheasant style. No two [PheasantStyleScoped] objects have the same `id`.
class PheasantStyleScoped extends PheasantStyle {
  /// The unique id used to identify this specific object and its style. It is also used in the template engine for class declarations.
  final String id;

  /// variable to denote whether styles were scoped or not.
  final bool scoped;

  /// The css data, stored as a [String]
  String css;

  /// Default Constructor to create a new [PheasantStyleScoped] object.
  /// Must require a [PheasantStyle] as input, as well as [id].
  PheasantStyleScoped(
      {required this.id,
      required this.scoped,
      required PheasantStyle pheasantStyle,
      this.css = ''})
      : super(
            data: pheasantStyle.data,
            scope: pheasantStyle.scope,
            src: pheasantStyle.src);
}
