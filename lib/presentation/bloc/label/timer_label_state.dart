abstract class TimerLabelState<T> {
  T get value;
}

extension TimerLabelStateX on TimerLabelState{
  bool get isInitialLabel => this is InitialTimerLabel;
  bool get isMinuteLabelDefined => this is MinuteLabelDefined;
  bool get isSecondsLabelDefined => this is SecondsLabelDefined;
  bool get isTimerReset => this is TimerReset;
  bool get isTimerSelected => this is TimerLabelSelected;
  bool get hasAdditionalExercise => this is AdditionalExerciseDefined;
  bool get hasStepAdditionalExercise => this is StepAdditionalExerciseDefined;
}

class InitialTimerLabel implements TimerLabelState<String?> {
  final String? initialLabel;
  const InitialTimerLabel({this.initialLabel = '00:00'});

  @override
  String? get value => initialLabel;
}

class MinuteLabelDefined implements TimerLabelState<String?>{
  final String? minuteLabel;
  const MinuteLabelDefined({this.minuteLabel = '00'});

  @override
  String? get value => minuteLabel;
}

class SecondsLabelDefined implements TimerLabelState<String?>{
  final String? secondsLabel;

  const SecondsLabelDefined({this.secondsLabel = '00'});

  @override
  String? get value => secondsLabel;
}

class TimerLabelSelected implements TimerLabelState<String?>{
  final String? timerSelected;

  const TimerLabelSelected({this.timerSelected});

  @override
  String? get value => timerSelected;
}

class TimerReset implements TimerLabelState<String?>{
  const TimerReset();

  @override
  String? get value => null;
}

class AdditionalExerciseDefined implements TimerLabelState<bool>{
  final bool hasAdditionalExercise;

  const AdditionalExerciseDefined({
    required this.hasAdditionalExercise,
  });

  @override
  bool get value => hasAdditionalExercise;
}

class StepAdditionalExerciseDefined implements TimerLabelState<bool>{
  final bool hasAdditionalExercise;

  const StepAdditionalExerciseDefined({
    required this.hasAdditionalExercise,
  });

  @override
  bool get value => hasAdditionalExercise;
}