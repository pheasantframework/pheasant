import 'package:pheasant_temp/src/components/attributes/attr_list.dart' as phs;

Iterable<String> className = ['class', 'className'];

Iterable<String> nonStringAttr = ['href', 'id'];

Iterable<String> pheasantAttr = [
  ...phs.attributes.map((e) => e.name),
  ...phs.eventAttributes.map((e) => e.name),
  ..._depAttrs
];

Iterable<String> _depAttrs = ['p-bind', 'p-slot'];

bool _containsItem(Iterable<String> attrs, String data) {
  return attrs.where((element) => data.contains(element)).isNotEmpty;
}

bool containsDepAttrs(String attr) => _containsItem(_depAttrs, attr);

Iterable<String> _nonRenderable = ['preventdefault', '@', 'nostate'];

bool nonrenderableAttrs(String attr) => _containsItem(_nonRenderable, attr);
