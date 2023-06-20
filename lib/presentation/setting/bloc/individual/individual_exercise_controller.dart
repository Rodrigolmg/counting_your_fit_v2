import 'package:bloc/bloc.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/individual/individual_exercise_states.dart';

class IndividualExerciseController extends Cubit<IndividualExerciseState>{

  IndividualExerciseController([
    IndividualExerciseState state = const InitialState(),
  ]) : super(state);

  void registerIndividualExercise({
    required int set,
    required int minute,
    required int seconds,
    int? additionalMinute,
    int? additionalSeconds,
    bool isAutoRest = false
  }){
    emit(
      ExerciseDefined(
        set: set,
        minute: minute,
        seconds: seconds,
        additionalMinute: additionalMinute,
        additionalSeconds: additionalSeconds,
        isAutoRest: isAutoRest
      )
    );
  }

  void startExercise(){
    emit(const ExerciseStarted());
  }

  bool rest(){
    emit(const Resting());
    return false;
  }

  bool execute(){
    emit(const Executing());
    return false;
  }

  void cancelExecution(){
    emit(const ExerciseStopped());
  }

  void setNextSet(int nextSet){
    nextSet++;
    emit(NextSet(nextSet: nextSet));
  }

  void finishExercise(){
    emit(const ExerciseFinished());
  }

  void finishExecuting(){
    emit(const ExecuteFinished());
  }

  void finishResting(){
    emit(const RestFinished());
  }
}