import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:counting_your_fit_v2/app_localizations.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/individual/individual_exercise_states.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/individual/individual_exercise_controller.dart';
import 'package:counting_your_fit_v2/presentation/sheet/timer_helper_sheet.dart';
import 'package:counting_your_fit_v2/presentation/timer/individual/bloc/beep/individual_beep_volume_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/timer/individual/bloc/beep/individual_beep_volume_states.dart';
import 'package:counting_your_fit_v2/presentation/bloc/icon/button_icon_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/icon/button_icon_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/util/notification/notification_label_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class IndividualExerciseTimer extends StatefulWidget {
  const IndividualExerciseTimer({Key? key}) : super(key: key);

  @override
  State<IndividualExerciseTimer> createState() => _IndividualExerciseTimerState();
}

class _IndividualExerciseTimerState extends State<IndividualExerciseTimer> {

  late final StopWatchTimer stopWatchTimer;
  final individualExerciseController = GetIt.I.get<IndividualExerciseController>();

  IconData? volumeIcon;
  late bool isPortuguese;

  // NOTIFICATION
  late NotificationLabelBuilder notificationBuilder;

  // EXERCISE VALUES CONTROLLER
  final setsController = GetIt.I.get<SetsStateController>();
  final minuteController = GetIt.I.get<MinuteStateController>();
  final secondsController = GetIt.I.get<SecondsStateController>();
  final additionalMinuteController = GetIt.I.get<AdditionalMinuteStateController>();
  final additionalSecondsController = GetIt.I.get<AdditionalSecondsStateController>();
  final volumeController = IndividualBeepVolumeStateController();
  final iconController = ButtonIconStateController();

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
  double oldVolume = 1.0;
  double iconSize  = 80;
  bool fullVolumeSelected = true;

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

  void setPlayerVolume(double volume){

    if(volume > 0){
      oldVolume = volume;
    }

    tenSecondsPlayer.setVolume(volume);
    threeSecondsPlayer.setVolume(volume);
    finalTimePlayer.setVolume(volume);
  }

  void notify(IndividualExerciseState state) async {

    if(await Permission.notification.request().isGranted){
      if(context.mounted){
        notificationBuilder = NotificationLabelBuilder(context, individualState: state);

        Map<String, String> labels = notificationBuilder.build(currentSet: currentSet, setQuantity: setQuantity);

        String notificationTitle = labels['title']!;
        String notificationBody = labels['body']!;

        await AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 1,
                channelKey: 'ind',
                notificationLayout: NotificationLayout.BigText,
                title: notificationTitle,
                body: notificationBody
            )
        );
      }
    }
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

  void stopPlayer(AudioPlayer player){
    if(player.state == PlayerState.playing){
      player.stop();
    }
  }

  void finishExercise(){
    individualExerciseController.finishExercise();
    setsController.resetSet();
    minuteController.resetMinute();
    secondsController.resetSeconds();
    additionalMinuteController.resetAdditionalMinute();
    additionalSecondsController.resetAdditionalSeconds();
  }

  void cancelExercise() async {
    finishExercise();
    stopWatchTimer.onStopTimer();
    stopPlayer(tenSecondsPlayer);
    stopPlayer(threeSecondsPlayer);
    stopPlayer(finalTimePlayer);
    Navigator.pushReplacementNamed(context,
        CountingYourFitRoutes.timerSetting);
  }

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
            context.translate.get('exerciseTimer.cancelTitle'),
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
            context.translate.get('exerciseTimer.cancelDescription'),
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
          iconSize = 0;
          Future.delayed(
              const Duration(milliseconds: 200),
              () {
                iconController.isPlayIcon();
              }
          );
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

              finishExercise();
              Navigator.pushReplacementNamed(context,
                  CountingYourFitRoutes.timerSetting);
            }
          }
          hasEnded = true;
          Future.delayed(
            const Duration(milliseconds: 200),
            () => iconSize = 80
          );
          notify(individualExerciseController.state);
        }
      }
    );
  }

  void onCountdownTimer(){
    if(individualExerciseController.state.isExecuting ||
      individualExerciseController.state.isResting){
      return;
    }

    iconSize = 0;
    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        if(isToExecute){
          iconController.isExecutingIcon();
        } else {
          iconController.isRestingIcon();
        }
      }
    );
    if(isToExecute){
      hasEnded = individualExerciseController.execute();
    } else {
      hasEnded = individualExerciseController.rest();
    }
    finalBeepPlayQuantity = 0;
    Future.delayed(
      const Duration(milliseconds: 250),
        () => iconSize = 80
    );
    stopWatchTimer.onStartTimer();
    notify(individualExerciseController.state);
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    isPortuguese = context.translate.isPortuguese;

    return WillPopScope(
      onWillPop: onCancel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              await onCancel();
            },
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
                left: width * (isPortuguese ? .22 : .26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.translate.get('exerciseTimer.set'),
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
                      context.translate.get('exerciseTimer.of'),
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
                left: width * (isPortuguese ? .3 : .364),
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
                        context.translate.get('exerciseTimer.lastSet'),
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
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        BlocBuilder<ButtonIconStateController, ButtonIconState>(
                                          bloc: iconController,
                                          builder: (context, state) {
                                            return Positioned.fill(
                                              bottom: context.height * .08,
                                              child: TweenAnimationBuilder<double>(
                                                curve: Curves.easeOutQuad,
                                                duration: const Duration(milliseconds: 550),
                                                tween: Tween(begin: 80, end: iconSize),
                                                builder: (context, tween, child) {

                                                  IconData icon = Icons.play_arrow;

                                                  if(state.isPlayIcon) {
                                                    icon = Icons.play_arrow;
                                                  } else if (state.isRestingIcon) {
                                                    icon = Icons.timer;
                                                  } else {
                                                    icon = Icons.run_circle_outlined;
                                                  }

                                                  return Icon(
                                                    icon,
                                                    color: ColorApp.backgroundColor,
                                                    size: tween,
                                                    shadows: const [
                                                      Shadow(
                                                          color: Colors.black26,
                                                          blurRadius: 2,
                                                          offset: Offset(2, 2)
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                        Positioned.fill(
                                          top: context.height * .15,
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
                                      ],
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
                      actionText = context.translate.get('exerciseTimer.toExecute');
                    } else {
                      actionText = context.translate.get('exerciseTimer.toRest');
                    }

                    if (state.isExecuting){
                      actionText = context.translate.get('exerciseTimer.executing');
                    } else if(state.isResting){
                      actionText = context.translate.get('exerciseTimer.resting');
                    }

                    return Row(
                      children: [
                        Text(
                          actionText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: ColorApp.mainColor,
                            fontWeight: FontWeight.w600
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
              ),
              Positioned(
                bottom: height * .11,
                child: SizedBox(
                  width: width * .9,
                  child: BlocBuilder<IndividualBeepVolumeStateController, IndividualBeepVolumeState>(
                    bloc: volumeController,
                    builder: (context, state){
                      if(state.isFullVolume){
                        volumeIcon = FeatherIcons.volume2;
                      } else if (state.isMidVolume){
                        volumeIcon = FeatherIcons.volume1;
                      } else if (state.isLowVolume){
                        volumeIcon = FeatherIcons.volume;
                      } else {
                        volumeIcon = FeatherIcons.volumeX;
                      }

                      setPlayerVolume(state.volume);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: (){
                                // fullVolumeSelected = !fullVolumeSelected;
                                volumeController.setVolumeOnClick(state.volume);
                              },
                              icon: Icon(
                                volumeIcon ?? FeatherIcons.volume2,
                                size: 30,
                                color: ColorApp.mainColor,
                              )
                          ),
                          SizedBox(
                            width: width * .7,
                            child: Slider(
                              value: state.volume,
                              onChanged: (volume){
                                volumeController.setVolume(volume);
                                setPlayerVolume(volume);
                              },
                              max: 1.0,
                              min: .0,
                              activeColor: ColorApp.mainColor,
                              inactiveColor: Colors.grey,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              )
            ],
          ),
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
                  return const TimerHelperSheet();
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

  @override
  void dispose() {
    stopWatchTimer.dispose();
    for (var element in streams) {
      element.cancel();
    }
    super.dispose();
  }
}
