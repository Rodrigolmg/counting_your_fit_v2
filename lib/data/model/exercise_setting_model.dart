

class ExerciseSettingModel{

  int? id;
  int set;
  int minute;
  int second;
  bool? isFinished;

  ExerciseSettingModel({
    this.id,
    required this.set,
    required this.minute,
    required this.second,
    this.isFinished = false,
  });
}