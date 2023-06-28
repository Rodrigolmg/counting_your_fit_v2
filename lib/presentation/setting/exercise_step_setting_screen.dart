import 'package:counting_your_fit_v2/app_localizations.dart';
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
import 'package:counting_your_fit_v2/presentation/sheet/exercises_helper_sheet.dart';
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

  late bool isPortuguese;

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
  final GlobalKey<ShakeErrorState> stepAdditionalCheckKey = GlobalKey<ShakeErrorState>();

  String minutesLabel = '00';
  String secondsLabel = '00';
  String additionalMinutesLabel = '00';
  String additionalSecondsLabel = '00';
  String buttonLabel = '';
  int sets = 1;
  List<int> steps = [1, 2];
  List<int> tempSteps = [1];
  final List<ExerciseSettingEntity> exercises = [];

  void trainCallback() async {
    timerLabelController.isStepTimeDefined(minutesLabel, secondsLabel);

    if(timerLabelController.state.hasNoStepTime) {
      stepTimerKey.currentState?.shake();
      return;
    }

    if(hasAdditionalExercise) {
      additionalTimerLabelController.isStepTimeDefined(additionalMinutesLabel, additionalSecondsLabel);

      if (additionalTimerLabelController.state.hasNoStepAdditionalTime) {
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
      timerLabelController.checkStepAdditional(false);
      timerLabelController.resetTimer();
      additionalTimerLabelController.resetAdditionalTimer();
      setsController.resetSet();
      minuteController.resetMinute();
      secondsController.resetSeconds();
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
    selectedStepIndex = stepIndex;
    if(exercises.isNotEmpty){
      if(exercises.asMap().containsKey(stepIndex)){
        exercise = exercises[stepIndex];
      }
    }

    exerciseListDefinitionController.selectExercise(exercise: exercise);

    if(exercise != null){
      stepController.selectStep(stepIndex);
      setsController.exerciseSelectSet(exercise);
      minuteController.selectExerciseMinute(exercise);
      secondsController.selectExerciseSeconds(exercise);
      timerLabelController.exerciseSelectTimer(exercise);
      additionalTimerLabelController.selectExerciseAdditionalTimer(exercise);
      additionalMinuteController.selectExerciseAdditionalMinute(exercise);
      additionalSecondsController.selectExerciseAdditionalSeconds(exercise);
    } else {
      stepController.selectStep(stepIndex);
      setsController.resetSet();
      minuteController.resetMinute();
      secondsController.resetSeconds();
      additionalMinuteController.resetAdditionalMinute();
      additionalSecondsController.resetAdditionalSeconds();
      timerLabelController.checkStepAdditional(false);
      additionalTimerLabelController.checkStepAutoRest(false);
      timerLabelController.resetTimer();
      additionalTimerLabelController.resetAdditionalTimer();
    }
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    isPortuguese = context.translate.isPortuguese;
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
                buildWhen: (oldState, currentState) =>
                currentState.isStepDefined ||
                currentState.isStepSelected ||
                currentState.isNextStep,
                builder: (context, state) {

                  if(state.isStepDefined){
                    steps = stepController.steps;
                  } else if (state.isStepSelected){
                    currentStepIndex = (state.value as int);
                  } else if (state.isNextStep){
                    currentStepIndex = (state.value as int);
                    if(!tempSteps.asMap().containsKey(currentStepIndex)){
                      if(steps.asMap().containsKey(currentStepIndex)){
                        tempSteps.add(steps[currentStepIndex]);
                      }
                    }
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
                    numbers: tempSteps,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    BlocBuilder<SetsStateController, SetsState>(
                      bloc: setsController,
                      buildWhen: (oldState, currentState) =>
                        currentState.isSetSelected ||
                        currentState.isExerciseSetSelected ||
                        currentState.isSetReset ||
                        currentState.isSetDefined,
                      builder: (context, state) {

                        if(state.isSetDefined){
                          sets = (state as SetDefined).sets;
                        } else if (state.isSetReset){
                          sets = 1;
                        } else if (state.isSetSelected){
                          sets = (state as SetSelected).setSelected;
                        } else if (state.isExerciseSetSelected){
                          sets = (state as ExerciseSetSelected).exerciseSelected.set;
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
                  padding: EdgeInsets.only(right: width * (isPortuguese ? .085 : .11)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${context.translate.get('rest')}:',
                        style: TextStyle(
                          color: ColorApp.mainColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<TimerLabelController, TimerLabelState>(
                        bloc: timerLabelController,
                        buildWhen: (oldState, currentState) =>
                          currentState.isTimerLabelSelected ||
                          currentState.isExerciseTimerLabelSelected ||
                          currentState.isMinuteLabelDefined ||
                          currentState.isSecondsLabelDefined ||
                          currentState.isTimerReset ||
                          currentState.hasNoStepTime,
                        builder: (context, state){

                          if (state.isTimerLabelSelected){
                            List<String> label = (state as TimerLabelSelected)
                                .timerSelected!.split(':');
                            minutesLabel = label[0];
                            secondsLabel = label[1];
                          } else if (state.isExerciseTimerLabelSelected) {
                            List<String> label = (state.value as String).split(':');
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

                          return ShakeError(
                            key: stepTimerKey,
                            duration: const Duration(milliseconds: 550),
                            shakeCount: 3,
                            shakeOffset: 10,
                            child: HeroButton(
                              buttonLabel: '$minutesLabel:$secondsLabel',
                              heroTag: heroTimerPopUpStep,
                              hasError: state.hasNoStepTime,
                              isStepConfig: true,
                              variant: HeroTimer(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ShakeError(
                  key: stepAdditionalCheckKey,
                  shakeOffset: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder<TimerLabelController, TimerLabelState>(
                        bloc: timerLabelController,
                        buildWhen: (oldState, currentState) =>
                          currentState.hasStepAdditionalExercise ||
                          currentState.isExerciseTimerLabelSelected ||
                              currentState.hasStepNoAdditionalTime,
                        builder: (context, state){

                          if (state.hasStepAdditionalExercise){
                            if(minutesLabel == '00' && secondsLabel == '00'){
                              timerLabelController.checkStepAdditional(false);
                            } else {
                              hasAdditionalExercise = (state as StepAdditionalExerciseDefined).value;
                            }
                          } else if (state.isExerciseTimerLabelSelected){
                            hasAdditionalExercise = (state as ExerciseTimerLabelSelected).exerciseSelected!.hasAdditionalTime ?? false;
                          }

                          return Checkbox(
                            value: hasAdditionalExercise,
                            onChanged: (checkValue){
                              if((minutesLabel != '00' ||
                                  secondsLabel != '00') || state.isTimerLabelSelected){
                                timerLabelController.checkStepAdditional(checkValue ?? false);
                                additionalTimerLabelController.resetAdditionalTimer();
                              } else {
                                timerLabelController.isStepTimeDefined(minutesLabel, secondsLabel);
                                stepTimerKey.currentState!.shake();
                              }
                            },
                            checkColor: ColorApp.backgroundColor,
                            activeColor: ColorApp.mainColor,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      BlocBuilder<TimerLabelController, TimerLabelState>(
                        bloc: timerLabelController,
                        buildWhen: (oldState, currentState) =>
                          currentState.hasStepAdditionalExercise ||
                          currentState.isExerciseTimerLabelSelected ||
                          currentState.hasStepNoAdditionalTime,
                        builder: (context, state){
                          Color textColor = Colors.black26;

                          if (state.hasStepAdditionalExercise){
                            hasAdditionalExercise = (state as StepAdditionalExerciseDefined).value;
                            textColor = hasAdditionalExercise ?
                            ColorApp.mainColor : Colors.black26;
                          } else if(state.hasStepNoAdditionalTime){
                            textColor = ColorApp.errorColor;
                          }
                          return Text(
                            context.translate.get('additionalExercise'),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                BlocBuilder<TimerLabelController, TimerLabelState>(
                  bloc: timerLabelController,
                  buildWhen: (oldState, currentState) =>
                    currentState.hasStepAdditionalExercise ||
                    currentState.isExerciseTimerLabelSelected,
                  builder: (context, state){

                    if(state.hasStepAdditionalExercise){
                      hasAdditionalExercise = (state as StepAdditionalExerciseDefined).value;
                    }

                    return AnimatedOpacity(
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold
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
                                } else if(state.isExerciseAdditionalTimeLabelSelected){
                                  label = state.value;
                                } else {
                                  label = '$additionalMinutesLabel:$additionalSecondsLabel';
                                }


                                return HeroButton(
                                  heroTag: heroAdditionalPopUpStep,
                                  hasError: state.hasNoStepAdditionalTime,
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
                    );
                  },
                ),
              ],
            ),
            BlocBuilder<TimerLabelController, TimerLabelState>(
              bloc: timerLabelController,
              buildWhen: (oldState, currentState) =>
                currentState.hasStepAdditionalExercise ||
                currentState.isExerciseTimerLabelSelected,
              builder: (context, state){
                if(state.hasStepAdditionalExercise){
                  hasAdditionalExercise = (state as StepAdditionalExerciseDefined).value;
                } else if (state.isExerciseTimerLabelSelected){
                  hasAdditionalExercise = (state as ExerciseTimerLabelSelected).exerciseSelected!.hasAdditionalTime ?? false;
                }
                return AnimatedPositioned(
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

                                  if (state.isStepAutoRestDefined){
                                    isAutoRest = (state as StepAutoRestDefined).value;
                                  } else if (state.isAdditionalTimerReset){
                                    isAutoRest = false;
                                  } else if (state.isExerciseAdditionalTimeLabelSelected){
                                    isAutoRest = (state as ExerciseAdditionalTimeLabelSelected).exerciseSelected!.isAutoRest ?? false;
                                  }

                                  return Checkbox(
                                    value: isAutoRest,
                                    onChanged: (checkValue){
                                        if((minutesLabel != '00' ||
                                            secondsLabel != '00') ||
                                            timerLabelController.state.isTimerLabelSelected){
                                          if(!hasAdditionalExercise){
                                            timerLabelController.checkStepAutoRestNoTime();
                                            stepAdditionalCheckKey.currentState!.shake();
                                            return;
                                          }
                                          if((additionalMinutesLabel != '00' ||
                                              additionalSecondsLabel != '00') ||
                                              state.isAdditionalTimerSelected){
                                            additionalTimerLabelController.checkStepAutoRest(checkValue ?? false);
                                          } else {
                                            additionalTimerLabelController.isStepTimeDefined(additionalMinutesLabel, additionalSecondsLabel);
                                            stepTimerAdditionalKey.currentState!.shake();
                                          }
                                        } else {
                                          timerLabelController.isStepTimeDefined(minutesLabel, secondsLabel);
                                          stepTimerKey.currentState!.shake();
                                        }
                                    },
                                    checkColor: ColorApp.backgroundColor,
                                    activeColor: ColorApp.mainColor,
                                  );
                                }
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            BlocBuilder<AdditionalTimerLabelController, AdditionalTimerLabelState>(
                              bloc: additionalTimerLabelController,
                              builder: (context, state){
                                return Text(
                                  context.translate.get('autoRest'),
                                  style: TextStyle(
                                    color: isAutoRest ?
                                    ColorApp.mainColor : Colors.black26,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                );
                              },
                            ),

                          ],
                        ),
                      ],
                    )

                );
              },
            ),
          ],
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
                  return const ExercisesHelperSheet();
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
    )
    );
  }
}
