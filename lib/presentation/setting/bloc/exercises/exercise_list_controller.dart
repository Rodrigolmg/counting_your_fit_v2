import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/domain/usecase/register_exercise_list_usecase.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ExerciseListDefinitionController extends Cubit<ExerciseListDefinitionStates>{

  ExerciseListDefinitionController([
    ExerciseListDefinitionStates initialState = const InitialState()
  ]) : super(initialState);

  Future<ExerciseSettingEntity> registerSingleExercise({
    required int id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute,
    int? additionalSecond,
    bool hasAdditionalTime = false,
    bool isAutoRest = false,
  }) async {
    RegisterSingleExerciseListUseCase useCase = GetIt.I.get();
    ExerciseSettingEntity exerciseDefined = await useCase(
        id: id,
        set: set!,
        minute: minute!,
        seconds: seconds!,
        additionalMinute: additionalMinute,
        additionalSecond: additionalSecond,
        isFinished: false,
        hasAdditionalTime: hasAdditionalTime,
        isAutoRest: isAutoRest
    );
    emit(const SingleExerciseDefined());
    return exerciseDefined;
  }

  void defineExerciseList(List<ExerciseSettingEntity> exercises){
    emit(ExerciseListDefined(exercises));
  }

  void executeCurrent(){
    emit(const CurrentExerciseExecuting());
  }

  void restCurrent(){
    emit(const CurrentExerciseResting());
  }

  void nextExercise(int nextExercise){
    emit(NextExercise(nextExercise));
  }

  void nextExerciseSet(int nextExerciseSet){
    emit(CurrentExerciseNextSet(nextExerciseSet));
  }

  void finishCurrentRest(){
    emit(const CurrentExerciseRestFinished());
  }

  void finishCurrentExecute(){
    emit(const CurrentExerciseExecuteFinished());
  }

  void finishCurrentExercise(){
    emit(const CurrentExerciseExecuteFinished());
  }

  void selectExercise({ExerciseSettingEntity? exercise}){
    emit(ExerciseSelected(exerciseSelected: exercise));
  }

}