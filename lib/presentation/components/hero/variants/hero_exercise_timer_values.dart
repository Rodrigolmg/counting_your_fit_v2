import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/seconds_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/timer_label_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';

class HeroExerciseTimerValues extends StatefulWidget {

  final String? heroTag;

  const HeroExerciseTimerValues({
    super.key,
    required this.heroTag,
  });

  @override
  State<HeroExerciseTimerValues> createState() => _HeroExerciseTimerValuesState();
}

class _HeroExerciseTimerValuesState extends State<HeroExerciseTimerValues> {

  final minuteController = GetIt.I.get<MinuteStateController>();
  final secondsController = GetIt.I.get<SecondsStateController>();
  final timerLabel = GetIt.I.get<TimerLabelController>();
  final additionalTimerLabel = GetIt.I.get<AdditionalTimerLabelController>();
  final additionalMinute = GetIt.I.get<AdditionalMinuteStateController>();
  final additionalSeconds = GetIt.I.get<AdditionalSecondsStateController>();

  int minutes = 0;
  int seconds = 0;

  String formatValues(){
    String minuteLabel = minutes <= 9 ? '0$minutes' : minutes.toString();
    String secondsLabel = seconds <= 9 ? '0$seconds' : seconds.toString();

    return '$minuteLabel:$secondsLabel';
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Hero(
          tag: widget.heroTag!,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: ColorApp.mainColor,
            elevation: 2,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.5),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<MinuteStateController, MinuteState>(
                          bloc: minuteController,
                          builder: (context, state){

                            if(state.isMinuteDefined){
                              minutes = (state as MinuteDefined).minute;
                              if(minutes == 0 && seconds == 0){
                                timerLabel.checkAdditional(false);
                                additionalMinute.resetAdditionalMinute();
                                additionalTimerLabel.resetAdditionalTimer();
                              }
                            } else if(state.isMinuteReset){
                              minutes = 0;
                              timerLabel.resetTimer();
                            } else if (state.isMinuteSelected){
                              minutes = (state as MinuteSelected).minuteSelected;
                              if(minutes == 0 && seconds == 0){
                                timerLabel.checkAdditional(false);
                                additionalMinute.resetAdditionalMinute();
                                additionalTimerLabel.resetAdditionalTimer();
                              }
                            }

                            return NumberPicker(
                                minValue: 0,
                                maxValue: 5,
                                value: minutes,
                                infiniteLoop: true,
                                itemHeight: 35,
                                selectedTextStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 25,
                                ),
                                textStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20
                                ),
                                zeroPad: true,
                                decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.lightBlue,
                                        width: .3,
                                      ),
                                      right: BorderSide(
                                        color: Colors.lightBlue,
                                        width: .3,
                                      ),
                                    )
                                ),
                                onChanged: (minuteValue) {
                                  minuteController.setMinute(minuteValue);
                                }
                            );
                          },
                        ),
                        BlocBuilder<SecondsStateController, SecondsState>(
                            bloc: secondsController,
                            builder: (context, state){

                              if(state.isSecondsDefined){
                                seconds = (state as SecondsDefined).seconds;
                                if(minutes == 0 && seconds == 0){
                                  timerLabel.checkAdditional(false);
                                  additionalSeconds.resetAdditionalSeconds();
                                  additionalTimerLabel.resetAdditionalTimer();
                                }
                              } else if(state.isSecondsReset){
                                seconds = 0;
                                timerLabel.resetTimer();
                              } else if (state.isSecondsSelected){
                                seconds = (state as SecondsSelected).secondsSelected;
                                if(minutes == 0 && seconds == 0){
                                  timerLabel.checkAdditional(false);
                                  additionalSeconds.resetAdditionalSeconds();
                                  additionalTimerLabel.resetAdditionalTimer();
                                }
                              }


                              return NumberPicker(
                                  minValue: 0,
                                  maxValue: 59,
                                  value: seconds,
                                  infiniteLoop: true,
                                  itemHeight: 35,
                                  selectedTextStyle: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 25,
                                  ),
                                  textStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20
                                  ),
                                  zeroPad: true,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.lightBlue,
                                          width: .3,
                                        ),
                                      )
                                  ),
                                  onChanged: (secondsValue) {
                                    secondsController.setSeconds(secondsValue);
                                  }
                              );
                            }
                        )
                      ],
                    )
                  ),
                ),
                Positioned(
                  right: 5,
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorApp.backgroundColor,
                    )
                  )
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
