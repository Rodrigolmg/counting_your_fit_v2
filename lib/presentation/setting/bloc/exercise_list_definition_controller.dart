import 'package:counting_your_fit_v2/data/model/exercise_setting_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ExerciseListDefinitionStates{
  initialState,
  exerciseListDefined,
  stepQuantityDefined,
  stepListDefined,
  stepCompleted,
  lastExercise
}

extension ExerciseListDefinitionStatesX on ExerciseListDefinitionStates{
  bool get isInitialState => this == ExerciseListDefinitionStates.initialState;
  bool get isListDefined => this == ExerciseListDefinitionStates.exerciseListDefined;
  bool get isStepQuantityDefined => this == ExerciseListDefinitionStates.stepQuantityDefined;
  bool get isStepListDefined => this == ExerciseListDefinitionStates.stepListDefined;
  bool get isStepCompleted => this == ExerciseListDefinitionStates.stepCompleted;
  bool get isLastExercise => this == ExerciseListDefinitionStates.lastExercise;
}

class ExerciseListDefinitionStateController extends Cubit<ExerciseListDefinitionStates>{

  ExerciseListDefinitionStateController([
    ExerciseListDefinitionStates state = ExerciseListDefinitionStates.initialState
  ]) : super(state);

  String _minutes = '00';
  String _seconds = '00';
  String _additionalMinutes = '00';
  String _additionalSeconds = '00';
  int _pageIndex = 0;
  int _sets = 1;
  int _exerciseId = 1;
  int _stepQuantity = 2;

  final List<ExerciseSettingModel> _exercises = [];
  final List<int> _steps = [];

  void setMinute(int minute){
    _minutes = minute <= 9 ? '0$minute' : minute.toString();
  }

  void setSeconds(int seconds){
    _seconds = seconds <= 9 ? '0$seconds' : seconds.toString();
  }

  void setAdditionalMinute(int minute){
    _additionalMinutes = minute <= 9 ? '0$minute' : minute.toString();
  }

  void setAdditionalSeconds(int seconds){
    _additionalSeconds = seconds <= 9 ? '0$seconds' : seconds.toString();
  }

  void setSets(int sets){
    _sets = sets;
  }

  void setSteps(int stepValue){
    _stepQuantity = stepValue;
     emit(ExerciseListDefinitionStates.stepQuantityDefined);
  }

  Future<void> defineStepList() async {
    for(int i = 1; i <= _stepQuantity; i++){
      _steps.add(i);
    }

    if(_steps.length == _stepQuantity){
      emit(ExerciseListDefinitionStates.stepListDefined);
    }
  }

  void nextExercise(){
    ExerciseSettingModel exercise = ExerciseSettingModel(
      id: _exerciseId,
      set: _sets,
      minute: int.parse(_minutes),
      second: int.parse(_seconds),
      additionalMinute: int.parse(_additionalMinutes),
      additionalSeconds: int.parse(_additionalSeconds)
    );

    if(!_exercises.contains(exercise)){
      _exercises.add(exercise);
    }

    _pageIndex++;
    _exerciseId++;

    emit(ExerciseListDefinitionStates.stepCompleted);
  }

  void selectExercise(int index){
    _pageIndex = index;
    ExerciseSettingModel? exerciseToEdit = _exercises[index];

  }

  void previousExercise(ExerciseSettingModel exercise){
    _pageIndex--;

  }

  void resetAdditionals(){
    _additionalMinutes = '00';
    _additionalSeconds = '00';
  }

  int get pageIndex => _pageIndex;
  int get stepQuantity => _stepQuantity;
  List<int> get steps => _steps;
  int get sets => _sets;
  String get minutes => _minutes;
  String get seconds => _seconds;
  String get additionalMinutes => _additionalMinutes;
  String get additionalSeconds => _additionalSeconds;
}