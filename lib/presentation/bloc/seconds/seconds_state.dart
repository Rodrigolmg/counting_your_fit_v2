
abstract class SecondsState{}

extension SecondsStateX on SecondsState{
  bool get isInitialSecond => this is InitialSecond;
  bool get isSecondsDefined => this is SecondsDefined;
}

class InitialSecond implements SecondsState {
  final int initialSecondValue = 0;
  const InitialSecond();
}

class SecondsDefined implements SecondsState {
  final int seconds;
  const SecondsDefined(this.seconds);
}