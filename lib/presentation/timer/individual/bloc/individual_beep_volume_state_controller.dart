import 'package:counting_your_fit_v2/presentation/timer/individual/bloc/individual_beep_volume_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndividualBeepVolumeStateController extends Cubit<IndividualBeepVolumeState>{

  IndividualBeepVolumeStateController([
    IndividualBeepVolumeState initialState = const FullVolume(1.0)
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

  void setVolumeOnClick(double volume){
    emit(volume > 0 ? const NoVolume(0) : const FullVolume(1));
  }

}