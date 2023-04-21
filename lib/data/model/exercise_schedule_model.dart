import 'package:counting_your_fit_v2/data/model/exercise_setting_model.dart';

class ExerciseScheduleModel {

  List<ExerciseSettingModel> exercises;
  bool wantRegister;
  DateTime? dateOfExercise;

  ExerciseScheduleModel({
    required this.exercises,
    this.wantRegister = false,
    this.dateOfExercise
  });
}