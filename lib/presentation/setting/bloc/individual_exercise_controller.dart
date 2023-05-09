import 'package:bloc/bloc.dart';
import 'package:counting_your_fit_v2/domain/usecase/register_individual_exercise_usecase.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercise_states.dart';
import 'package:get_it/get_it.dart';

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

  void rest(){
    emit(const Resting());
  }

  void execute(){
    emit(const Executing());
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