part of presentation;

class AdditionalSecondsStateController extends Cubit<AdditionalSecondsState>{
  AdditionalSecondsStateController([
    AdditionalSecondsState initialAdditionalSecondsState = const InitialAdditionalSecond()
  ]) : super(initialAdditionalSecondsState);

  void setAdditionalSeconds(int additionalSeconds){
    emit(AdditionalSecondsDefined(additionalSeconds));
  }

  void selectAdditionalSeconds(int? additionalSecondsSelected){
    emit(AdditionalSecondsSelected(additionalSecondsSelected));
  }

  void selectExerciseAdditionalSeconds(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseAdditionalSecondsSelected(exerciseSelected));
  }

  void resetAdditionalSeconds(){
    emit(const AdditionalSecondsReset());
  }
}