part of presentation;

class SecondsStateController extends Cubit<SecondsState>{
  SecondsStateController([
    SecondsState initialSecondsState = const InitialSecond()
  ]) : super(initialSecondsState);

  void setSeconds(int seconds){
    final timerLabel = GetIt.I.get<TimerLabelController>();
    timerLabel.setSecondsLabel(seconds);
    emit(SecondsDefined(seconds));
  }

  void resetSeconds(){
    emit(const SecondsReset());
  }

  void selectSeconds(int secondsSelected){
    emit(SecondsSelected(secondsSelected));
  }

  void selectExerciseSeconds(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseSecondsSelected(exerciseSelected));
  }
}