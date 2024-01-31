part of presentation;

class ExercisesBeepVolumeStateController extends Cubit<ExercisesBeepVolumeState>{

  ExercisesBeepVolumeStateController([
    ExercisesBeepVolumeState initialState = const FullVolume(1.0)
  ]) : super(initialState);

  void setVolume(double volume){
    if(volume > .5 && volume <= 1){
      emit(FullVolume(volume));
    } else if (volume > .3 && volume <= .5){
      emit(MidVolume(volume));
    } else if(volume > 0 && volume <= .3){
      emit(LowVolume(volume));
    } else {
      emit(NoVolume(volume));
    }
  }

}