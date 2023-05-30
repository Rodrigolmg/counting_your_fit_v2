
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdditionalTimerLabelController extends Cubit<AdditionalTimerLabelState>{
  String? minuteLabel = '00';
  String? secondsLabel = '00';

  AdditionalTimerLabelController([AdditionalTimerLabelState initialState =
    const InitialAdditionalTimerLabel()]) : super(initialState);

  void setMinuteLabel(int minuteValue){
    minuteLabel = minuteValue <= 9 ? '0$minuteValue' : minuteValue.toString();
    emit(AdditionalMinuteLabelDefined(minuteLabel: minuteLabel));
  }

  void setSecondsLabel(int secondsValue){
    secondsLabel =
    secondsValue <= 9 ? '0$secondsValue' : secondsValue.toString();
    emit(AdditionalSecondsLabelDefined(secondsLabel: secondsLabel));
  }

  void selectAdditionalTimer(String additionalTimerSelected){
    emit(AdditionalTimeLabelSelected(additionalTimeSelected: additionalTimerSelected));
  }

  void resetAdditionalTimer(){
    emit(const AdditionalTimerReset());
  }

  void checkAutoRest(bool isAutoRest){
    emit(AutoRestDefined(iAutoRest: isAutoRest));
  }

  void checkStepAutoRest(bool isAutoRest){
    emit(StepAutoRestDefined(iAutoRest: isAutoRest));
  }

  void isTimeDefined(String minuteLabel, String secondsLabel){
    if(minuteLabel == '00' ||
        secondsLabel == '00'){
      emit(HasNoAdditionalTime());
    }
  }

  void isStepTimeDefined(String minuteLabel, String secondsLabel){
    if(minuteLabel == '00' ||
        secondsLabel == '00'){
      emit(HasNoStepAdditionalTime());
    }
  }

}