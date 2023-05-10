
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';

abstract class RegisterExerciseListUseCase{
  Future<List<ExerciseSettingEntity>> call({
    required int id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute,
    int? additionalSecond,
    bool isFinished = false,
    bool isAutoRest = false,
  });
}

class RegisterExerciseListUseCaseImpl implements RegisterExerciseListUseCase{
  final List<ExerciseSettingEntity> _exercises = [];

  @override
  Future<List<ExerciseSettingEntity>> call({
    required int id,
    required int? set,
    required int? minute,
    required int? seconds,
    int? additionalMinute, int?
    additionalSecond,
    bool isFinished = false,
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
      isAutoRest: isAutoRest
    );

    _exercises.add(exercise);
    return _exercises;
  }
}