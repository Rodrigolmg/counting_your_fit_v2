part of domain;

class ExerciseSettingEntity{
  int? id;
  int set;
  int minute;
  int seconds;
  int? additionalMinute;
  int? additionalSeconds;
  bool? isFinished;
  bool? isAutoRest;
  bool? hasAdditionalTime;

  ExerciseSettingEntity({
    this.id,
    required this.set,
    required this.minute,
    required this.seconds,
    this.additionalMinute,
    this.additionalSeconds,
    this.hasAdditionalTime = false,
    this.isFinished = false,
    this.isAutoRest = false,
  });
}