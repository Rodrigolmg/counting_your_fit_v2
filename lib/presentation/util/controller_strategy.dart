import 'package:counting_your_fit_v2/presentation/setting/bloc/individual/individual_exercise_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_controller.dart';
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
  };

}

class _TimerController extends BlocController<TimerSettingsStateController>{
  @override
  TimerSettingsStateController get controller =>
      GetIt.I.get<TimerSettingsStateController>();
}

class _IndividualController extends BlocController<IndividualExerciseController>{
  @override
  IndividualExerciseController get controller =>
      GetIt.I.get<IndividualExerciseController>();
}