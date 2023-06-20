import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_additional_timer_values.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_sets_value.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_step_value.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_timer_values.dart';
import 'package:flutter/material.dart';

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
