import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/steps/step_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/steps/steps_state.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_variant.dart';
import 'package:counting_your_fit_v2/presentation/components/shake_error.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_states.dart';
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
  final timerLabelController = GetIt.I.get<TimerLabelController>();
  final additionalTimerLabelController = GetIt.I.get<AdditionalTimerLabelController>();
  final exerciseListDefinitionController = GetIt.I.get<ExerciseListDefinitionController>();

  // EXERCISE CONTROLLERS
  final setsController = GetIt.I.get<SetsStateController>();
  final minuteController = GetIt.I.get<MinuteStateController>();
  final additionalMinuteController = GetIt.I.get<AdditionalMinuteStateController>();
  final additionalSecondsController = GetIt.I.get<AdditionalSecondsStateController>();
  final secondsController = GetIt.I.get<SecondsStateController>();

  int currentStepIndex = 0;
  int? selectedStepIndex;
  bool hasAdditionalExercise = false;
  bool isAutoRest = false;
  final GlobalKey<ShakeErrorState> stepTimerKey = GlobalKey<ShakeErrorState>();
  final GlobalKey<ShakeErrorState> stepTimerAdditionalKey = GlobalKey<ShakeErrorState>();

  String minutesLabel = '00';
  String secondsLabel = '00';
  String additionalMinutesLabel = '00';
  String additionalSecondsLabel = '00';
  String buttonLabel = '';
  int sets = 1;
  List<int> steps = [1, 2];
  final List<ExerciseSettingEntity> exercises = [];

  void trainCallback() async {
    bool hasNoRestTime = minutesLabel == '00' &&
        secondsLabel == '00';

    if(hasNoRestTime) {
      stepTimerKey.currentState?.shake();
      return;
    }

    if(hasAdditionalExercise) {
      bool hasAdditionalTime = additionalMinutesLabel != '00' ||
          additionalSecondsLabel != '00';

      if (!hasAdditionalTime) {
        stepTimerAdditionalKey.currentState?.shake();
        return;
      }
    }

    hasAdditionalExercise = (int.parse(additionalMinutesLabel) > 0 ||
        int.parse(additionalSecondsLabel) > 0);
    if(stepController.state.isNextStep){
      currentStepIndex = stepController.state.value as int;
    }
    int id = steps[currentStepIndex];
    ExerciseSettingEntity exercise = await exerciseListDefinitionController.registerSingleExercise(
      id: id,
      set: sets,
      minute: int.parse(minutesLabel),
      seconds: int.parse(secondsLabel),
      additionalMinute: int.tryParse(additionalMinutesLabel),
      additionalSecond: int.tryParse(additionalSecondsLabel),
      hasAdditionalTime: hasAdditionalExercise,
      isAutoRest: isAutoRest
    );

    if(exercises.isNotEmpty){
        int indexOfExercise = exercises
            .indexWhere((element) => element.id == exercise.id);
      if(indexOfExercise >= 0){
        exercises.removeWhere((element) => element.id == exercise.id);
        exercises.insert(indexOfExercise, exercise);
      } else {
        exercises.add(exercise);
      }
    } else {
      exercises.add(exercise);
    }
    stepController.nextStep(currentStepIndex);
    if(exercises.asMap().containsKey(stepController.state.value as int)){
      selectExercise(stepController.state.value as int);
    } else {
      timerLabelController.resetTimer();
      additionalTimerLabelController.resetAdditionalTimer();
      setsController.resetSet();
      minuteController.resetMinute();
      secondsController.resetSeconds();
      setState(() {
        hasAdditionalExercise = false;
        isAutoRest = false;
      });
    }

    if(exercises.length == steps.length){
      exerciseListDefinitionController.defineExerciseList(exercises);
      if(context.mounted){
        Navigator.pushReplacementNamed(context,
            CountingYourFitRoutes.exerciseListTimer);
      }
    }
  }

  void selectExercise(int stepIndex){
    ExerciseSettingEntity? exercise;
    if(exercises.isNotEmpty){
      if(exercises.asMap().containsKey(stepIndex)){
        exercise = exercises[stepIndex];
        selectedStepIndex = stepIndex;
      }
    }

    exerciseListDefinitionController.selectExercise(exercise: exercise);

    if(exercise != null){
      stepController.selectStep(stepIndex);
      setsController.selectSet(exercise.set);

      minuteController.selectMinute(exercise.minute);
      secondsController.selectSeconds(exercise.seconds);
      String minuteLabel = exercise.minute <= 9 ? '0${exercise.minute}' : exercise.minute.toString();
      String secondsLabel = exercise.seconds <= 9 ? '0${exercise.seconds}' : exercise.seconds.toString();
      timerLabelController.selectTimer('$minuteLabel:$secondsLabel');

      // ADDITIONAL TIME
      additionalMinuteController.selectAdditionalMinute(exercise.additionalMinute);
      additionalSecondsController.selectAdditionalSeconds(exercise.additionalSeconds);
      String additionalMinuteLabel = exercise.additionalMinute != null &&
          exercise.additionalMinute! <= 9 ? '0${exercise.additionalMinute}' :
      exercise.additionalMinute.toString();
      String additionalSecondsLabel = exercise.additionalSeconds != null &&
          exercise.additionalSeconds! <= 9 ? '0${exercise.additionalSeconds}'
          : exercise.additionalSeconds.toString();
      additionalTimerLabelController.selectAdditionalTimer('$additionalMinuteLabel:$additionalSecondsLabel');
      setState(() {
        hasAdditionalExercise = exercise!.hasAdditionalTime ?? false;
        isAutoRest = exercise.isAutoRest ?? false;

      });
    } else {
      stepController.selectStep(stepIndex);
      setsController.selectSet(1);
      minuteController.selectMinute(0);
      secondsController.selectSeconds(0);
      additionalMinuteController.selectAdditionalMinute(null);
      additionalSecondsController.selectAdditionalSeconds(null);
      timerLabelController.selectTimer('00:00');
      additionalTimerLabelController.selectAdditionalTimer('00:00');
      setState(() {
        hasAdditionalExercise = false;
        isAutoRest = false;
      });
    }


    // if(exerciseListDefinitionController.state.isSingleExerciseSelected){
    //   exercise = (exerciseListDefinitionController.state as ExerciseSelected)
    //       .exerciseSelected;
    //
    //
    // }
  }

  void cancelExercise() async {
    setsController.resetSet();
    minuteController.resetMinute();
    secondsController.resetSeconds();
    additionalMinuteController.resetAdditionalMinute();
    additionalSecondsController.resetAdditionalSeconds();
    Navigator.pushReplacementNamed(context,
        CountingYourFitRoutes.timerSetting);
  }

  Future<bool> onCancelSetting() async {
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
                    cancelExercise();
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
              context.translate.get('stepPage.cancelTitle'),
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
              context.translate.get('stepPage.cancelDescription'),
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
  void initState() {
    super.initState();
    currentStepIndex = 0;
    if(stepController.state.isStepDefined){
      steps = List.from(stepController.steps);
    }
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: onCancelSetting,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: onCancelSetting,
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
                  } else if (state.isStepSelected || state.isNextStep){
                    currentStepIndex = (state.value as int);
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
                    onStepReached: (stepIndex){
                      selectExercise(stepIndex);
                    },
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
                        } else if (state.isSetReset){
                          sets = 1;
                        } else if (state.isSetSelected){
                          sets = (state as SetSelected).setSelected;
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
                            if (state.isTimerSelected){
                              List<String> label = (state as TimerLabelSelected)
                                  .timerSelected!.split(':');
                              minutesLabel = label[0];
                              secondsLabel = label[1];
                            } else {
                              if(state.isMinuteLabelDefined){
                                minutesLabel = state.value ?? '00';
                              } else if (state.isSecondsLabelDefined){
                                secondsLabel = state.value ?? '00';
                              }

                              if (state.isTimerReset){
                                minutesLabel = '00';
                                secondsLabel = '00';
                              }
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
                        }

                        if (state.isSecondsLabelDefined){
                          isSecondsDefined = (state.value as String) != '00';
                        }


                        return Checkbox(
                          value: hasAdditionalExercise,
                          onChanged: isMinuteDefined ||
                              isSecondsDefined || state.isTimerSelected ?
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

                            String label = '00:00';

                            if(state.isAdditionalMinuteLabelDefined){
                              additionalMinutesLabel = state.value;
                            }

                            if(state.isAdditionalSecondsLabelDefined){
                              additionalSecondsLabel = state.value;
                            }

                            if (state.isAdditionalTimerReset){
                              additionalMinutesLabel = '00';
                              additionalSecondsLabel = '00';
                            } else if(state.isAdditionalTimerSelected){
                              label = (state as AdditionalTimeLabelSelected).additionalTimeSelected;
                            } else {
                              label = '$additionalMinutesLabel:$additionalSecondsLabel';
                            }


                            return HeroButton(
                              heroTag: heroAdditionalPopUpStep,
                              hasError: stepTimerAdditionalKey.currentState != null &&
                                  stepTimerAdditionalKey.currentState!
                                      .animationController.status
                                      == AnimationStatus.forward,
                              buttonLabel: label,
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
                child: Column(
                  children: [
                    SizedBox(
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

                            if(selectedStepIndex != null){
                              currentStepIndex = selectedStepIndex!;
                            }

                            trainCallback();
                          },
                          child: BlocBuilder<StepStateController, StepsState>(
                              bloc: stepController,
                              builder: (context, state){
                                buttonLabel = context.translate.get('stepPage.nextExercise');

                                if(state.isNextStep){
                                  if((state.value + 1) != steps.length){
                                    buttonLabel = context.translate.get('stepPage.nextExercise');
                                  } else {
                                    buttonLabel = context.translate.get('train');
                                  }
                                } else if (state.isStepSelected){
                                  if(exerciseListDefinitionController.state.isSingleExerciseSelected){
                                    ExerciseSettingEntity? exercise =
                                        (exerciseListDefinitionController.state as ExerciseSelected).exerciseSelected;
                                    if((state.value + 1) == steps.length){
                                      buttonLabel = context.translate.get('train');
                                    } else {
                                      buttonLabel = context.translate.get(exercise != null ?
                                      'stepPage.editExercise' : 'stepPage.nextExercise');
                                    }
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<AdditionalTimerLabelController, AdditionalTimerLabelState>(
                            bloc: additionalTimerLabelController,
                            builder: (context, state){

                              bool isAdditionalMinuteDefined = false;
                              bool isAdditionalSecondsDefined = false;

                              if(state.isAdditionalMinuteLabelDefined){
                                isAdditionalMinuteDefined = (state.value as String) != '00';
                              } else if (state.isAdditionalSecondsLabelDefined){
                                isAdditionalSecondsDefined = (state.value as String) != '00';
                              }

                              return Checkbox(
                                value: isAutoRest,
                                onChanged: isAdditionalMinuteDefined ||
                                    isAdditionalSecondsDefined ||
                                    state.isAdditionalTimerSelected ?
                                    (checkValue){
                                  setState(() {
                                    isAutoRest = checkValue ?? false;
                                  });
                                } : null,
                                checkColor: ColorApp.backgroundColor,
                                activeColor: ColorApp.mainColor,
                              );
                            }
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          context.translate.get('autoRest'),
                          style: TextStyle(
                              color: isAutoRest ?
                              ColorApp.mainColor : Colors.black26,
                              fontSize: 20
                          ),
                        )
                      ],
                    ),
                  ],
                )

            )
          ],
        ),
    )
    );
  }
}
