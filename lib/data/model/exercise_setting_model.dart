part of data;

class ExerciseSettingModel extends ExerciseSettingEntity {

  ExerciseSettingModel({
    int? id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute,
    int? additionalSeconds,
    bool hasAdditionalTime= false,
    bool isFinished = false,
    bool isAutoRest = false,
  }) : super(
    id: id,
    set: set!,
    minute: minute!,
    seconds: seconds!,
    additionalSeconds: additionalSeconds,
    additionalMinute: additionalMinute,
    hasAdditionalTime: hasAdditionalTime,
    isAutoRest: isAutoRest,
    isFinished: isFinished,
  );

  factory ExerciseSettingModel.fromJson(Map<String, dynamic> json){
    return ExerciseSettingModel(
      id: json['id'],
      set: json['set'],
      minute: json['minute'],
      seconds: json['seconds'],
      additionalMinute: json['additional_minute'],
      additionalSeconds: json['additional_seconds'],
      hasAdditionalTime: json['has_additional'],
      isAutoRest: json['is_auto'],
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
      'has_additional': hasAdditionalTime,
      'is_auto': isAutoRest,
      'is_finished': isFinished
    };
  }
}