import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_button.dart';
import 'package:counting_your_fit_v2/presentation/components/directional_button.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_variant.dart';
import 'package:counting_your_fit_v2/presentation/components/shake_error.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/individual/individual_exercise_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/timer_settings_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class IndividualExercisePage extends StatefulWidget {
  const IndividualExercisePage({Key? key}) : super(key: key);

  @override
  State<IndividualExercisePage> createState() => _IndividualExercisePageState();
}

class _IndividualExercisePageState extends State<IndividualExercisePage> {

  final _timeScreenController = GetIt.I.get<TimerSettingsStateController>();
  final individualExerciseController = GetIt.I.get<IndividualExerciseController>();
  final timerLabelController = GetIt.I.get<TimerLabelController>();
  final additionalTimerLabelController = GetIt.I.get<AdditionalTimerLabelController>();

  // EXERCISE CONTROLLERS
  final setsController = GetIt.I.get<SetsStateController>();
  final minuteController = GetIt.I.get<MinuteStateController>();
  final secondsController = GetIt.I.get<SecondsStateController>();

  bool hasAdditionalExercise = false;
  bool isAutoRest = false;
  final _shakeTimerKey = GlobalKey<ShakeErrorState>();
  final _shakeAdditionalKey = GlobalKey<ShakeErrorState>();

  String minuteLabel = '00';
  String secondsLabel = '00';
  String additionalMinutes = '00';
  String additionalSeconds = '00';
  int sets = 1;

  void trainCallback(){
    bool hasNoRestTime = minuteLabel == '00' &&
        secondsLabel == '00';

    if(hasNoRestTime) {
      _shakeTimerKey.currentState?.shake();
      return;
    }

    if(!hasAdditionalExercise){
      individualExerciseController.registerIndividualExercise(
        set: sets,
        minute: int.parse(minuteLabel),
        seconds: int.parse(secondsLabel)
      );

      Navigator.pushReplacementNamed(
        context,
        CountingYourFitRoutes.individualTimer
      );
    } else {
      bool hasAdditionalTime = additionalMinutes != '00' ||
          additionalSeconds != '00';

      if(!hasAdditionalTime){
        _shakeAdditionalKey.currentState?.shake();
        return;
      }

      individualExerciseController.registerIndividualExercise(
        set: sets,
        minute: int.parse(minuteLabel),
        seconds: int.parse(secondsLabel),
        additionalMinute: int.parse(additionalMinutes),
        additionalSeconds: int.parse(additionalSeconds),
        isAutoRest: isAutoRest
      );

      Navigator.pushReplacementNamed(
          context,
          CountingYourFitRoutes.individualTimer
      );
    }
  }

  @override
  void initState() {
    super.initState();
    timerLabelController.resetTimer();
    additionalTimerLabelController.resetAdditionalTimer();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
            top: 80,
            right: 7,
            child: DirectionalButton(
              icon: Icons.list,
              onTap: (){
                _timeScreenController.changePageOnClick(1);
              }
            )
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
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
                    buildWhen: (oldState, currentState)
                      => currentState.isSetDefined,
                    builder: (context, state) {

                      if(state.isSetDefined){
                        sets = (state as SetDefined).sets;
                      } else if (state.isSetReset){
                        sets = 1;
                      }

                      return HeroButton(
                        heroTag: heroSetsPopUp,
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
                      key: _shakeTimerKey,
                      duration: const Duration(milliseconds: 550),
                      shakeCount: 3,
                      shakeOffset: 10,
                      child: BlocBuilder<TimerLabelController, TimerLabelState>(
                        bloc: timerLabelController,
                        builder: (context, state) {
                          if(state.isMinuteLabelDefined){
                            minuteLabel = (state as MinuteLabelDefined).minuteLabel ?? '00';
                          } else if (state.isSecondsLabelDefined){
                            secondsLabel = (state as SecondsLabelDefined).secondsLabel ?? '00';
                          } else if(state.isTimerReset){
                            minuteLabel = '00';
                            secondsLabel = '00';
                          }

                          return HeroButton(
                            buttonLabel: '$minuteLabel:$secondsLabel',
                            heroTag: heroTimerPopUp,
                            hasError: _shakeTimerKey.currentState != null &&
                                _shakeTimerKey
                                    .currentState!.animationController.status
                                    == AnimationStatus.forward,
                            variant: HeroTimer(),
                          );
                        }
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
                      key: _shakeAdditionalKey,
                      duration: const Duration(milliseconds: 550),
                      shakeCount: 3,
                      shakeOffset: 10,
                      child: BlocBuilder<AdditionalTimerLabelController,
                          AdditionalTimerLabelState>(
                        bloc: additionalTimerLabelController,
                        builder: (context, state) {

                          if(state.isAdditionalMinuteLabelDefined){
                            additionalMinutes = state.value ?? '00';
                          } else if (state.isAdditionalSecondsLabelDefined){
                            additionalSeconds = state.value ?? '00';
                          }

                          return HeroButton(
                            heroTag: heroAdditionalPopUp,
                            hasError: _shakeAdditionalKey.currentState != null &&
                                _shakeAdditionalKey.currentState!
                                    .animationController.status
                                    == AnimationStatus.forward,
                            buttonLabel: '$additionalMinutes:$additionalSeconds',
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
        ),
        AnimatedPositioned(
          top: height * (!hasAdditionalExercise ? .52 : .59),
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
                    onPressed: trainCallback,
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
                              isAdditionalSecondsDefined ?
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
          ),

        )
      ],
    );
  }
}
