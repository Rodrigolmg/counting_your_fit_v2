import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/bloc/label/additional_timer_label_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/minute/additional_minute_state_controller.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/seconds/additional_seconds_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';

class HeroExerciseAdditionalTimerValues extends StatefulWidget {

  final String? heroTag;

  const HeroExerciseAdditionalTimerValues({
    super.key,
    required this.heroTag,
  });

  @override
  State<HeroExerciseAdditionalTimerValues> createState() => _HeroExerciseAdditionalTimerValuesState();
}

class _HeroExerciseAdditionalTimerValuesState extends State<HeroExerciseAdditionalTimerValues> {

  final additionalMinuteController = GetIt.I.get<AdditionalMinuteStateController>();
  final additionalSecondsController = GetIt.I.get<AdditionalSecondsStateController>();
  final additionalTimerLabel = GetIt.I.get<AdditionalTimerLabelController>();

  int additionalMinutes = 0;
  int additionalSeconds = 0;

  String formatValues(){
    String minuteLabel = additionalMinutes <= 9 ? '0$additionalMinutes' : additionalMinutes.toString();
    String secondsLabel = additionalSeconds <= 9 ? '0$additionalSeconds' : additionalSeconds.toString();

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
                        BlocBuilder<AdditionalMinuteStateController, AdditionalMinuteState>(
                          bloc: additionalMinuteController,
                          buildWhen: (oldState, currentState) =>
                            currentState.isAdditionalMinuteDefined,
                          builder: (context, state){

                            if(state.isAdditionalMinuteDefined){
                              additionalMinutes = (state as AdditionalMinuteDefined)
                                  .additionalMinute;
                              additionalTimerLabel.setMinuteLabel(additionalMinutes);
                            }

                            return NumberPicker(
                                minValue: 0,
                                maxValue: 5,
                                value: additionalMinutes,
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
                                  additionalMinuteController.setAdditionalMinute(minuteValue);
                                  // setState(() {});
                                }
                            );
                          },
                        ),
                        BlocBuilder<AdditionalSecondsStateController, AdditionalSecondsState>(
                            bloc: additionalSecondsController,
                            buildWhen: (oldState, currentState) =>
                              currentState.isAdditionalSecondsDefined,
                            builder: (context, state){

                              if(state.isAdditionalSecondsDefined){
                                additionalSeconds = (state as AdditionalSecondsDefined)
                                    .additionalSeconds;
                                additionalTimerLabel.setSecondsLabel(additionalSeconds);
                              }

                              return NumberPicker(
                                  minValue: 0,
                                  maxValue: 59,
                                  value: additionalSeconds,
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
                                    additionalSecondsController
                                        .setAdditionalSeconds(secondsValue);
                                    setState(() {});
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
