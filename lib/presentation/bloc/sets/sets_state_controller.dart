
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetsStateController extends Cubit<SetsState>{
  SetsStateController([
    SetsState initialSetState = const InitialSet()
  ]) : super(initialSetState);

  void setSets(int sets){
    emit(SetDefined(sets));
  }

  void resetSet(){
    emit(const SetReset());
  }

  void selectSet(int setSelected){
    emit(SetSelected(setSelected));
  }

  void exerciseSelectSet(ExerciseSettingEntity exerciseSelected){
    emit(ExerciseSetSelected(exerciseSelected));
  }
}