import 'package:html/dom.dart' show Element, Node;

import 'package:pheasant_meta/pheasant_meta.dart' show AltVersion;

/// Function to help in serving custom components
///
/// This helps in rendering singular custom components (self-closing) that are of the form `<Component />` by displacing the children that the `parse` function would have created.
void serveSingleComponents(Node root, String tagName) {
  List<Element> elementCategories = findAllElements(root, tagName);
  for (var element in elementCategories) {
    element.reparentChildren(element.parentNode ?? root);
  }
}

/// Recursive Function to get all occurences of a component
///
/// This function is much like `querySelector`, but then it has support for any element tag name, including custom components.
List<Element> findAllElements(Node root, String tagName) {
  List<Element> result = [];

  void searchElements(Node node) {
    if (node is Element && node.localName == tagName) {
      result.add(node);
    }

    if (node.hasChildNodes()) {
      node.nodes.forEach(searchElements);
    }
  }

  searchElements(root);

  return result;
}

@AltVersion('findAllElements', version: '0.3.0')
List<Element> _findAllElementsNonRecursive(Node root, String tagName) {
  List<Element> result = [];
  List<Node> stack = [root];

  while (stack.isNotEmpty) {
    var currentNode = stack.removeLast();

    if (currentNode is Element && currentNode.localName == tagName) {
      result.add(currentNode);
    }

    if (currentNode.hasChildNodes()) {
      stack.addAll(currentNode.nodes);
    }
  }

  return result;
}
