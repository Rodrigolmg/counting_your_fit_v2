
import 'package:counting_your_fit_v2/presentation/intro/intro_screen.dart';
import 'package:counting_your_fit_v2/presentation/setting/exercise_step_setting_screen.dart';
import 'package:counting_your_fit_v2/presentation/setting/timer_settings_screen.dart';
import 'package:counting_your_fit_v2/presentation/splash_screen.dart';
import 'package:counting_your_fit_v2/presentation/timer/exercises/exercise_list_timer.dart';
import 'package:counting_your_fit_v2/presentation/timer/individual/individual_exercise_timer.dart';
import 'package:flutter/material.dart';

class CountingYourFitRouter {
  static Route<dynamic> getRoutes(RouteSettings settings) {

    switch(settings.name){
      case 'splash':
        return MaterialPageRoute(
          builder: (_) => const CustomSplashScreen()
        );
      case 'timer_settings':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const TimerSettingsScreen(),
            transitionsBuilder: (context, animation, sAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0)
              ).animate(animation),
              child: child,
            )
        );
      case 'individual_timer':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const IndividualExerciseTimer(),
            transitionsBuilder: (context, animation, sAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0)
              ).animate(animation),
              child: child,
            )
        );
        case 'exercise_list_timer':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ExerciseListTimer(),
            transitionsBuilder: (context, animation, sAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0)
              ).animate(animation),
              child: child,
            )
        );
      case 'intro_screen':
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const IntroScreen(),
            transitionsBuilder: (context, animation, sAnimation, child) => SlideTransition(
              position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0)
              ).animate(animation),
              child: child,
            )
        );
      case 'exercise_step_settings':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ExerciseStepSettingScreen(),
          transitionsBuilder: (context, animation, sAnimation, child) => SlideTransition(
            position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0)
            ).animate(animation),
            child: child,
          )
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const TimerSettingsScreen(),
          transitionsBuilder: (context, animation, sAnimation, child) => SlideTransition(
            position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0)
            ).animate(animation),
            child: child,
          )
        );
    }

  }

}

class CountingYourFitRoutes {
  static const String splashScreen = 'splash';
  static const String timerSetting = 'timer_settings';
  static const String exerciseStepSetting = 'exercise_step_settings';
  static const String individualTimer = 'individual_timer';
  static const String exerciseListTimer = 'exercise_list_timer';
  static const String introScreen = 'intro_screen';
}