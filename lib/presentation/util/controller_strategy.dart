part of util;

enum ControllerEnum {
  timerController,
  exerciseController,
  exerciseListController
}

class ControllerStrategy{

  static final Map<ControllerEnum, BlocController> controller = {
    ControllerEnum.timerController: _TimerController(),
    ControllerEnum.exerciseController: _IndividualController(),
  };

}

class _TimerController extends BlocController<SettingsDefinitionStateController>{
  @override
  SettingsDefinitionStateController get controller =>
      GetIt.I.get<SettingsDefinitionStateController>();
}

class _IndividualController extends BlocController<IndividualExerciseController>{
  @override
  IndividualExerciseController get controller =>
      GetIt.I.get<IndividualExerciseController>();
}