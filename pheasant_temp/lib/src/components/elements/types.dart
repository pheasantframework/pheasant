import 'package:pheasant_meta/pheasant_meta.dart' show nohtml5;

/// Enhanced Enum Set for the types of components that can be rendered in the Pheasant File
///
/// Each component has a distinctive name that can be called
enum ComponentType {
  text(name: 'text'),
  element(name: 'element'),
  comment(name: 'comment'),
  custom(name: 'custom'),
  unknown(name: 'nil');

  /// Default constructor
  const ComponentType({required this.name});

  /// The [String] name assoicated with the component type.
  final String name;
}

/// Enhanced enum set for the types of basic element components that can be rendered in the Pheasant File.
/// These fall under [ComponentType.element].
///
/// All other component types not included here are 'custom' components and are differentiated in the [CustomComponentType] enum.
enum ElementComponentType {
  a(name: 'a', selfclosing: false),
  abbr(name: 'abbr', selfclosing: false),
  b(name: 'b', selfclosing: false),
  body(name: 'body', selfclosing: false),
  br(name: 'br', selfclosing: true),
  button(name: 'button', selfclosing: false),
  caption(name: 'caption', selfclosing: false),
  @nohtml5
  center(name: 'center', selfclosing: false),
  code(name: 'code', selfclosing: false),
  col(name: 'col', selfclosing: true),
  colgroup(name: 'colgroup', selfclosing: false),
  div(name: 'div', selfclosing: false),
  em(name: 'em', selfclosing: false),
  embed(name: 'embed', selfclosing: false),
  footer(name: 'footer', selfclosing: false),
  form(name: 'form', selfclosing: false),
  head(name: 'head', selfclosing: false),
  header(name: 'header', selfclosing: false),
  hr(name: 'hr', selfclosing: true),
  html(name: 'html', selfclosing: false),
  h1(name: 'h1', selfclosing: false),
  h2(name: 'h2', selfclosing: false),
  h3(name: 'h3', selfclosing: false),
  h4(name: 'h4', selfclosing: false),
  h5(name: 'h5', selfclosing: false),
  h6(name: 'h6', selfclosing: false),
  i(name: 'i', selfclosing: false),
  iframe(name: 'iframe', selfclosing: false),
  img(name: 'img', selfclosing: false),
  input(name: 'input', selfclosing: true),
  label(name: 'label', selfclosing: false),
  li(name: 'li', selfclosing: false),
  link(name: 'link', selfclosing: true),
  main(name: 'main', selfclosing: false),
  meta(name: 'meta', selfclosing: true),
  noscript(name: 'noscript', selfclosing: false),
  ol(name: 'ol', selfclosing: false),
  p(name: 'p', selfclosing: false),
  script(name: 'script', selfclosing: false),
  span(name: 'span', selfclosing: false),
  style(name: 'style', selfclosing: false),
  table(name: 'table', selfclosing: false),
  td(name: 'td', selfclosing: false),
  template(name: 'template', selfclosing: false),
  th(name: 'th', selfclosing: false),
  tr(name: 'tr', selfclosing: false),
  ul(name: 'ul', selfclosing: false),
  ;

  /// Default Constructor for the [ElementComponentType] enum.
  /// Each type comes with a [name] and a [selfclosing] attribute.
  ///
  /// The [name] is distinct - gives the name of the component.
  /// The [selfclosing] boolean denotes whether it is self-closing (doesn't come in a pair of tags).
  const ElementComponentType({required this.name, required this.selfclosing});

  /// The [String] name associated with this [ElementComponentType]
  final String name;

  /// Whether the Component is self-closing or not
  final bool selfclosing;

  /// The name of the given component
  @override
  String toString() {
    return name;
  }
}

/// Enhanced enum set for all other components that are either not found in the [ElementComponentType] enum, are not comments ([ComponentType.comment]) and are not text ([ComponentType.text])
/// They therefore represent the distinct types that fall under [ComponentType.custom].
///
/// Custom component types are either imported into the file as basic components (from a .phs file), or are web components created on the fly or on the file.
/// Web Component types have a 'wc-' prefix, and the value of [imported] is set to false.
///
/// Any other component type not found here is therefore listed as 'undefined' and falls under [ComponentType.unknown].
enum CustomComponentType {
  single(selfclosing: true, imported: true),
  double(selfclosing: false, imported: true),
  wcsingle(selfclosing: true, imported: false),
  wcdouble(selfclosing: false, imported: false),
  ;

  const CustomComponentType(
      {required this.selfclosing, required this.imported});

  /// Whether the Component is self-closing or not
  final bool selfclosing;

  /// Whether the Component is imported (the component is a separate pheasant file), or it is not (a defined web component).
  final bool imported;
}
