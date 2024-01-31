part of presentation;

abstract class ExercisesBeepVolumeState{
  double get volume;
}

extension IndividualBeepVolumeStateX on ExercisesBeepVolumeState{
  bool get isFullVolume => this is FullVolume;
  bool get isMidVolume => this is MidVolume;
  bool get isLowVolume => this is LowVolume;
  bool get isNoVolume => this is NoVolume;
}

class FullVolume implements ExercisesBeepVolumeState{
  final double value;
  const FullVolume(this.value);

  @override
  double get volume => value;
}

class MidVolume implements ExercisesBeepVolumeState{
  final double value;
  const MidVolume(this.value);

  @override
  double get volume => value;
}

class LowVolume implements ExercisesBeepVolumeState{
  final double value;
  const LowVolume(this.value);

  @override
  double get volume => value;
}

class NoVolume implements ExercisesBeepVolumeState{
  final double value;
  const NoVolume(this.value);

  @override
  double get volume => value;
}