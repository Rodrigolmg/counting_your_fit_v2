abstract class MinuteState{}

extension MinuteStateX on MinuteState {
  bool get isInitialMinute => this is InitialMinute;
  bool get isMinuteDefined => this is MinuteDefined;
}

class InitialMinute implements MinuteState {
  final int initialMinuteValue = 0;
  const InitialMinute();
}

class MinuteDefined implements MinuteState {
  final int minute;
  const MinuteDefined(this.minute);
}