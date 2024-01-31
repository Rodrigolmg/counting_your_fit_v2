part of domain;

class ExerciseScheduleEntity {

  List<ExerciseSettingEntity> exercises;
  bool wantRegister;
  DateTime? dateOfExercise;

  ExerciseScheduleEntity({
    required this.exercises,
    this.wantRegister = false,
    this.dateOfExercise
  });
}