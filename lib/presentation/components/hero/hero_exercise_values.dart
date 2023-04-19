import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/timer_settings_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';

class HeroExerciseValues extends StatefulWidget {

  final String? heroTag;

  const HeroExerciseValues({
    super.key,
    required this.heroTag,
  });

  @override
  State<HeroExerciseValues> createState() => _HeroExerciseValuesState();
}

class _HeroExerciseValuesState extends State<HeroExerciseValues> {

  final timeScreenController = GetIt.I.get<TimerSettingsStateController>();
  List<Widget> pickers = [];

  void pickerBuilder(){
    switch(widget.heroTag!){
      case heroTimerPopUp:
        pickers = [
            NumberPicker(
                minValue: 0,
                maxValue: 5,
                value: int.parse(timeScreenController.minutes),
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
                textMapper: (number){
                  if(int.parse(number) <= 9){
                    return '0$number';
                  }
                  return number;
                },
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
                onChanged: (minuteValue){
                  timeScreenController.setMinute(minuteValue);
                  setState(() {});
                }
            ),
            NumberPicker(
                minValue: 0,
                maxValue: 59,
                value: int.parse(timeScreenController.seconds),
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
                textMapper: (number){
                  if(int.parse(number) <= 9){
                    return '0$number';
                  }

                  return number;
                },
                decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.lightBlue,
                        width: .3,
                      ),
                    )
                ),
                onChanged: (secondsValue){
                  timeScreenController.setSeconds(secondsValue);
                  setState(() {});
                }
            ),
          ];
        break;
      case heroAdditionalPopUp:
        pickers = [
          NumberPicker(
              minValue: 0,
              maxValue: 5,
              value: int.parse(timeScreenController.additionalMinutes),
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
              textMapper: (number){
                if(int.parse(number) <= 9){
                  return '0$number';
                }
                return number;
              },
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
              onChanged: (minuteValue){
                timeScreenController.setAdditionalMinute(minuteValue);
                setState(() {});
              }
          ),
          NumberPicker(
              minValue: 0,
              maxValue: 59,
              value: int.parse(timeScreenController.additionalSeconds),
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
              textMapper: (number){
                if(int.parse(number) <= 9){
                  return '0$number';
                }

                return number;
              },
              decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.lightBlue,
                      width: .3,
                    ),
                  )
              ),
              onChanged: (secondsValue){
                timeScreenController.setAdditionalSeconds(secondsValue);
                setState(() {});
              }
          ),
        ];
        break;
      case heroSetsPopUp:
        pickers = [
          NumberPicker(
              minValue: 1,
              maxValue: 10,
              value: timeScreenController.sets,
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
              onChanged: (sets){
                timeScreenController.setSets(sets);
                setState(() {});
              }
          )
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    bool areTwoPickers = widget.heroTag! == heroTimerPopUp ||
        widget.heroTag! == heroAdditionalPopUp;

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
                  padding: areTwoPickers ?
                    const EdgeInsets.all(65.0) :
                    const EdgeInsets.fromLTRB(100, 65, 100, 65),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(widget.heroTag! == heroTimerPopUp)
                          NumberPicker(
                              minValue: 0,
                              maxValue: 5,
                              value: int.parse(timeScreenController.minutes),
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
                              textMapper: (number) {
                                if (int.parse(number) <= 9) {
                                  return '0$number';
                                }
                                return number;
                              },
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
                                timeScreenController.setMinute(minuteValue);
                                setState(() {});
                              }
                          ),
                        if(widget.heroTag! == heroTimerPopUp)
                          NumberPicker(
                              minValue: 0,
                              maxValue: 59,
                              value: int.parse(timeScreenController.seconds),
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
                              textMapper: (number) {
                                if (int.parse(number) <= 9) {
                                  return '0$number';
                                }

                                return number;
                              },
                              decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.lightBlue,
                                      width: .3,
                                    ),
                                  )
                              ),
                              onChanged: (secondsValue) {
                                timeScreenController.setSeconds(secondsValue);
                                setState(() {});
                              }
                          ),
                        if(widget.heroTag! == heroAdditionalPopUp)
                          NumberPicker(
                              minValue: 0,
                              maxValue: 5,
                              value: int.parse(timeScreenController.additionalMinutes),
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
                              textMapper: (number){
                                if(int.parse(number) <= 9){
                                  return '0$number';
                                }
                                return number;
                              },
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
                              onChanged: (minuteValue){
                                timeScreenController.setAdditionalMinute(minuteValue);
                                setState(() {});
                              }
                          ),
                        if(widget.heroTag! == heroAdditionalPopUp)
                          NumberPicker(
                              minValue: 0,
                              maxValue: 59,
                              value: int.parse(timeScreenController.additionalSeconds),
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
                              textMapper: (number){
                                if(int.parse(number) <= 9){
                                  return '0$number';
                                }

                                return number;
                              },
                              decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.lightBlue,
                                      width: .3,
                                    ),
                                  )
                              ),
                              onChanged: (secondsValue){
                                timeScreenController.setAdditionalSeconds(secondsValue);
                                setState(() {});
                              }
                          ),
                        if(widget.heroTag! == heroSetsPopUp)
                          NumberPicker(
                              minValue: 1,
                              maxValue: 10,
                              value: timeScreenController.sets,
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
                              onChanged: (sets){
                                timeScreenController.setSets(sets);
                                setState(() {});
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
