import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/steps/step_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/steps/steps_state.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_variant.dart';
import 'package:counting_your_fit_v2/presentation/components/shake_error.dart';
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

  final stepController = GetIt.I.get<StepStateController>();
  final setsController = GetIt.I.get<SetsStateController>();
  final timerLabelController = GetIt.I.get<TimerLabelController>();
  final additionalTimerLabelController = GetIt.I.get<AdditionalTimerLabelController>();

  int currentStepIndex = 0;
  bool hasAdditionalExercise = false;
  final GlobalKey<ShakeErrorState> stepTimerKey = GlobalKey<ShakeErrorState>();
  final GlobalKey<ShakeErrorState> stepTimerAdditionalKey = GlobalKey<ShakeErrorState>();
  String minutesLabel = '00';
  String secondsLabel = '00';
  String additionalMinutesLabel = '00';
  String additionalSecondsLabel = '00';
  String buttonLabel = '';
  int sets = 1;
  List<int> steps = [1, 2];

  void trainCallback(int step){
    bool hasNoRestTime = minutesLabel == '00' &&
        secondsLabel == '00';

    if(hasNoRestTime) {
      stepTimerKey.currentState?.shake();
      return;
    } else{
      if(hasAdditionalExercise) {
        bool hasAdditionalTime = additionalMinutesLabel != '00' ||
            additionalSecondsLabel != '00';

        if (!hasAdditionalTime) {
          stepTimerAdditionalKey.currentState?.shake();
          return;
        }
      }
      stepController.nextStep(step);

      if(steps.length == step){

      }

      timerLabelController.resetTimer();
    }
    // exerciseController.nextExercise(currentStep);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(stepController.state.isStepDefined){
        steps = List.from(stepController.steps);
      }
    });
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
            child: BlocBuilder<StepStateController, StepsState>(
              bloc: stepController,
              builder: (context, state) {

                if(state.isStepDefined){
                  steps = stepController.steps;
                } else if(state.isNextStep){
                  currentStepIndex = (state.value as int) - 1;
                }

                return NumberStepper(
                  enableNextPreviousButtons: false,
                  enableStepTapping: true,
                  direction: Axis.horizontal,
                  activeStep: currentStepIndex,
                  activeStepColor: ColorApp.mainColor,
                  numberStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  activeStepBorderColor: Colors.transparent,
                  lineColor: Colors.black,
                  numbers: steps,
                  scrollingDisabled: false,
                  stepReachedAnimationEffect: Curves.easeOut,
                  onStepReached: null,
                );
              },
            ),
          ),
          Column(
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
                  BlocBuilder<SetsStateController, SetsState>(
                    bloc: setsController,
                    builder: (context, state) {

                      if(state.isSetDefined){
                        sets = (state as SetDefined).sets;
                      }

                      return HeroButton(
                        heroTag: heroSetsPopUpStep,
                        buttonLabel: sets.toString(),
                        variant: HeroSets(),
                      );
                    },
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
                      key: stepTimerKey,
                      duration: const Duration(milliseconds: 550),
                      shakeCount: 3,
                      shakeOffset: 10,
                      child: BlocBuilder<TimerLabelController, TimerLabelState>(
                        bloc: timerLabelController,
                        builder: (context, state){

                          if(state.isMinuteLabelDefined){
                            minutesLabel = state.value ?? '00';
                          } else if (state.isSecondsLabelDefined){
                            secondsLabel = state.value ?? '00';
                          } else if (state.isTimerReset){
                            minutesLabel = '00';
                            secondsLabel = '00';
                          }

                          return HeroButton(
                            buttonLabel: '$minutesLabel:$secondsLabel',
                            heroTag: heroTimerPopUpStep,
                            hasError: stepTimerKey.currentState
                                != null &&
                                stepTimerKey.currentState!
                                    .animationController.status
                                    == AnimationStatus.forward,
                            variant: HeroTimer(),
                          );
                        },
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
                  BlocBuilder<TimerLabelController, TimerLabelState>(
                    bloc: timerLabelController,
                    builder: (context, state){

                      bool isMinuteDefined = false;
                      bool isSecondsDefined = false;

                      if(state.isMinuteLabelDefined){
                        isMinuteDefined = (state.value as String) != '00';
                      } else if (state.isSecondsLabelDefined){
                        isSecondsDefined = (state.value as String) != '00';
                      }

                      return Checkbox(
                        value: hasAdditionalExercise,
                        onChanged: isMinuteDefined ||
                            isSecondsDefined ?
                          (checkValue){
                            setState(() {
                              hasAdditionalExercise = checkValue ?? false;
                            });
                            additionalTimerLabelController.resetAdditionalTimer();
                            // exerciseController.resetAdditionals();
                        } : null,
                        checkColor: ColorApp.backgroundColor,
                        activeColor: ColorApp.mainColor,
                      );
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    context.translate.get('additionalExercise'),
                    style: TextStyle(
                        color: hasAdditionalExercise ?
                        ColorApp.mainColor : Colors.black26,
                        fontSize: 20
                    ),
                  )
                ],
              ),
              AnimatedOpacity(
                opacity: hasAdditionalExercise ? 1 : 0,
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
                      key: stepTimerAdditionalKey,
                      duration: const Duration(milliseconds: 550),
                      shakeCount: 3,
                      shakeOffset: 10,
                      child: BlocBuilder<AdditionalTimerLabelController,
                          AdditionalTimerLabelState>(
                        bloc: additionalTimerLabelController,
                        builder: (context, state){

                          if(state.isAdditionalMinuteLabelDefined){
                            additionalMinutesLabel = state.value;
                          } else if(state.isAdditionalSecondsLabelDefined){
                            additionalSecondsLabel = state.value;
                          } else if (state.isAdditionalTimerReset){
                            additionalMinutesLabel = '00';
                            additionalSecondsLabel = '00';
                          }

                          return HeroButton(
                            heroTag: heroAdditionalPopUpStep,
                            hasError: stepTimerAdditionalKey.currentState != null &&
                                stepTimerAdditionalKey.currentState!
                                    .animationController.status
                                    == AnimationStatus.forward,
                            buttonLabel: '$additionalMinutesLabel:$additionalSecondsLabel',
                            variant: HeroAdditionalTimer(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              )
            ],
          ),
          AnimatedPositioned(
            top: height * (!hasAdditionalExercise ? .56 : .61),
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
                  onPressed: (){
                    currentStepIndex++;
                    trainCallback(currentStepIndex + 1);
                  },
                  child: BlocBuilder<StepStateController, StepsState>(
                      bloc: stepController,
                      builder: (context, state){
                        buttonLabel = context.translate.get('stepPage.nextExercise');

                        if(state.isNextStep){
                          if(state.value != steps.length){
                            buttonLabel = context.translate.get('stepPage.nextExercise');
                          } else {
                            buttonLabel = context.translate.get('train');
                          }
                        }

                        return Text(
                          buttonLabel,
                          style: TextStyle(
                              color: ColorApp.backgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        );
                      }
                  )
              ),
            ),

          )
        ],
      ),
    );
  }
}
