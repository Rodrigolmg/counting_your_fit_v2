


import 'package:bloc/bloc.dart';

enum TimerSettingsStates{
  regular,
  firstPageSelected,
  secondPageSelected,
  minuteValueUpdated,
  secondValueUpdated,
}

extension TimerSettingsStatesX on TimerSettingsStates{
  bool get isFirstPage => this == TimerSettingsStates.firstPageSelected;
  bool get isSecondPage => this == TimerSettingsStates.secondPageSelected;
  bool get isMinuteUpdated => this == TimerSettingsStates.minuteValueUpdated;
  bool get isSecondUpdated => this == TimerSettingsStates.secondValueUpdated;
}

class TimerSettingsStateController extends Cubit<TimerSettingsStates> {

  TimerSettingsStateController(
      [TimerSettingsStates state = TimerSettingsStates.regular]
  ) : super(state);



  void changePageOnClick(int index){
    if(index == 0){
      emit(TimerSettingsStates.firstPageSelected);
    } else {
      emit(TimerSettingsStates.secondPageSelected);
    }
  }

}