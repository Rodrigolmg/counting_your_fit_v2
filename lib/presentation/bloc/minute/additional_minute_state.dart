abstract class AdditionalMinuteState{}

extension AdditionalMinuteStateX on AdditionalMinuteState {
  bool get isInitialAddititionalMinute => this is InitialAdditionalMinute;
  bool get isAdditionalMinuteDefined => this is AdditionalMinuteDefined;
}

class InitialAdditionalMinute implements AdditionalMinuteState {
  final int initialAdditionalMinuteValue = 0;
  const InitialAdditionalMinute();
}

class AdditionalMinuteDefined implements AdditionalMinuteState {
  final int additionalMinute;
  const AdditionalMinuteDefined(this.additionalMinute);
}