/// A temporary class containing the new `beginningFunc` String [value] and the new `closebracket` integer [number].
///
/// This class is not intended for public use and is only for one singular purpose - to get a return value for the `pheasantAttributes` function
class TempPheasantRenderClass extends _PheasantTempClass {
  int number;
  String value;

  TempPheasantRenderClass({required this.number, required this.value});
}

class _PheasantTempClass {}
