import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';

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