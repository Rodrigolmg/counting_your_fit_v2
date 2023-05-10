import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/domain/usecase/register_exercise_list_usecase.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ExerciseListDefinitionController extends Cubit<ExerciseListDefinitionStates>{

  ExerciseListDefinitionController([
    ExerciseListDefinitionStates initialState = const InitialState()
  ]) : super(initialState);

  final List<ExerciseSettingEntity> _exercises = [];

  void registerSingleExercise({
    required int id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute,
    int? additionalSecond,
    bool isAutoRest = false
  }) async {
    RegisterExerciseListUseCase useCase = GetIt.I.get();
    _exercises.addAll(
      List.from(await useCase(
          id: id,
          set: set!,
          minute: minute!,
          seconds: seconds!,
          additionalMinute: additionalMinute,
          additionalSecond: additionalSecond,
          isFinished: false,
          isAutoRest: isAutoRest
        )
      )
    );

    emit(const SingleExerciseDefined());
  }

  void defineExerciseList(){
    emit(ExerciseListDefined(_exercises));
  }

  void nextStep(int nextStep){
    emit(NextStep(nextStep));
  }

  void selectExercise(int index){
    if(_exercises.isNotEmpty && _exercises.length >= index + 1){
      emit(ExerciseSelected(_exercises[index]));
    }
  }

}