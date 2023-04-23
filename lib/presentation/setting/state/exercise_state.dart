import 'package:bloc/bloc.dart';

enum ExerciseStates{
  initialState,
  setsUpdate,
  minuteValueUpdated,
  secondValueUpdated,
}

extension ExerciseStatesX on ExerciseStates{
  bool get isInitial => this == ExerciseStates.initialState;
  bool get isSetUpdated => this == ExerciseStates.setsUpdate;
  bool get isMinuteUpdated => this == ExerciseStates.minuteValueUpdated;
  bool get isSecondUpdated => this == ExerciseStates.secondValueUpdated;
}

class ExerciseController extends Cubit<ExerciseStates>{

  ExerciseController([
    ExerciseStates state = ExerciseStates.initialState
  ]) : super(state);

  String _minutes = '00';
  String _seconds = '00';
  String _additionalMinutes = '00';
  String _additionalSeconds = '00';
  int _sets = 1;

  void setMinute(int minute){
    _minutes = minute <= 9 ? '0$minute' : minute.toString();
    emit(ExerciseStates.minuteValueUpdated);
  }

  void setSeconds(int seconds){
    _seconds = seconds <= 9 ? '0$seconds' : seconds.toString();
    emit(ExerciseStates.secondValueUpdated);
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