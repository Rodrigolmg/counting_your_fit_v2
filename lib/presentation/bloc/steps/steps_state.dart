part of presentation;

abstract class StepsState{
  dynamic get value;
}

extension StepsStateX on StepsState{
  bool get isInitialStep => this is InitialStep;
  bool get isStepDefined => this is StepDefined;
  bool get isNextStep => this is NextStep;
  bool get isStepSelected => this is StepSelected;
  bool get isStepReset => this is StepSelected;
}

class InitialStep implements StepsState {
  final int initialStepValue = 1;
  const InitialStep();

  @override
  get value => initialStepValue;
}

class StepDefined implements StepsState {
  final int steps;
  const StepDefined(this.steps);

  @override
  get value => steps;
}

class NextStep implements StepsState{
  int? nextStep;
  NextStep(this.nextStep);

  @override
  get value => nextStep;
}

class StepSelected implements StepsState{
  int? stepSelected;
  StepSelected(this.stepSelected);

  @override
  get value => stepSelected;
}

class StepReset implements StepsState {

  StepReset();

  @override
  get value => null;

}