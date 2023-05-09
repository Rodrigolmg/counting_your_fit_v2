
abstract class SetsState{}

extension SetsStateX on SetsState{
  bool get isInitialSet => this is InitialSet;
  bool get isSetDefined => this is SetDefined;
  bool get isSetReset => this is SetReset;
}

class InitialSet implements SetsState {
  final int initialSetValue = 1;
  const InitialSet();
}

class SetDefined implements SetsState {
  final int sets;
  const SetDefined(this.sets);
}

class SetReset implements SetsState {
  const SetReset();
}