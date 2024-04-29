import '../routing.dart';
import 'push.dart';
import 'replace.dart';

export 'pop.dart';
export 'refresh.dart';

/// Initialise current state of page
void initPage(String url, [Object? pageInfo]) {
  replaceState(pageInfo, null, url);
}

/// Function used in navigating to a new page
void navigateTo(String url, [String? title]) {
  pushState(null, title, url);
  GlobalRoute.currentRoute = url;
}

/// Function used in navigating to a new page with data
void navigateWith(String url, Object data, [String? title]) {
  pushState(data, title, url);
  GlobalRoute.currentRoute = url;
}

/// Function used to get the current page state for a Pheasant Application.
dynamic fetchState() => getStateData();
