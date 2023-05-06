
abstract class ExerciseState{}

extension ExerciseStateX on ExerciseState {
  bool get isInitial => this is InitialState;
  bool get isStepUpdated => this is StepsUpdate;
  bool get isSetUpdated => this is SetsUpdate;
  bool get isMinuteUpdated => this is MinuteUpdated;
  bool get isSecondsUpdated => this is SecondsUpdated;
  bool get isAdditionalMinuteUpdated => this is AdditionalMinuteUpdated;
  bool get isAdditionalSecondsUpdated => this is AdditionalSecondsUpdated;
  bool get isSetUpdatedStep => this is SetsUpdateStep;
  bool get isMinuteUpdatedStep => this is MinuteUpdatedStep;
  bool get isSecondsUpdatedStep => this is SecondsUpdatedStep;
  bool get isAdditionalMinuteUpdatedStep => this is AdditionalMinuteUpdatedStep;
  bool get isAdditionalSecondsUpdatedStep => this is AdditionalSecondsUpdatedStep;
  bool get isCurrentStepFinished => this is CurrentStepFinished;
  bool get isLastStep => this is LastStep;
  bool get isValuesReset => this is ValuesReset;
}

class InitialState implements ExerciseState {
  const InitialState();
}

class ValuesReset implements ExerciseState {
  const ValuesReset();
}

class StepsUpdate implements ExerciseState {
  final int steps;
  const StepsUpdate(this.steps);

  List<int> getStepList(){
    List<int> stepList = [];
    if(steps > 0) {
      stepList = List<int>.generate(steps, (index) => index + 1);
      // for(int i = 1; i <= steps; i++){
      //   stepList.add(i);
      // }
    }

    return stepList;
  }
}

class LastStep implements ExerciseState {
  const LastStep();
}

class CurrentStepFinished implements ExerciseState {
  final int currentStep;
  const CurrentStepFinished(this.currentStep);
}

// INDIVIDUAL EXERCISE
class SetsUpdate implements ExerciseState {
  final int set;
  const SetsUpdate(this.set);
}

class MinuteUpdated implements ExerciseState {
  final int minute;
  const MinuteUpdated(this.minute);
}

class SecondsUpdated implements ExerciseState {
  final int seconds;
  const SecondsUpdated(this.seconds);
}

class AdditionalMinuteUpdated implements ExerciseState {
  final String additionalMinute;
  const AdditionalMinuteUpdated(this.additionalMinute);
}

class AdditionalSecondsUpdated implements ExerciseState {
  final String additionalSeconds;
  const AdditionalSecondsUpdated(this.additionalSeconds);
}

// EXERCISE LIST
class SetsUpdateStep implements ExerciseState {
  final int set;
  const SetsUpdateStep(this.set);
}

class MinuteUpdatedStep implements ExerciseState {
  final String minute;
  const MinuteUpdatedStep(this.minute);
}

class SecondsUpdatedStep implements ExerciseState {
  final String seconds;
  const SecondsUpdatedStep(this.seconds);
}

class AdditionalMinuteUpdatedStep implements ExerciseState {
  final String additionalMinute;
  const AdditionalMinuteUpdatedStep(this.additionalMinute);
}

class AdditionalSecondsUpdatedStep implements ExerciseState {
  final String additionalSeconds;
  const AdditionalSecondsUpdatedStep(this.additionalSeconds);
}