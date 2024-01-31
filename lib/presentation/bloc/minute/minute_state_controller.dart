part of presentation;

class MinuteStateController extends Cubit<MinuteState>{
  MinuteStateController([
    MinuteState initialMinuteState = const InitialMinute()
  ]) : super(initialMinuteState);

  void setMinute(int minute){
    final timerLabel = GetIt.I.get<TimerLabelController>();
    timerLabel.setMinuteLabel(minute);
    emit(MinuteDefined(minute));
  }

  void selectMinute(int minuteSelected){
    emit(MinuteSelected(minuteSelected));
  }

  void selectExerciseMinute(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseMinuteSelected(exerciseSelected));
  }

  void resetMinute(){
    emit(const MinuteReset());
  }
}