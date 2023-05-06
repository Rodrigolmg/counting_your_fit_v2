
import 'package:counting_your_fit_v2/presentation/bloc/steps/steps_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StepStateController extends Cubit<StepsState>{
  StepStateController([
    StepsState initialStepState = const InitialStep()
  ]) : super(initialStepState);

  final List<int> _stepsList = [];

  void setSteps(int steps){
    emit(StepDefined(steps));
    _stepsList.clear();
    for(int i = 1; i <= steps; i ++){
      _stepsList.add(i);
    }
  }

  void nextStep(int nextStepValue){
    emit(NextStep(nextStepValue));
  }

  List<int> get steps => _stepsList;
}