part of presentation;

abstract class HeroVariant{
  Widget call(String heroTag, {bool? isStepConfig = false});
}

class HeroSets implements HeroVariant{
  @override
  Widget call(String heroTag, {bool? isStepConfig = false}) => HeroExerciseSetsValue(heroTag: heroTag);
}

class HeroSteps implements HeroVariant{
  @override
  Widget call(String heroTag, {bool? isStepConfig = false}) => HeroExerciseStepValue(heroTag: heroTag);
}

class HeroTimer implements HeroVariant {
  @override
  Widget call(String heroTag, {bool? isStepConfig = false}) => HeroExerciseTimerValues(heroTag: heroTag, isStepConfig: isStepConfig);
}

class HeroAdditionalTimer implements HeroVariant {
  @override
  Widget call(String heroTag, {bool? isStepConfig = false}) => HeroExerciseAdditionalTimerValues(
      heroTag: heroTag);

}
