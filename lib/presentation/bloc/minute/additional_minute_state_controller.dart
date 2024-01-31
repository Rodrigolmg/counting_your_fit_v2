part of presentation;

class AdditionalMinuteStateController extends Cubit<AdditionalMinuteState>{
  AdditionalMinuteStateController([
    AdditionalMinuteState initialAdditionalMinuteState = const InitialAdditionalMinute()
  ]) : super(initialAdditionalMinuteState);

  void setAdditionalMinute(int additionalMinute){
    emit(AdditionalMinuteDefined(additionalMinute));
  }

  void selectAdditionalMinute(int? additionalMinuteSelected){
    emit(AdditionalMinuteSelected(additionalMinuteSelected));
  }

  void selectExerciseAdditionalMinute(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseAdditionalMinuteSelected(exerciseSelected));
  }

  void resetAdditionalMinute(){
    emit(const AdditionalMinuteReset());
  }
}