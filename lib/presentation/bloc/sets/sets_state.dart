
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';

abstract class SetsState{}

extension SetsStateX on SetsState{
  bool get isInitialSet => this is InitialSet;
  bool get isSetDefined => this is SetDefined;
  bool get isSetReset => this is SetReset;
  bool get isSetSelected => this is SetSelected;
  bool get isExerciseSetSelected => this is ExerciseSetSelected;
}

class InitialSet implements SetsState {
  final int initialSetValue = 1;
  const InitialSet();
}

class SetDefined implements SetsState {
  final int sets;
  const SetDefined(this.sets);
}

class SetReset implements SetsState {
  const SetReset();
}

class SetSelected implements SetsState{
  final int setSelected;
  const SetSelected(this.setSelected);
}

class ExerciseSetSelected implements SetsState{
  final ExerciseSettingEntity exerciseSelected;
  const ExerciseSetSelected(this.exerciseSelected);
}