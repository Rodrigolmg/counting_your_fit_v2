import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/presentation/components/individual_exercise_helper_sheet.dart';
import 'package:counting_your_fit_v2/presentation/components/step_helper_sheet.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/definition/settings_definition_states.dart';
import 'package:counting_your_fit_v2/presentation/setting/pages/exercise_list_page.dart';
import 'package:counting_your_fit_v2/presentation/setting/pages/individual_exercise_page.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/definition/settings_definition_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get_it/get_it.dart';

class TimerSettingsScreen extends StatefulWidget {
  const TimerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<TimerSettingsScreen> createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {

  final PageController _pageController = PageController();
  final _timeScreenController = GetIt.I.get<SettingsDefinitionStateController>();
  double helpPageValue = 0.0;
  Widget sheet = const IndividualExerciseHelperSheet();

  Future<bool> onCancel() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: ColorApp.mainColor,
            elevation: 2,
            actions: [
              TextButton(
                  onPressed: (){
                    SystemNavigator.pop(animated: true);
                  },
                  child: Text(
                    context.translate.get('yes'),
                    style: TextStyle(
                        color: ColorApp.errorColor2,
                        fontSize: 20,
                        shadows: const [
                          Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ]
                    ),
                  )
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    context.translate.get('no'),
                    style: TextStyle(
                        color: ColorApp.backgroundColor,
                        fontSize: 20,
                        shadows: const [
                          Shadow(
                              color: Colors.black54,
                              offset: Offset(1, 1)
                          )
                        ]
                    ),
                  )
              ),
            ],
            title: Text(
              context.translate.get('closeAppTitle'),
              style: TextStyle(
                  color: ColorApp.backgroundColor,
                  shadows: const [
                    Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1)
                    )
                  ]
              ),
            ),
            content: Text(
              context.translate.get('closeAppDescription'),
              style: TextStyle(
                  color: ColorApp.backgroundColor,
                  shadows: const [
                    Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1)
                    )
                  ]
              ),
            ),
          );
        }
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onCancel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: (){
              onCancel();
            },
            icon: const Icon(FeatherIcons.xOctagon),
            color: ColorApp.mainColor,
          ),
        ),
        body: BlocBuilder<SettingsDefinitionStateController, SettingsDefinitionStates>(
          bloc: _timeScreenController,
          builder: (context, state){

            if(state.isFirstPageClicked){
              _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut
              );
              sheet = const IndividualExerciseHelperSheet();
            } else if(state.isSecondPageClicked){
              _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut
              );
              sheet = const StepHelperSheet();
            } else if (state.isFirstPageScrolled){
              sheet = const IndividualExerciseHelperSheet();
            } else if (state.isSecondPageScrolled){
              sheet = const StepHelperSheet();
            }

            return Stack(
              children: [
                PageView(
                  controller: _pageController,
                  children: const [
                    IndividualExercisePage(),
                    ExerciseListPage()
                  ],
                  onPageChanged: (pageIndex){
                    _timeScreenController.changePageOnScroll(pageIndex);
                  },
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showModalBottomSheet(
                context: context,
                backgroundColor: ColorApp.mainColor,
                isDismissible: true,
                barrierColor: Colors.transparent,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    )
                ),
                builder: (_){
                  return sheet;
                }
            );
            // _timeScreenController.callHelp();
          },
          backgroundColor: ColorApp.mainColor,
          child: Icon(
            Icons.question_mark_rounded,
            color: ColorApp.backgroundColor,
          ),
        ),
      ),
    );
  }


}
