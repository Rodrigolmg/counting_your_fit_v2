part of presentation;

abstract class ButtonIconState{}

extension ButtonIconStateX on ButtonIconState {
  bool get isPlayIcon => this is PlayIcon;
  bool get isRestingIcon => this is RestingIcon;
  bool get isExecutingIcon => this is ExecutingIcon;
}

class PlayIcon implements ButtonIconState{
  const PlayIcon();
}

class RestingIcon implements ButtonIconState{
  const RestingIcon();
}

class ExecutingIcon implements ButtonIconState{
  const ExecutingIcon();
}