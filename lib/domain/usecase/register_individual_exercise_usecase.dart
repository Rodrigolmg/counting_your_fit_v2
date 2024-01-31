part of domain;

abstract class RegisterIndividualExerciseUseCase{
  Future<ExerciseSettingEntity> call({
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute,
    int? additionalSecond,
    bool isFinished = false
  });
}

class RegisterIndividualExerciseUseCaseImpl implements RegisterIndividualExerciseUseCase{
  @override
  Future<ExerciseSettingEntity> call({
    int? set,
    int? minute,
    int? seconds,
    int? additionalMinute,
    int? additionalSecond,
    bool isFinished = false
  }) async {
    return await Future.value(ExerciseSettingEntity(
        set: set!,
        minute: minute!,
        seconds: seconds!,
        additionalMinute: additionalMinute,
        additionalSeconds: additionalSecond,
        isFinished: isFinished
    ));
  }


}