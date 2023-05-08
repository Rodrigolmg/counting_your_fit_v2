abstract class IndividualExerciseState{}

extension ExerciseStateX on IndividualExerciseState {
  bool get isInitial => this is InitialState;
  bool get isExerciseDefined => this is ExerciseDefined;
  bool get isNextSet => this is NextSet;
  bool get isAdditionalFinished => this is AdditionalFinished;
  bool get isExerciseFinished => this is ExerciseFinished;
}

class InitialState implements IndividualExerciseState {
  const InitialState();
}

class ExerciseDefined implements IndividualExerciseState{
  const ExerciseDefined({
    required int set,
    required int minute,
    required int seconds,
    int? additionalMinute,
    int? additionalSeconds,
    bool isFinished = false
  });

  // RegisterIndividualExerciseUseCase registerIndividualExerciseUseCase = GetIt.I.get();
}

class NextSet implements IndividualExerciseState{
  final int nextSet;
  const NextSet({
    required this.nextSet,
  });
}

class AdditionalFinished implements IndividualExerciseState{
  const AdditionalFinished();
}

class ExerciseFinished implements IndividualExerciseState{
  const ExerciseFinished();
}