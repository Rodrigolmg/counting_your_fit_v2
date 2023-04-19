


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

  String _minutes = '00';
  String _seconds = '00';
  String _additionalMinutes = '00';
  String _additionalSeconds = '00';
  int _sets = 1;

  void changePageOnClick(int index){
    if(index == 0){
      emit(TimerSettingsStates.firstPageSelected);
    } else {
      emit(TimerSettingsStates.secondPageSelected);
    }
  }

  void setMinute(int minute){
    _minutes = minute <= 9 ? '0$minute' : minute.toString();
    emit(TimerSettingsStates.minuteValueUpdated);
  }

  void setSeconds(int seconds){
    _seconds = seconds <= 9 ? '0$seconds' : seconds.toString();
    emit(TimerSettingsStates.secondValueUpdated);
  }

  void setAdditionalMinute(int minute){
    _additionalMinutes = minute <= 9 ? '0$minute' : minute.toString();
  }

  void setAdditionalSeconds(int seconds){
    _additionalSeconds = seconds <= 9 ? '0$seconds' : seconds.toString();
  }

  void resetAddionals(){
    _additionalMinutes = '00';
    _additionalSeconds = '00';
  }

  void setSets(int sets){
    _sets = sets;
  }

  String get minutes => _minutes;
  String get seconds => _seconds;
  String get additionalMinutes => _additionalMinutes;
  String get additionalSeconds => _additionalSeconds;
  int get sets => _sets;

}