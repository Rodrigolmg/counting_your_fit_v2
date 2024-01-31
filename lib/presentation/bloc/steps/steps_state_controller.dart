part of presentation;

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
    nextStepValue++;
    emit(NextStep(nextStepValue));
  }

  void selectStep(int stepSelected){
    emit(StepSelected(stepSelected));
  }

  void resetStep(){
    emit(StepReset());
  }

  List<int> get steps => _stepsList;
}