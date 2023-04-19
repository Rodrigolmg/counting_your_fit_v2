import 'package:counting_your_fit_v2/color_app.dart';
import 'package:bloc/bloc.dart';
import 'package:counting_your_fit_v2/presentation/setting/pages/exercise_list_page.dart';
import 'package:counting_your_fit_v2/presentation/setting/pages/individual_exercise_page.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/timer_settings_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class TimerSettingsScreen extends StatefulWidget {
  const TimerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<TimerSettingsScreen> createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {

  final PageController _pageController = PageController();
  final _timeScreenController = GetIt.I.get<TimerSettingsStateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){},
          icon: const Icon(Icons.watch_off),
          color: ColorApp.mainColor,
        ),
      ),
      body: BlocBuilder<TimerSettingsStateController, TimerSettingsStates>(
        bloc: _timeScreenController,
        builder: (context, state){
          if(state.isFirstPage){
            _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInSine
            );
          } else if(state.isSecondPage){
            _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInSine
            );
          }

          return PageView(
            controller: _pageController,
            children: const [
              IndividualExercisePage(),
              ExerciseListPage()
            ],
          );
        },
      )
    );
  }


}
