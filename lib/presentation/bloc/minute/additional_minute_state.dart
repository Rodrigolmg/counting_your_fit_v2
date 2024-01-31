part of presentation;

abstract class AdditionalMinuteState{}

extension AdditionalMinuteStateX on AdditionalMinuteState {
  bool get isInitialAddititionalMinute => this is InitialAdditionalMinute;
  bool get isAdditionalMinuteDefined => this is AdditionalMinuteDefined;
  bool get isAdditionalMinuteReset => this is AdditionalMinuteReset;
  bool get isAdditionalMinuteSelected => this is AdditionalMinuteSelected;
  bool get isExerciseAdditionalMinuteSelected => this is ExerciseAdditionalMinuteSelected;
}

class InitialAdditionalMinute implements AdditionalMinuteState {
  final int initialAdditionalMinuteValue = 0;
  const InitialAdditionalMinute();
}

class AdditionalMinuteDefined implements AdditionalMinuteState {
  final int additionalMinute;
  const AdditionalMinuteDefined(this.additionalMinute);
}

class AdditionalMinuteSelected implements AdditionalMinuteState {
  final int? additionalMinuteSelected;
  const AdditionalMinuteSelected(this.additionalMinuteSelected);
}

class ExerciseAdditionalMinuteSelected implements AdditionalMinuteState {
  final ExerciseSettingEntity exerciseSelected;
  const ExerciseAdditionalMinuteSelected(this.exerciseSelected);
}

class AdditionalMinuteReset implements AdditionalMinuteState {
  const AdditionalMinuteReset();
}