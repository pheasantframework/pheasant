String? extractExpressionInBrackets(String input) {
  RegExp regExp = RegExp(r'\((.*?)\)'); // Regular expression to match content within parentheses

  Match? match = regExp.firstMatch(input);

  if (match != null) {
    return match.group(1); // Group 1 contains the content within parentheses
  } else {
    return null; // No match found
  }
}