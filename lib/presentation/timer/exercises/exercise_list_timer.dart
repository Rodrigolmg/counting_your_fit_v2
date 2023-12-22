import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:counting_your_fit_v2/app_localizations.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/context_extension.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
import 'package:counting_your_fit_v2/domain/entities/exercise_setting_entity.dart';
import 'package:counting_your_fit_v2/presentation/bloc/icon/button_icon_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/icon/button_icon_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/components/exercise_counter_title.dart';
import 'package:counting_your_fit_v2/presentation/components/set_counter_title.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_controller.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/exercises/exercise_list_states.dart';
import 'package:counting_your_fit_v2/presentation/sheet/timer_helper_sheet.dart';
import 'package:counting_your_fit_v2/presentation/timer/exercises/bloc/exercises_beep_volume_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/timer/exercises/bloc/exercises_beep_volume_states.dart';
import 'package:counting_your_fit_v2/presentation/util/notification/notification_label_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ExerciseListTimer extends StatefulWidget {
  const ExerciseListTimer({Key? key}) : super(key: key);

  @override
  State<ExerciseListTimer> createState() => _ExerciseListTimerState();
}

class _ExerciseListTimerState extends State<ExerciseListTimer> {

  late bool isPortuguese;
  late final StopWatchTimer stopWatchTimer;
  final exerciseListDefinitionController = GetIt.I.get<ExerciseListDefinitionController>();

  // NOTIFICATION
  late NotificationLabelBuilder notificationBuilder;

  // EXERCISE VALUES CONTROLLER
  final setsController = GetIt.I.get<SetsStateController>();
  final minuteController = GetIt.I.get<MinuteStateController>();
  final secondsController = GetIt.I.get<SecondsStateController>();
  final additionalMinuteController = GetIt.I.get<AdditionalMinuteStateController>();
  final additionalSecondsController = GetIt.I.get<AdditionalSecondsStateController>();
  final volumeController = ExercisesBeepVolumeStateController();
  final iconController = ButtonIconStateController();

  // EXERCISES VALUES
  List<ExerciseSettingEntity> exercises = [];
  late ExerciseSettingEntity currentExercise;
  int exerciseIndex = 0;
  int currentSet = 1;
  double circularValue = 0.0;
  String actionLabel = '';
  bool isAutoRest = false;
  bool isToExecute = false;
  bool hasEnded = false;

  // AUDIO PLAYERS
  final tenSecondsPlayer = AudioPlayer(playerId: 'ten2')..setReleaseMode(ReleaseMode.stop);
  final threeSecondsPlayer = AudioPlayer(playerId: 'three2')..setReleaseMode(ReleaseMode.stop);
  final finalTimePlayer = AudioPlayer(playerId: 'final2')..setReleaseMode(ReleaseMode.stop);
  List<StreamSubscription> streams = [];
  IconData? volumeIcon;

  double iconSize  = 80;

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
    tenSecondsPlayer.setVolume(volume);
    threeSecondsPlayer.setVolume(volume);
    finalTimePlayer.setVolume(volume);
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
    exerciseListDefinitionController.finishExercises();
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

  void onCancel(bool? canPop) async {
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
  }

  int getInitialTime(){
    int? additionalMinuteValue = currentExercise.additionalMinute;
    int? additionalSecondsValue = currentExercise.additionalSeconds;

    int presetMilli = StopWatchTimer.getMilliSecFromMinute(
        (additionalMinuteValue != null && additionalMinuteValue > 0) ? additionalMinuteValue
            : currentExercise.minute) +
        StopWatchTimer.getMilliSecFromSecond((additionalSecondsValue != null && additionalSecondsValue > 0)
            ? additionalSecondsValue : currentExercise.seconds);

    return presetMilli;
  }

  int getTime(){

    int presetMilli = StopWatchTimer.getMilliSecFromMinute(currentExercise.minute) +
        StopWatchTimer.getMilliSecFromSecond(currentExercise.seconds);

    return presetMilli;
  }

  int getAdditionalTime(){

    int presetMilli = StopWatchTimer.getMilliSecFromMinute(currentExercise.additionalMinute!) +
        StopWatchTimer.getMilliSecFromSecond(currentExercise.additionalSeconds!);

    return presetMilli;
  }

  void notify(ExerciseListDefinitionStates state) async {

    if(await Permission.notification.request().isGranted){
      if(context.mounted){
        notificationBuilder = NotificationLabelBuilder(context, exerciseListDefinitionState: state);

        Map<String, String> labels = notificationBuilder.build(
            currentSet: currentSet,
            setQuantity: currentExercise.set,
            exerciseIndex: exerciseIndex
        );

        await AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 2,
                channelKey: 'list',
                notificationLayout: NotificationLayout.BigText,
                title: labels['title'],
                body: labels['body']
            )
        );
      }
    }

  }

  @override
  void initState() {
    super.initState();
    configPlayers();

    if(exerciseListDefinitionController.state.isExerciseListDefined){
      ExerciseListDefined exerciseDefined = exerciseListDefinitionController.state
        as ExerciseListDefined;

      exercises = List.from(exerciseDefined.exercises);
      currentExercise = exercises[exerciseIndex];

      if((currentExercise.additionalMinute != null && currentExercise.additionalMinute! > 0) ||
          (currentExercise.additionalSeconds != null && currentExercise.additionalSeconds! > 0)){
        isToExecute = true;
      }

      isAutoRest = currentExercise.isAutoRest ?? false;

    }

    int presetMilli = getInitialTime();

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

          if(exerciseListDefinitionController.state.isCurrentResting){
            exerciseListDefinitionController.finishCurrentRest();
            isToExecute = currentExercise.hasAdditionalTime ?? false;
          } else if (exerciseListDefinitionController.state.isCurrentExecuting){
            exerciseListDefinitionController.finishCurrentExecute();
            isToExecute = false;
          }
          notify(exerciseListDefinitionController.state);
          if(exerciseListDefinitionController.state.isCurrentExecuteFinished){
            presetMilli = getTime();
            stopWatchTimer.setPresetTime(mSec: presetMilli, add: false);
            if(currentExercise.isAutoRest!){
              Future.delayed(
                const Duration(seconds: 1),
                (){
                  onCountdownTimer();
                }
              );
            }
          } else if(exerciseListDefinitionController.state.isCurrentRestFinished) {

            if(currentExercise.hasAdditionalTime!){
              presetMilli = getAdditionalTime();
              stopWatchTimer.setPresetTime(mSec: presetMilli, add: false);
            }

            if(currentSet < currentExercise.set){
              exerciseListDefinitionController.nextExerciseSet(++currentSet);
            } else {
              exerciseListDefinitionController.nextExercise(++exerciseIndex);
              currentSet = 1;
            }

            if(((exerciseIndex + 1) > exercises.length)){
              finishExercise();
              notify(exerciseListDefinitionController.state);
              Navigator.pushReplacementNamed(context,
                  CountingYourFitRoutes.timerSetting);
            } else {
              currentExercise = exercises[exerciseIndex];
              if((currentExercise.additionalMinute != null && currentExercise.additionalMinute! > 0) ||
                  (currentExercise.additionalSeconds != null && currentExercise.additionalSeconds! > 0)){
                isToExecute = true;
              }
              presetMilli = getInitialTime();
              stopWatchTimer.setPresetTime(mSec: presetMilli, add: false);
            }
          }
          hasEnded = true;
          Future.delayed(
              const Duration(milliseconds: 200),
                  () => iconSize = 80
          );
        }
      }
    );
  }

  void onCountdownTimer(){
    if(exerciseListDefinitionController.state.isCurrentExecuting ||
        exerciseListDefinitionController.state.isCurrentResting){
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
    finalBeepPlayQuantity = 0;
    Future.delayed(
        const Duration(milliseconds: 250),
            () => iconSize = 80
    );
    stopWatchTimer.onStartTimer();
    if(isToExecute){
      hasEnded = exerciseListDefinitionController.executeCurrent();
    } else {
      hasEnded = exerciseListDefinitionController.restCurrent();
    }
    notify(exerciseListDefinitionController.state);
  }

  @override
  Widget build(BuildContext context) {

    double height = context.height;
    double width = context.width;
    isPortuguese = context.translate.isPortuguese;

    return PopScope(
      onPopInvoked: onCancel,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              onCancel(true);
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
                  top: height * .09,
                  left: width * .102,
                  child: BlocBuilder<ExerciseListDefinitionController,
                      ExerciseListDefinitionStates>(
                      bloc: exerciseListDefinitionController,
                      builder: (context, state){

                        if(state.isNextExercise){
                          exerciseIndex = (state as NextExercise).nextExercise;
                        }

                        return SizedBox(
                          width: width * .8,
                          child: ExerciseCounterTitle(
                            currentExercise: exerciseIndex + 1,
                            totalExerciseQuantity: exercises.length
                          ),
                        );
                      }
                  )
              ),
              Positioned(
                  top: height * .17,
                  left: width * .11,
                  child: BlocBuilder<ExerciseListDefinitionController,
                      ExerciseListDefinitionStates>(
                      bloc: exerciseListDefinitionController,
                      builder: (context, state) {

                        if(state.isNextExercise){
                          exerciseIndex = (state as NextExercise).nextExercise;
                        }

                        return SizedBox(
                          width: width * .8,
                          child: SetCounterTitle(
                            currentSet: currentSet,
                            setQuantity: currentExercise.set
                          ),
                        );
                      }
                  )
              ),
              Positioned(
                top: height * .25,
                left: width * (isPortuguese ? .3 : .364),
                child: BlocBuilder<ExerciseListDefinitionController, ExerciseListDefinitionStates>(
                  bloc: exerciseListDefinitionController,
                  buildWhen: (oldState, currentState) =>
                    currentState.isCurrentNextSet || currentState.isCurrentRestFinished,
                  builder: (context, state){

                    int set = state is CurrentExerciseNextSet ?
                      state.nextSet : 1;

                    return AnimatedOpacity(
                      opacity: set == currentExercise.set ? 1 : 0,
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
              BlocBuilder<ExerciseListDefinitionController, ExerciseListDefinitionStates>(
                bloc: exerciseListDefinitionController,
                buildWhen: (oldState, currentState) =>
                  currentState.isCurrentNextSet || currentState.isCurrentRestFinished,
                builder: (context, state){

                  int set = state is CurrentExerciseNextSet ? state.nextSet : 1;

                  return AnimatedPositioned(
                    top: height * (set == currentExercise.set ? .32 : .30),
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
                              BlocBuilder<ExerciseListDefinitionController, ExerciseListDefinitionStates>(
                                bloc: exerciseListDefinitionController,
                                builder: (context, state){
                                  return CircularProgressIndicator(
                                    strokeWidth: 8,
                                    backgroundColor: state
                                        .isExerciseListDefined ? Colors.grey : ColorApp.mainColor,
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
                                          )
                                        )
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
                bottom: height * .19,
                child: BlocBuilder<ExerciseListDefinitionController, ExerciseListDefinitionStates>(
                  bloc: exerciseListDefinitionController,
                  builder: (context, state) {
                    String actionText = '';

                    if(isToExecute){
                      actionText = context.translate.get('exerciseTimer.toExecute');
                    } else {
                      actionText = context.translate.get('exerciseTimer.toRest');
                    }

                    if (state.isCurrentExecuting){
                      actionText = context.translate.get('exerciseTimer.executing');
                    } else if(state.isCurrentResting){
                      actionText = context.translate.get('exerciseTimer.resting');
                    }

                    return Row(
                      children: [
                        Text(
                          actionText,
                          style: TextStyle(
                            fontSize: 25,
                            color: ColorApp.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if(state.isCurrentExecuting || state.isCurrentResting)
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
                    width: width * .8,
                    child: BlocBuilder<ExercisesBeepVolumeStateController, ExercisesBeepVolumeState>(
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

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              volumeIcon ?? FeatherIcons.volume2,
                              size: 30,
                              color: ColorApp.mainColor,
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
