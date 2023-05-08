import 'package:counting_your_fit_v2/domain/usecase/register_individual_exercise_usecase.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/steps/step_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/individual_exercise_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercise_list_definition_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/timer_settings_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/util/additional_timer_label.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state_controller.dart';
import 'package:get_it/get_it.dart';

class AppInjector {
  
  final injector = GetIt.instance;


  void setup() {

    //USECASE
    injector.registerFactory<RegisterIndividualExerciseUseCase>(() =>
        RegisterIndividualExerciseUseCaseImpl());


    // CONTROLLERS
    injector.registerLazySingleton<TimerSettingsStateController>(() =>
        TimerSettingsStateController());

    injector.registerLazySingleton<IndividualExerciseController>(() =>
        IndividualExerciseController());

    injector.registerLazySingleton<ExerciseListDefinitionStateController>(() =>
        ExerciseListDefinitionStateController());

    injector.registerLazySingleton<StepStateController>(() =>
        StepStateController());

    injector.registerLazySingleton<SetsStateController>(() =>
        SetsStateController());

    injector.registerLazySingleton<MinuteStateController>(() =>
        MinuteStateController());

    injector.registerLazySingleton<AdditionalMinuteStateController>(() =>
        AdditionalMinuteStateController());

    injector.registerLazySingleton<SecondsStateController>(() =>
        SecondsStateController());

    injector.registerLazySingleton<AdditionalSecondsStateController>(() =>
        AdditionalSecondsStateController());

    injector.registerLazySingleton<TimerLabelController>(() => TimerLabelController());
    injector.registerLazySingleton<AdditionalTimerLabelController>(() =>
        AdditionalTimerLabelController());

  } 
  
}