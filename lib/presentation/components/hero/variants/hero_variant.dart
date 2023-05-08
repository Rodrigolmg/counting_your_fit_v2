import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_additional_timer_values.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_sets_value.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_step_value.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_exercise_timer_values.dart';
import 'package:flutter/material.dart';

abstract class HeroVariant{
  Widget call(String heroTag);
}

class HeroSets implements HeroVariant{
  @override
  Widget call(String heroTag) => HeroExerciseSetsValue(heroTag: heroTag);
}

class HeroSteps implements HeroVariant{
  @override
  Widget call(String heroTag) => HeroExerciseStepValue(heroTag: heroTag);
}

class HeroTimer implements HeroVariant {
  @override
  Widget call(String heroTag) => HeroExerciseTimerValues(heroTag: heroTag);
}

class HeroAdditionalTimer implements HeroVariant {
  @override
  Widget call(String heroTag) => HeroExerciseAdditionalTimerValues(
      heroTag: heroTag);

}
