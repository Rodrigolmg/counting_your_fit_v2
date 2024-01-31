part of presentation;

abstract class ExerciseListDefinitionStates{}

extension ExerciseListDefinitionStatesX on ExerciseListDefinitionStates{
  bool get isInitial => this is ExerciseInitialState;
  bool get isSingleExerciseDefined => this is SingleExerciseDefined;
  bool get isSingleExerciseSelected => this is ExerciseSelected;
  bool get isExerciseListDefined => this is ExerciseListDefined;
  bool get isExerciseListFinished => this is ExerciseListFinished;
  bool get isCurrentResting => this is CurrentExerciseResting;
  bool get isCurrentExecuting => this is CurrentExerciseExecuting;
  bool get isCurrentRestFinished => this is CurrentExerciseRestFinished;
  bool get isCurrentExecuteFinished => this is CurrentExerciseExecuteFinished;
  bool get isCurrentExerciseFinished => this is CurrentExerciseFinished;
  bool get isCurrentNextSet => this is CurrentExerciseNextSet;
  bool get isNextExercise => this is NextExercise;
}

class ExerciseInitialState implements ExerciseListDefinitionStates {
  const ExerciseInitialState();
}

class SingleExerciseDefined implements ExerciseListDefinitionStates{
  const SingleExerciseDefined();
}

class CurrentExerciseResting implements ExerciseListDefinitionStates{
  const CurrentExerciseResting();
}

class CurrentExerciseExecuting implements ExerciseListDefinitionStates{
  const CurrentExerciseExecuting();
}

class CurrentExerciseRestFinished implements ExerciseListDefinitionStates{
  const CurrentExerciseRestFinished();
}

class CurrentExerciseExecuteFinished implements ExerciseListDefinitionStates{
  const CurrentExerciseExecuteFinished();
}

class CurrentExerciseFinished implements ExerciseListDefinitionStates{
  const CurrentExerciseFinished();
}

class CurrentExerciseNextSet implements ExerciseListDefinitionStates{
  final int nextSet;
  const CurrentExerciseNextSet(this.nextSet);
}

class ExerciseListDefined implements ExerciseListDefinitionStates{
  final List<ExerciseSettingEntity> exercises;
  const ExerciseListDefined(this.exercises);
}

class ExerciseListFinished implements ExerciseListDefinitionStates{
  const ExerciseListFinished();
}

class NextExercise implements ExerciseListDefinitionStates{
  final int nextExercise;
  const NextExercise(this.nextExercise);
}

class ExerciseSelected implements ExerciseListDefinitionStates{
  final ExerciseSettingEntity? exerciseSelected;
  const ExerciseSelected({this.exerciseSelected});
}
