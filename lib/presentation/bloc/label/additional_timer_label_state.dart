abstract class AdditionalTimerLabelState<T> {
  T get value;
}

extension TimerLabelStateX on AdditionalTimerLabelState{
  bool get isInitialAdditionalLabel => this is InitialAdditionalTimerLabel;
  bool get isAdditionalMinuteLabelDefined => this is AdditionalMinuteLabelDefined;
  bool get isAdditionalSecondsLabelDefined => this is AdditionalSecondsLabelDefined;
  bool get isAdditionalTimerReset => this is AdditionalTimerReset;
  bool get isAdditionalTimerSelected => this is AdditionalTimeLabelSelected;
}

class InitialAdditionalTimerLabel implements AdditionalTimerLabelState<String?> {
  final String? initialLabel;
  const InitialAdditionalTimerLabel({this.initialLabel = '00:00'});

  @override
  String? get value => initialLabel;

}

class AdditionalMinuteLabelDefined implements AdditionalTimerLabelState<String?>{
  final String? minuteLabel;
  const AdditionalMinuteLabelDefined({this.minuteLabel = '00'});

  @override
  String? get value => minuteLabel;
}

class AdditionalSecondsLabelDefined implements AdditionalTimerLabelState<String?>{
  final String? secondsLabel;
  const AdditionalSecondsLabelDefined({this.secondsLabel = '00'});

  @override
  String? get value => secondsLabel;

}

class AdditionalTimeLabelSelected implements AdditionalTimerLabelState<String?>{
  final String additionalTimeSelected;
  const AdditionalTimeLabelSelected({this.additionalTimeSelected = '00:00'});

  @override
  String? get value => additionalTimeSelected;

}

class AdditionalTimerReset implements AdditionalTimerLabelState<String?>{
  const AdditionalTimerReset();

  @override
  String? get value => null;
}