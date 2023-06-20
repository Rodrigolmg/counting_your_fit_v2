
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';

abstract class RegisterSingleExerciseListUseCase{
  Future<ExerciseSettingEntity> call({
    required int id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute,
    int? additionalSecond,
    bool isFinished = false,
    bool hasAdditionalTime = false,
    bool isAutoRest = false,
  });
}

class RegisterSingleExerciseListUseCaseImpl implements RegisterSingleExerciseListUseCase{
  @override
  Future<ExerciseSettingEntity> call({
    required int id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute, int?
    additionalSecond,
    bool isFinished = false,
    bool hasAdditionalTime = false,
    bool isAutoRest = false
  }) async {
    ExerciseSettingEntity exercise = ExerciseSettingEntity(
      id: id,
      set: set!,
      minute: minute!,
      seconds: seconds!,
      additionalMinute: additionalMinute,
      additionalSeconds: additionalSecond,
      isFinished: isFinished,
      hasAdditionalTime: hasAdditionalTime,
      isAutoRest: isAutoRest
    );
    return exercise;
  }
}