import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';

class ExerciseSettingModel extends ExerciseSettingEntity {

  ExerciseSettingModel({
    int? id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute,
    int? additionalSeconds,
    bool isFinished = false,
  }) : super(
    id: id,
    set: set!,
    minute: minute!,
    seconds: seconds!,
    additionalSeconds: additionalSeconds,
    additionalMinute: additionalMinute,
    isFinished: isFinished
  );

  factory ExerciseSettingModel.fromJson(Map<String, dynamic> json){
    return ExerciseSettingModel(
      id: json['id'],
      set: json['set'],
      minute: json['minute'],
      seconds: json['seconds'],
      additionalMinute: json['additional_minute'],
      additionalSeconds: json['additional_seconds'],
      isFinished: json['is_finished']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'set': set,
      'minute': minute,
      'seconds': seconds,
      'additional_minute': additionalMinute,
      'additional_seconds': additionalSeconds,
      'is_finished': isFinished
    };
  }
}