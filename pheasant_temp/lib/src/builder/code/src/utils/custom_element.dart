import 'package:html/dom.dart' show Element;

String customComponentRendering(
    Element element, String beginningFunc, String childname,
    {String? overrideName, bool imported = true, String? importName}) {
  String impName = importName ?? element.localName!;
  String componentName = '${element.localName!}Component';
  if (overrideName != null) {
    componentName = overrideName;
  }
  var componentItem =
      '${imported || overrideName == null ? '$impName.' : ''}$componentName()';
  if (element.attributes.keys
      .where((element) => (element as String).contains('p-bind'))
      .isNotEmpty) {
    var props = element.attributes.entries
        .where((element) => (element.key as String).contains('p-bind'));
    Map<String, dynamic> params = Map.fromIterables(
        props.map((e) => (e.key as String).replaceAll('p-bind:', '')),
        props.map((e) => e.value));
    String paramlist =
        params.entries.map((e) => "${e.key}: ${e.value}").join(', ');

    componentItem =
        '${imported || overrideName == null ? '$impName.' : ''}$componentName($paramlist)';
  }
  beginningFunc += '''
  final ${childname}component = $componentItem;
  final ${childname}componentState = _i1.TemplateState(component: ${childname}component, initState: ${childname}component, watchers: List.empty(growable: true));
  final ${childname}watcher = _i1.ElementChangeWatcher<_i1.PheasantTemplate>(initValue: ${childname}component, state: ${childname}componentState);
  _i2.Element $childname = ${childname}component.render(${childname}component.template!, ${childname}componentState);
  ${childname}watcher.initialiseReference($childname);
  state?.registerWatcher<_i1.PheasantTemplate>(${childname}componentState, ${childname}component, watcher: ${childname}watcher);
  ${childname}componentState.stateStream.listen((event) {
    (state?.watchers.singleWhere((e) => e == ${childname}watcher) as _i1.ElementChangeWatcher).setReference($childname);
    _i2.Element __${childname}_temp = event.newValue!.render(event.newValue!.template!, ${childname}componentState);
    $childname.replaceWith(
      __${childname}_temp
    );
    ${childname}componentState.watchers.whereType<_i1.ElementChangeWatcher>().forEach((item) => item.reflectChanges());
  },);
  
  
  ''';
  return beginningFunc;
}
