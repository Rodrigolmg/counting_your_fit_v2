part of presentation;

class IndividualBeepVolumeStateController extends Cubit<IndividualBeepVolumeState>{

  IndividualBeepVolumeStateController([
    IndividualBeepVolumeState initialState = const IndividualFullVolume(1.0)
  ]) : super(initialState);

  void setVolume(double volume){
    if(volume > .5 && volume <= 1){
      emit(IndividualFullVolume(volume));
    } else if (volume > .3 && volume <= .5){
      emit(IndividualMidVolume(volume));
    } else if(volume > 0 && volume <= .3){
      emit(IndividualLowVolume(volume));
    } else {
      emit(IndividualNoVolume(volume));
    }
  }

  void setVolumeOnClick(double volume){
    emit(volume > 0 ? const IndividualNoVolume(0) : const IndividualFullVolume(1));
  }

}