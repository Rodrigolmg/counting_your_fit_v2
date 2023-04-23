

class ExerciseSettingModel{

  int? id;
  int set;
  int minute;
  int second;
  int? additionalMinute;
  int? additionalSeconds;
  bool? isFinished;

  ExerciseSettingModel({
    this.id,
    required this.set,
    required this.minute,
    required this.second,
    this.additionalMinute,
    this.additionalSeconds,
    this.isFinished = false,
  });
}