part of presentation;

class TimerLabelController extends Cubit<TimerLabelState>{
  String? minuteLabel = '00';
  String? secondsLabel = '00';

  TimerLabelController([TimerLabelState initialState = const InitialTimerLabel()])
    : super(initialState);

  void setMinuteLabel(int minuteValue){
    minuteLabel = minuteValue <= 9 ? '0$minuteValue' : minuteValue.toString();
    emit(MinuteLabelDefined(minuteLabel: minuteLabel));
  }

  void setSecondsLabel(int secondsValue){
    secondsLabel =
      secondsValue <= 9 ? '0$secondsValue' : secondsValue.toString();
    emit(SecondsLabelDefined(secondsLabel: secondsLabel));
  }

  void resetTimer(){
    emit(const TimerReset());
  }

  void selectTimer(String timerSelected){
    emit(TimerLabelSelected(timerSelected: timerSelected));
  }

  void exerciseSelectTimer(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseTimerLabelSelected(exerciseSelected: exerciseSelected));
  }

  void checkAdditional(bool hasAdditionalExercise){
    emit(AdditionalExerciseDefined(
        hasAdditionalExercise: hasAdditionalExercise)
    );
  }

  void checkStepAdditional(bool hasAdditionalExercise){
    emit(StepAdditionalExerciseDefined(
      hasAdditionalExercise: hasAdditionalExercise)
    );
  }

  void isTimeDefined(String minute, String seconds){
    if(minute == '00' &&
        seconds == '00'){
      emit(HasNoTime());
    }
  }

  void isStepTimeDefined(String minute, String seconds){
    if(minute == '00' &&
        seconds == '00'){
      emit(HasNoStepTime());
    }
  }

  void checkAutoRestNoTime(){
    emit(HasNoAdditional());
  }

  void checkStepAutoRestNoTime(){
    emit(HasStepNoAdditionalTime());
  }

}