import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';

abstract class ExerciseListDefinitionStates{}

extension ExerciseListDefinitionStatesX on ExerciseListDefinitionStates{
  bool get isInitial => this is InitialState;
  bool get isSingleExerciseDefined => this is SingleExerciseDefined;
  bool get isSingleExerciseSelected => this is ExerciseSelected;
  bool get isExerciseListDefined => this is ExerciseListDefined;
  bool get isNextStep => this is NextStep;
}

class InitialState implements ExerciseListDefinitionStates {
  const InitialState();
}

class SingleExerciseDefined implements ExerciseListDefinitionStates{
  const SingleExerciseDefined();
}

class ExerciseListDefined implements ExerciseListDefinitionStates{
  final List<ExerciseSettingEntity> exercises;
  const ExerciseListDefined(this.exercises);
}

class NextStep implements ExerciseListDefinitionStates{
  final int nextStep;
  const NextStep(this.nextStep);
}

class ExerciseSelected implements ExerciseListDefinitionStates{
  final ExerciseSettingEntity? exerciseSelected;
  const ExerciseSelected({this.exerciseSelected});
}
