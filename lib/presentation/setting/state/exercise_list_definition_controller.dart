import 'package:flutter_bloc/flutter_bloc.dart';

enum ExerciseListDefinitionStates{
  initialState,
  listDefined,
  stepCompleted
}

extension ExerciseListDefinitionStatesX on ExerciseListDefinitionStates{
  bool get isInitialState => this == ExerciseListDefinitionStates.initialState;
  bool get isListDefined => this == ExerciseListDefinitionStates.listDefined;
  bool get isStepCompleted => this == ExerciseListDefinitionStates.stepCompleted;
}

class ExerciseListDefinitionController extends Cubit<ExerciseListDefinitionStates>{

  ExerciseListDefinitionController([
    ExerciseListDefinitionStates state = ExerciseListDefinitionStates.initialState
  ]) : super(state);

}