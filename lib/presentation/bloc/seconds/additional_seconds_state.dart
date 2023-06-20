
abstract class AdditionalSecondsState{}

extension SecondsStateX on AdditionalSecondsState{
  bool get isInitialAdditionalSecond => this is AdditionalSecondsDefined;
  bool get isAdditionalSecondsDefined => this is AdditionalSecondsDefined;
  bool get isAdditionalSecondsReset => this is AdditionalSecondsReset;
  bool get isAdditionalSecondsSelected => this is AdditionalSecondsSelected;
}

class InitialAdditionalSecond implements AdditionalSecondsState {
  final int initialAdditionalSecondValue = 0;
  const InitialAdditionalSecond();
}

class AdditionalSecondsDefined implements AdditionalSecondsState {
  final int additionalSeconds;
  const AdditionalSecondsDefined(this.additionalSeconds);
}

class AdditionalSecondsSelected implements AdditionalSecondsState {
  final int? additionalSecondsSelected;
  const AdditionalSecondsSelected(this.additionalSecondsSelected);
}

class AdditionalSecondsReset implements AdditionalSecondsState {
  const AdditionalSecondsReset();
}