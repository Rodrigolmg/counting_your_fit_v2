abstract class IndividualExerciseState{}

extension ExerciseStateX on IndividualExerciseState {
  bool get isInitial => this is InitialState;
  bool get isExerciseDefined => this is ExerciseDefined;
  bool get isNextSet => this is NextSet;
  bool get isResting => this is Resting;
  bool get isExecuting => this is Executing;
  bool get isAdditionalFinished => this is AdditionalFinished;
  bool get isExerciseFinished => this is ExerciseFinished;
  bool get isExerciseStarted => this is ExerciseStarted;
  bool get isExerciseStopped => this is ExerciseStopped;
}

class InitialState implements IndividualExerciseState {
  const InitialState();
}

class ExerciseDefined implements IndividualExerciseState{
  final int set;
  final int minute;
  final int seconds;
  final int? additionalMinute;
  final int? additionalSeconds;
  final bool isFinished;

  const ExerciseDefined({
    required this.set,
    required this.minute,
    required this.seconds,
    this.additionalMinute,
    this.additionalSeconds,
    this.isFinished = false
  });

// RegisterIndividualExerciseUseCase registerIndividualExerciseUseCase = GetIt.I.get();
}

class NextSet implements IndividualExerciseState{
  final int nextSet;
  const NextSet({
    required this.nextSet,
  });
}

class Resting implements IndividualExerciseState{
  const Resting();
}

class Executing implements IndividualExerciseState{
  const Executing();
}

class AdditionalFinished implements IndividualExerciseState{
  const AdditionalFinished();
}

class ExerciseFinished implements IndividualExerciseState{
  const ExerciseFinished();
}

class ExerciseStarted implements IndividualExerciseState{
  const ExerciseStarted();
}

class ExerciseStopped implements IndividualExerciseState{
  const ExerciseStopped();
}