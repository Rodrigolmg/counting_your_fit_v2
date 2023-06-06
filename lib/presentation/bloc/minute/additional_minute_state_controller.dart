
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdditionalMinuteStateController extends Cubit<AdditionalMinuteState>{
  AdditionalMinuteStateController([
    AdditionalMinuteState initialAdditionalMinuteState = const InitialAdditionalMinute()
  ]) : super(initialAdditionalMinuteState);

  void setAdditionalMinute(int additionalMinute){
    emit(AdditionalMinuteDefined(additionalMinute));
  }

  void selectAdditionalMinute(int? additionalMinuteSelected){
    emit(AdditionalMinuteSelected(additionalMinuteSelected));
  }

  void selectExerciseAdditionalMinute(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseAdditionalMinuteSelected(exerciseSelected));
  }

  void resetAdditionalMinute(){
    emit(const AdditionalMinuteReset());
  }
}