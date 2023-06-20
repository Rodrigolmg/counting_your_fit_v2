
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdditionalSecondsStateController extends Cubit<AdditionalSecondsState>{
  AdditionalSecondsStateController([
    AdditionalSecondsState initialAdditionalSecondsState = const InitialAdditionalSecond()
  ]) : super(initialAdditionalSecondsState);

  void setAdditionalSeconds(int additionalSeconds){
    emit(AdditionalSecondsDefined(additionalSeconds));
  }

  void selectAdditionalSeconds(int? additionalSecondsSelected){
    emit(AdditionalSecondsSelected(additionalSecondsSelected));
  }

  void selectExerciseAdditionalSeconds(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseAdditionalSecondsSelected(exerciseSelected));
  }

  void resetAdditionalSeconds(){
    emit(const AdditionalSecondsReset());
  }
}