class ExerciseSettingEntity{
  int? id;
  int set;
  int minute;
  int seconds;
  int? additionalMinute;
  int? additionalSeconds;
  bool? isFinished;

  ExerciseSettingEntity({
    this.id,
    required this.set,
    required this.minute,
    required this.seconds,
    this.additionalMinute,
    this.additionalSeconds,
    this.isFinished = false,
  });
}