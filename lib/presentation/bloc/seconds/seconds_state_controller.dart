
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SecondsStateController extends Cubit<SecondsState>{
  SecondsStateController([
    SecondsState initialSecondsState = const InitialSecond()
  ]) : super(initialSecondsState);

  void setSeconds(int seconds){
    final timerLabel = GetIt.I.get<TimerLabelController>();
    timerLabel.setSecondsLabel(seconds);
    emit(SecondsDefined(seconds));
  }
}