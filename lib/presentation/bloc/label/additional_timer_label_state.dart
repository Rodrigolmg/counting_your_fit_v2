abstract class AdditionalTimerLabelState<T> {
  T get value;
}

extension TimerLabelStateX on AdditionalTimerLabelState{
  bool get isInitialAdditionalLabel => this is InitialAdditionalTimerLabel;
  bool get isAdditionalMinuteLabelDefined => this is AdditionalMinuteLabelDefined;
  bool get isAdditionalSecondsLabelDefined => this is AdditionalSecondsLabelDefined;
  bool get isAdditionalTimerReset => this is AdditionalTimerReset;
  bool get isAdditionalTimerSelected => this is AdditionalTimeLabelSelected;
  bool get isAutoRestDefined => this is AutoRestDefined;
  bool get isStepAutoRestDefined => this is StepAutoRestDefined;
  bool get hasNoAdditionalTime => this is HasNoAdditionalTime;
  bool get hasNoStepAdditionalTime => this is HasNoStepAdditionalTime;
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

class AutoRestDefined implements AdditionalTimerLabelState<bool> {

  final bool iAutoRest;

  const AutoRestDefined({
    required this.iAutoRest,
  });

  @override
  bool get value => iAutoRest;
}

class StepAutoRestDefined implements AdditionalTimerLabelState<bool> {

  final bool iAutoRest;

  const StepAutoRestDefined({
    required this.iAutoRest,
  });

  @override
  bool get value => iAutoRest;
}

class HasNoAdditionalTime implements AdditionalTimerLabelState<dynamic> {

  HasNoAdditionalTime();

  @override
  get value => null;

}

class HasNoStepAdditionalTime implements AdditionalTimerLabelState<dynamic> {

  HasNoStepAdditionalTime();

  @override
  get value => null;

}