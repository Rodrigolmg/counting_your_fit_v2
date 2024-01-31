part of presentation;

abstract class SecondsState{}

extension SecondsStateX on SecondsState{
  bool get isInitialSecond => this is InitialSecond;
  bool get isSecondsDefined => this is SecondsDefined;
  bool get isSecondsReset => this is SecondsReset;
  bool get isSecondsSelected => this is SecondsSelected;
  bool get isExerciseSecondsSelected => this is ExerciseSecondsSelected;
}

class InitialSecond implements SecondsState {
  final int initialSecondValue = 0;
  const InitialSecond();
}

class SecondsDefined implements SecondsState {
  final int seconds;
  const SecondsDefined(this.seconds);
}

class SecondsSelected implements SecondsState {
  final int secondsSelected;
  const SecondsSelected(this.secondsSelected);
}

class ExerciseSecondsSelected implements SecondsState {
  final ExerciseSettingEntity exerciseSelected;
  const ExerciseSecondsSelected(this.exerciseSelected);
}

class SecondsReset implements SecondsState {
  const SecondsReset();
}