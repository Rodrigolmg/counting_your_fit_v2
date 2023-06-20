
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MinuteStateController extends Cubit<MinuteState>{
  MinuteStateController([
    MinuteState initialMinuteState = const InitialMinute()
  ]) : super(initialMinuteState);

  void setMinute(int minute){
    final timerLabel = GetIt.I.get<TimerLabelController>();
    timerLabel.setMinuteLabel(minute);
    emit(MinuteDefined(minute));
  }

  void selectMinute(int minuteSelected){
    emit(MinuteSelected(minuteSelected));
  }

  void selectExerciseMinute(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseMinuteSelected(exerciseSelected));
  }

  void resetMinute(){
    emit(const MinuteReset());
  }
}