import 'package:bloc/bloc.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercise_states.dart';

class ExerciseController extends Cubit<ExerciseState>{

  ExerciseController([
    ExerciseState state = const InitialState(),
  ]) : super(state);

  // INDIVIDUAL EXERCISE
  void setSets(int sets){
    emit(SetsUpdate(sets));
  }

  void setMinute(int minute){
    String minutes = minute <= 9 ? '0$minute' : minute.toString();
    emit(MinuteUpdated(minute));
  }

  void setSeconds(int seconds){
    String secondsEdited = seconds <= 9 ? '0$seconds' : seconds.toString();
    emit(SecondsUpdated(seconds));
  }

  void setAdditionalMinute(int minute){
    String additionalMinutes = minute <= 9 ? '0$minute' : minute.toString();
    emit(AdditionalMinuteUpdated(additionalMinutes));
  }

  void setAdditionalSeconds(int seconds){
    String additionalSeconds = seconds <= 9 ? '0$seconds' : seconds.toString();
    emit(AdditionalSecondsUpdated(additionalSeconds));
  }

  // LIST EXERCISE
  void setMinuteStep(int minute){
    String minutes = minute <= 9 ? '0$minute' : minute.toString();
    emit(MinuteUpdatedStep(minutes));
  }

  void setSecondsStep(int seconds){
    String secondsEdited = seconds <= 9 ? '0$seconds' : seconds.toString();
    emit(SecondsUpdatedStep(secondsEdited));
  }

  void setAdditionalMinuteStep(int minute){
    String additionalMinutes = minute <= 9 ? '0$minute' : minute.toString();
    emit(AdditionalMinuteUpdatedStep(additionalMinutes));
  }

  void setAdditionalSecondsStep(int seconds){
    String additionalSeconds = seconds <= 9 ? '0$seconds' : seconds.toString();
    emit(AdditionalSecondsUpdatedStep(additionalSeconds));
  }

  void setSetsStep(int sets){
    emit(SetsUpdateStep(sets));
  }

  void setSteps(int steps){
    emit(StepsUpdate(steps));
  }

  void nextExercise(int step){
    step++;
    emit(CurrentStepFinished(step));
  }

  void resetAdditionals(){
  }
}