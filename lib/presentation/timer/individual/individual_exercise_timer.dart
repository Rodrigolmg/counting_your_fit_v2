import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/counting_your_fit_router.dart';
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

  // EXERCISES VALUES
  int setQuantity = 0;
  int currentSet = 1;
  int minuteValue = 0;
  int secondsValue = 0;
  int additionalMinuteValue = 0;
  int additionalSecondsValue = 0;
  double circularValue = 0.0;


  @override
  void initState() {
    super.initState();
    if(individualExerciseController.state.isExerciseDefined){
      ExerciseDefined exerciseDefined = individualExerciseController.state
      as ExerciseDefined;

      minuteValue = exerciseDefined.minute;
      secondsValue = exerciseDefined.seconds;
      setQuantity = exerciseDefined.set;

      if(exerciseDefined.additionalMinute != null){
        additionalMinuteValue = exerciseDefined.additionalMinute!;
      }

      if(exerciseDefined.additionalSeconds != null){
        additionalSecondsValue = exerciseDefined.additionalSeconds!;
      }
    }
    int presetMilli = StopWatchTimer.getMilliSecFromMinute(minuteValue) +
        StopWatchTimer.getMilliSecFromSecond(secondsValue);
    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: presetMilli,
      onChange: (value) {
        circularValue = value / presetMilli;

        if(value == 0){
          stopWatchTimer.onStopTimer();
          if(currentSet != setQuantity){
            stopWatchTimer.onResetTimer();
          }
          circularValue = 0.0;
        }
      },
      onEnded: (){
        if(currentSet == setQuantity){
          individualExerciseController.finishExercise();
          Navigator.pushReplacementNamed(context,
              CountingYourFitRoutes.timerSetting);
        } else {
          individualExerciseController.setNextSet(currentSet);
        }
      }
    );
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
                    const Text(
                      'Série',
                      style: TextStyle(
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
                    const Text(
                      'de',
                      style: TextStyle(
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

                  int set = state is NextSet ?
                  state.nextSet : 1;

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
                                    stopWatchTimer.onStartTimer();
                                    individualExerciseController.startExercise();
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
                child: Row(
                  children: [
                    Text(
                      'Descansando',
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
    super.dispose();
    stopWatchTimer.dispose();
  }
}
