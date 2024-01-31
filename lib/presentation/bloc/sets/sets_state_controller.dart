part of presentation;

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