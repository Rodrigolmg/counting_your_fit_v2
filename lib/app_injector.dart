

import 'package:counting_your_fit_v2/presentation/setting/state/timer_settings_state_controller.dart';
import 'package:get_it/get_it.dart';

class AppInjector {
  
  final injector = GetIt.instance;


  void setup() {
    injector.registerSingleton<TimerSettingsStateController>(
        TimerSettingsStateController());
  } 
  
}