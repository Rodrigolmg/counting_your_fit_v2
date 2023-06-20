abstract class MinuteState{}

extension MinuteStateX on MinuteState {
  bool get isInitialMinute => this is InitialMinute;
  bool get isMinuteDefined => this is MinuteDefined;
  bool get isMinuteReset => this is MinuteReset;
  bool get isMinuteSelected => this is MinuteSelected;
}

class InitialMinute implements MinuteState {
  final int initialMinuteValue = 0;
  const InitialMinute();
}

class MinuteDefined implements MinuteState {
  final int minute;
  const MinuteDefined(this.minute);
}

class MinuteSelected implements MinuteState {
  final int minuteSelected;
  const MinuteSelected(this.minuteSelected);
}

class MinuteReset implements MinuteState{
  const MinuteReset();
}