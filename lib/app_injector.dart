import 'package:counting_your_fit_v2/domain/domain.dart';
import 'package:counting_your_fit_v2/presentation/presentation.dart';
import 'package:get_it/get_it.dart';

class AppInjector {
  
  final injector = GetIt.instance;

  void setup() {

    //USECASE
    injector.registerFactory<RegisterIndividualExerciseUseCase>(() =>
        RegisterIndividualExerciseUseCaseImpl());

    injector.registerFactory<RegisterSingleExerciseListUseCase>(() =>
        RegisterSingleExerciseListUseCaseImpl());

    // BLOC CONTROLLERS
    injector.registerLazySingleton<SettingsDefinitionStateController>(() =>
        SettingsDefinitionStateController());

    injector.registerLazySingleton<IndividualExerciseController>(() =>
        IndividualExerciseController());

    injector.registerLazySingleton<ExerciseListDefinitionController>(() =>
        ExerciseListDefinitionController());

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