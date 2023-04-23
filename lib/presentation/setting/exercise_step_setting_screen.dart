import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/components/shake_error.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/exercise_list_definition_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/exercise_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_stepper/stepper.dart';
import 'package:get_it/get_it.dart';

class ExerciseStepSettingScreen extends StatefulWidget {
  const ExerciseStepSettingScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseStepSettingScreen> createState() => _ExerciseStepSettingScreenState();
}

class _ExerciseStepSettingScreenState extends State<ExerciseStepSettingScreen> {

  final exerciseController = GetIt.I.get<ExerciseController>();
  final exerciseStepController = GetIt.I.get<ExerciseListDefinitionStateController>();

  int currentStep = 0;
  bool _hasAdditionalExercise = false;
  final List<GlobalKey<ShakeErrorState>> timerKeyList = [];
  final List<GlobalKey<ShakeErrorState>> timerAdditionalKeyList = [];

  final pageViewController = PageController();

  void trainCallback(int keyIndex){
    bool hasNoRestTime = exerciseStepController.minutes == '00' &&
        exerciseStepController.seconds == '00';

    if(hasNoRestTime) {
      GlobalKey<ShakeErrorState> timerKey = timerKeyList[keyIndex];
      timerKey.currentState?.shake();
      return;
    }

    if(_hasAdditionalExercise) {
      bool hasAdditionalTime = exerciseStepController.additionalMinutes != '00' ||
          exerciseStepController.additionalSeconds != '00';
      if(!hasAdditionalTime){
        GlobalKey<ShakeErrorState> additionalTimerKey = timerAdditionalKeyList[keyIndex];
        additionalTimerKey.currentState?.shake();
        return;
      }
    }

    exerciseStepController.nextExercise();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacementNamed(
              context,
              CountingYourFitRoutes.timerSetting,
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: ColorApp.mainColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: width,
            height: height * .17,
            child: NumberStepper(
              enableNextPreviousButtons: false,
              enableStepTapping: true,
              direction: Axis.horizontal,
              activeStep: exerciseStepController.pageIndex,
              activeStepColor: ColorApp.mainColor,
              numberStyle: const TextStyle(
                color: Colors.black,
              ),
              activeStepBorderColor: Colors.transparent,
              lineColor: Colors.black,
              numbers: exerciseStepController.steps,
              scrollingDisabled: true,
              stepReachedAnimationEffect: Curves.easeInQuad,
              onStepReached: (index){
                pageViewController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn
                );
              },
            ),
          ),
          BlocBuilder<ExerciseListDefinitionStateController, ExerciseListDefinitionStates>(
            bloc: exerciseStepController,
            builder: (context, state){

              if(state.isStepCompleted){
                pageViewController.animateToPage(
                    exerciseStepController.pageIndex,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn
                );
              }

              if(state.isStepListDefined){
                return PageView.builder(
                    controller: pageViewController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exerciseStepController.steps.length,
                    itemBuilder: (context, index) {

                      var shakeStepTimerKey = GlobalKey<ShakeErrorState>();
                      var shakeStepAdditionalKey = GlobalKey<ShakeErrorState>();

                      timerKeyList.add(shakeStepTimerKey);
                      timerAdditionalKeyList.add(shakeStepAdditionalKey);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${context.translate.get('sets')}:',
                                style: TextStyle(
                                    color: ColorApp.mainColor,
                                    fontSize: 20
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              HeroButton(
                                heroTag: '$heroSetsPopUp-${index.toString()}',
                                buttonLabel: exerciseStepController.sets.toString(),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width * .085),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${context.translate.get('rest')}:',
                                  style: TextStyle(
                                      color: ColorApp.mainColor,
                                      fontSize: 20
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ShakeError(
                                  key: timerKeyList[index],
                                  duration: const Duration(milliseconds: 550),
                                  shakeCount: 3,
                                  shakeOffset: 10,
                                  child: HeroButton(
                                    buttonLabel: '${exerciseStepController.minutes}:${exerciseStepController.seconds}',
                                    heroTag: '$heroTimerPopUp-${index.toString()}',
                                    hasError: timerKeyList[index].currentState
                                        != null &&
                                        timerKeyList[index].currentState!
                                            .animationController.status
                                        == AnimationStatus.forward,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _hasAdditionalExercise,
                                onChanged: exerciseStepController.seconds != '00' ||
                                    exerciseStepController.minutes != '00' ?
                                    (checkValue){
                                  setState(() {
                                    _hasAdditionalExercise = checkValue ?? false;
                                  });
                                  exerciseStepController.resetAdditionals();
                                } : null,
                                checkColor: ColorApp.backgroundColor,
                                activeColor: ColorApp.mainColor,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                context.translate.get('additionalExercise'),
                                style: TextStyle(
                                    color: _hasAdditionalExercise ?
                                    ColorApp.mainColor : Colors.black26,
                                    fontSize: 20
                                ),
                              )
                            ],
                          ),
                          AnimatedOpacity(
                            opacity: _hasAdditionalExercise ? 1 : 0,
                            duration: const Duration(milliseconds: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${context.translate.get('timeLabel')}:',
                                  style: TextStyle(
                                      color: ColorApp.mainColor ,
                                      fontSize: 20
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ShakeError(
                                  key: timerAdditionalKeyList[index],
                                  duration: const Duration(milliseconds: 550),
                                  shakeCount: 3,
                                  shakeOffset: 10,
                                  child: HeroButton(
                                    heroTag: '$heroAdditionalPopUp-${index.toString()}',
                                    hasError: timerAdditionalKeyList[index].currentState != null &&
                                        timerAdditionalKeyList[index].currentState!
                                            .animationController.status
                                            == AnimationStatus.forward,
                                    buttonLabel: '${exerciseController.additionalMinutes}:${exerciseController.additionalSeconds}',
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                );
              }

              return CircularProgressIndicator(
                color: ColorApp.mainColor,
                strokeWidth: 1,
              );
            },
          ),
          AnimatedPositioned(
            top: height * (!_hasAdditionalExercise ? .56 : .61),
            left: width * .105,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuad,
            child: SizedBox(
              width: width * .8,
              height: height * .07,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: ColorApp.mainColor,
                    elevation: 2,
                  ),
                  onPressed:(){
                    trainCallback(0);
                  },
                  child: Text(
                    context.translate.get('train'),
                    style: TextStyle(
                        color: ColorApp.backgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),

          )
        ],
      ),
    );
  }
}
