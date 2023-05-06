
abstract class StepsState{}

extension StepsStateX on StepsState{
  bool get isInitialStep => this is InitialStep;
  bool get isStepDefined => this is StepDefined;
  bool get isNextStep => this is NextStep;
}

class InitialStep implements StepsState {
  final int initialStepValue = 2;
  const InitialStep();
}

class StepDefined implements StepsState {
  final int steps;
  const StepDefined(this.steps);
}

class NextStep implements StepsState{
  int? nextStep;
  NextStep(this.nextStep);
}