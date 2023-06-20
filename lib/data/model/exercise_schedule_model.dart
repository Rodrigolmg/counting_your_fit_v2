import 'package:counting_your_fit_v2/data/model/exercise_setting_model.dart';
import 'package:counting_your_fit_v2/domain/entities/exercise_schedule_entity.dart';

class ExerciseScheduleModel extends ExerciseScheduleEntity{

  ExerciseScheduleModel({
    required List<ExerciseSettingModel> exercises,
    bool wantRegister = false,
    DateTime? dateOfExercise
  }) : super(
    exercises: exercises,
    wantRegister: wantRegister,
    dateOfExercise: dateOfExercise
  );

  factory ExerciseScheduleModel.fromJson(Map<String, dynamic> json){
    return ExerciseScheduleModel(
      exercises: json['exercises'],
      wantRegister: json['want_register'],
      dateOfExercise: DateTime.tryParse(json['exercise_date'])
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'exercises': exercises,
      'want_register': wantRegister,
      'dateOfExercise': dateOfExercise?.toIso8601String()
    };
  }
}