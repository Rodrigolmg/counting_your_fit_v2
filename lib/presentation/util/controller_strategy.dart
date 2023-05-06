import 'package:counting_your_fit_v2/presentation/setting/bloc/exercise_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercise_list_definition_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/timer_settings_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/util/abstract_controller.dart';
import 'package:get_it/get_it.dart';

enum ControllerEnum {
  timerController,
  exerciseController,
  exerciseListController
}

class ControllerStrategy{

  static final Map<ControllerEnum, BlocController> controller = {
    ControllerEnum.timerController: _TimerController(),
    ControllerEnum.exerciseController: _IndividualController(),
    ControllerEnum.exerciseListController: _ExerciseListController()
  };

}

class _TimerController extends BlocController<TimerSettingsStateController>{
  @override
  TimerSettingsStateController get controller =>
      GetIt.I.get<TimerSettingsStateController>();
}

class _IndividualController extends BlocController<ExerciseController>{
  @override
  ExerciseController get controller =>
      GetIt.I.get<ExerciseController>();
}

class _ExerciseListController extends BlocController<ExerciseListDefinitionStateController>{
  @override
  ExerciseListDefinitionStateController get controller
    => GetIt.I.get<ExerciseListDefinitionStateController>();
}