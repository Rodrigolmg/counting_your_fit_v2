import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercise_states.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/individual_exercise_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class IndividualExerciseTimer extends StatefulWidget {
  const IndividualExerciseTimer({Key? key}) : super(key: key);

  @override
  State<IndividualExerciseTimer> createState() => _IndividualExerciseTimerState();
}

class _IndividualExerciseTimerState extends State<IndividualExerciseTimer> {

  late final StopWatchTimer stopWatchTimer;
  final individualExerciseController = GetIt.I.get<IndividualExerciseController>();

  // EXERCISE VALUES CONTROLLER
  final setsController = GetIt.I.get<SetsStateController>();
  final minuteController = GetIt.I.get<MinuteStateController>();
  final secondsController = GetIt.I.get<SecondsStateController>();
  final additionalMinuteController = GetIt.I.get<AdditionalMinuteStateController>();
  final additionalSecondsController = GetIt.I.get<AdditionalSecondsStateController>();

  // EXERCISES VALUES
  int setQuantity = 0;
  int currentSet = 1;
  int minuteValue = 0;
  int secondsValue = 0;
  int? additionalMinuteValue;
  int? additionalSecondsValue;
  double circularValue = 0.0;
  String actionLabel = '';
  bool isAutoRest = false;
  bool isToExecute = false;
  bool hasEnded = false;

  // AUDIO PLAYERS
  final tenSecondsPlayer = AudioPlayer(playerId: 'ten')..setReleaseMode(ReleaseMode.stop);
  final threeSecondsPlayer = AudioPlayer(playerId: 'three')..setReleaseMode(ReleaseMode.stop);
  final finalTimePlayer = AudioPlayer(playerId: 'final')..setReleaseMode(ReleaseMode.stop);
  List<StreamSubscription> streams = [];

  // LOGICAL VALUE FOR PLAY FINAL BEEP ONLY ONE TIME
  int finalBeepPlayQuantity = 0;

  void configPlayer(AudioPlayer player, String asset) async {
    await player.setPlayerMode(PlayerMode.lowLatency);
    await player.setSource(AssetSource(asset));
    await player.setVolume(0.5);
    player.onLog.listen(
            (event) => AudioLogger.log(event),
        onError: (e) => AudioLogger.errorToString(e)
    );
    streams.add(player.onPlayerStateChanged.listen((event) {}));
  }

  void configPlayers() {
    configPlayer(tenSecondsPlayer, 'sounds/ten_seconds_beep.mp3');
    configPlayer(threeSecondsPlayer, 'sounds/beep_a.mp3');
    configPlayer(finalTimePlayer, 'sounds/final_beep.mp3');
  }

  void play(AudioPlayer player, int stopTime) async {
    await player.resume();
    Future.delayed(
      Duration(milliseconds: stopTime),
          () async {
        await player.stop();
        await player.audioCache.clearAll();
      }
    );
  }

  void playBeep(int second) {
    if(second < 11 && second >= 10){
      play(tenSecondsPlayer, 1001);
    } else if (second == 3 || second == 2 || second == 1){
      play(threeSecondsPlayer, 500);
    } else if (second == 0){
      if(finalBeepPlayQuantity == 0){
        play(finalTimePlayer, 500);
        finalBeepPlayQuantity++;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    configPlayers();

    if(individualExerciseController.state.isExerciseDefined){
      ExerciseDefined exerciseDefined = individualExerciseController.state
      as ExerciseDefined;

      minuteValue = exerciseDefined.minute;
      secondsValue = exerciseDefined.seconds;
      setQuantity = exerciseDefined.set;

      if(exerciseDefined.additionalMinute != null){
        additionalMinuteValue = exerciseDefined.additionalMinute!;
        isToExecute = true;
      }

      if(exerciseDefined.additionalSeconds != null){
        additionalSecondsValue = exerciseDefined.additionalSeconds!;
        isToExecute = true;
      }

      isAutoRest = exerciseDefined.isAutoRest;

    }

    int presetMilli = StopWatchTimer.getMilliSecFromMinute(additionalMinuteValue ?? minuteValue) +
        StopWatchTimer.getMilliSecFromSecond(additionalSecondsValue ?? secondsValue);

    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: presetMilli,
      onChange: (value) {
        circularValue = value / presetMilli;
        if(value == 0){
          stopWatchTimer.onResetTimer();
          circularValue = 0.0;
          return;
        }
      },
      onChangeRawSecond: (second){
        playBeep(second);
      },
      onEnded: () {
        if(!hasEnded){
          stopWatchTimer.onStopTimer();

          if(individualExerciseController.state.isResting){
            individualExerciseController.finishResting();
            isToExecute = (additionalMinuteValue != null && additionalMinuteValue! > 0)
                || (additionalSecondsValue != null && additionalSecondsValue! > 0);
          } else if (individualExerciseController.state.isExecuting){
            individualExerciseController.finishExecuting();
            isToExecute = false;
          }

          if(individualExerciseController.state.isExecuteFinished){
            presetMilli = StopWatchTimer.getMilliSecFromMinute(minuteValue) +
                StopWatchTimer.getMilliSecFromSecond(secondsValue);
            stopWatchTimer.setPresetTime(mSec: presetMilli, add: false);
            if(isAutoRest){
              Future.delayed(
                const Duration(seconds: 1),
                (){
                  onCountdownTimer();
                }
              );
            }
          } else if(individualExerciseController.state.isRestFinished) {

            if((additionalMinuteValue != null && additionalMinuteValue! > 0)
                || (additionalSecondsValue != null && additionalSecondsValue! > 0)){
              presetMilli = StopWatchTimer.getMilliSecFromMinute(additionalMinuteValue!) +
                  StopWatchTimer.getMilliSecFromSecond(additionalSecondsValue!);
              stopWatchTimer.setPresetTime(mSec: presetMilli, add: false);
            }

            individualExerciseController.setNextSet(currentSet);
            if(currentSet == setQuantity){
              individualExerciseController.finishExercise();
              setsController.resetSet();
              minuteController.resetMinute();
              secondsController.resetSeconds();
              additionalMinuteController.resetAdditionalMinute();
              additionalSecondsController.resetAdditionalSeconds();

              Navigator.pushReplacementNamed(context,
                  CountingYourFitRoutes.timerSetting);
            }
          }
          hasEnded = true;
        }
      }
    );
  }

  void onCountdownTimer(){
    finalBeepPlayQuantity = 0;
    stopWatchTimer.onStartTimer();
    setState(() {
      hasEnded = false;
    });
    if(isToExecute){
      individualExerciseController.execute();
    } else {
      individualExerciseController.rest();
    }
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: (){},
            icon: Icon(
              Icons.watch_off,
              color: ColorApp.mainColor,
            )
          ),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: height * .13,
                left: width * .22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.translate.get('individualExercise.set'),
                      style: const TextStyle(
                        fontSize: 35,
                      ),
                    ),
                    const SizedBox(width: 15),
                    BlocBuilder<IndividualExerciseController, IndividualExerciseState>(
                        bloc: individualExerciseController,
                        builder: (context, state){
                          if (state.isNextSet){
                            currentSet = (state as NextSet).nextSet;
                          }

                          return Text(
                            '$currentSet',
                            style: TextStyle(
                              fontSize: 50,
                              color: ColorApp.mainColor,
                            ),
                          );
                        }
                    ),
                    const SizedBox(width: 15),
                    Text(
                      context.translate.get('individualExercise.of'),
                      style: const TextStyle(
                          fontSize: 35
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                    '$setQuantity',
                    style: TextStyle(
                      fontSize: 50,
                      color: ColorApp.mainColor,
                    ),
                  ),
                ],
              )
              ),
              Positioned(
                top: height * .22,
                left: width * .3,
                child: BlocBuilder<IndividualExerciseController, IndividualExerciseState>(
                  bloc: individualExerciseController,
                  buildWhen: (oldState, currentState) => currentState.isNextSet,
                  builder: (context, state){

                    int set = state is NextSet ?
                      state.nextSet : 1;

                    return AnimatedOpacity(
                      opacity: set == setQuantity ? 1 : 0,
                      duration: const Duration(milliseconds: 550),
                      child: Text(
                        'Última série',
                        style: TextStyle(
                          color: ColorApp.errorColor2,
                          fontSize: 30,
                          shadows: const [
                            Shadow(
                                color: Colors.black26,
                                blurRadius: 1,
                                offset: Offset(1, 1)
                            )
                          ]
                        ),
                      ),
                    );
                  },
                )
              ),
              BlocBuilder<IndividualExerciseController, IndividualExerciseState>(
                bloc: individualExerciseController,
                buildWhen: (oldState, currentState) => currentState.isNextSet,
                builder: (context, state){

                  int set = state is NextSet ? state.nextSet : 1;

                  return AnimatedPositioned(
                    top: height * (set == setQuantity ? .29 : .27),
                    left: width * .19,
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: StreamBuilder<int>(
                        stream: stopWatchTimer.rawTime,
                        initialData: stopWatchTimer.rawTime.value,
                        builder: (context, snap) {

                          final int value = snap.requireData;
                          final String displayTime = StopWatchTimer.getDisplayTime(
                            value,
                            hours: false,
                            milliSecond: false,
                          );

                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              BlocBuilder<IndividualExerciseController, IndividualExerciseState>(
                                bloc: individualExerciseController,
                                builder: (context, state){
                                  return CircularProgressIndicator(
                                    strokeWidth: 8,
                                    backgroundColor: state
                                        .isExerciseDefined ? Colors.grey : ColorApp.mainColor,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
                                    value: circularValue,
                                  );
                                },
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {

                                    if(state.isResting || state.isExecuting){
                                      return;
                                    }

                                    onCountdownTimer();
                                  },
                                  child: Container(
                                    width: 230,
                                    height: 230,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorApp.mainColor,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black54,
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: Offset(1, 1)
                                          )
                                        ]
                                    ),
                                    child: Center(
                                      child: Text(
                                        displayTime,
                                        style: TextStyle(
                                          color: value >= 3999 ? ColorApp.backgroundColor
                                              : ColorApp.errorColor2,
                                          fontSize: 50,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.black26,
                                              blurRadius: 2,
                                              offset: Offset(2, 2)
                                            )
                                          ]
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: height * .21,
                child: BlocBuilder<IndividualExerciseController, IndividualExerciseState>(
                  bloc: individualExerciseController,
                  builder: (context, state) {
                    String actionText = '';

                    if(isToExecute){
                      actionText = context.translate.get('individualExercise.toExecute');
                    } else {
                      actionText = context.translate.get('individualExercise.toRest');
                    }

                    if (state.isExecuting){
                      actionText = context.translate.get('individualExercise.executing');
                    } else if(state.isResting){
                      actionText = context.translate.get('individualExercise.resting');
                    }

                    return Row(
                      children: [
                        Text(
                          actionText,
                          style: TextStyle(
                              fontSize: 25,
                              color: ColorApp.mainColor,
                              shadows: const [
                                Shadow(
                                    color: Colors.black54,
                                    offset: Offset(.1, .1),
                                    blurRadius: .5
                                )
                              ]
                          ),
                        ),
                        if(state.isResting || state.isExecuting)
                          AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                  '...',
                                  speed: const Duration(milliseconds: 100),
                                  textStyle: TextStyle(
                                      fontSize: 25,
                                      color: ColorApp.mainColor,
                                      shadows: const [
                                        Shadow(
                                            color: Colors.black54,
                                            offset: Offset(.1, .1),
                                            blurRadius: .5
                                        )
                                      ]
                                  )
                              )
                            ],
                            repeatForever: true,
                          )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopWatchTimer.dispose();
    streams.forEach((element) => element.cancel());
    super.dispose();
  }
}
