part of presentation;

abstract class IndividualBeepVolumeState{
  double get volume;
}

extension IndividualBeepVolumeStateX on IndividualBeepVolumeState{
  bool get isFullVolume => this is IndividualFullVolume;
  bool get isMidVolume => this is MidVolume;
  bool get isLowVolume => this is LowVolume;
  bool get isNoVolume => this is NoVolume;
}

class IndividualFullVolume implements IndividualBeepVolumeState{
  final double value;
  const IndividualFullVolume(this.value);

  @override
  double get volume => value;
}

class IndividualMidVolume implements IndividualBeepVolumeState{
  final double value;
  const IndividualMidVolume(this.value);

  @override
  double get volume => value;
}

class IndividualLowVolume implements IndividualBeepVolumeState{
  final double value;
  const IndividualLowVolume(this.value);

  @override
  double get volume => value;
}

class IndividualNoVolume implements IndividualBeepVolumeState{
  final double value;
  const IndividualNoVolume(this.value);

  @override
  double get volume => value;
}