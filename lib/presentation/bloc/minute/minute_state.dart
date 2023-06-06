import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';

abstract class MinuteState{}

extension MinuteStateX on MinuteState {
  bool get isInitialMinute => this is InitialMinute;
  bool get isMinuteDefined => this is MinuteDefined;
  bool get isMinuteReset => this is MinuteReset;
  bool get isMinuteSelected => this is MinuteSelected;
  bool get isExerciseMinuteSelected => this is ExerciseMinuteSelected;
}

class InitialMinute implements MinuteState {
  final int initialMinuteValue = 0;
  const InitialMinute();
}

class MinuteDefined implements MinuteState {
  final int minute;
  const MinuteDefined(this.minute);
}

class MinuteSelected implements MinuteState {
  final int minuteSelected;
  const MinuteSelected(this.minuteSelected);


}class ExerciseMinuteSelected implements MinuteState {
  final ExerciseSettingEntity exerciseSelected;
  const ExerciseMinuteSelected(this.exerciseSelected);
}

class MinuteReset implements MinuteState{
  const MinuteReset();
}