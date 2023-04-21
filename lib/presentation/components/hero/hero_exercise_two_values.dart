import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/exercise_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';

class HeroExerciseTwoValues extends StatefulWidget {

  final String? heroTag;

  const HeroExerciseTwoValues({
    super.key,
    required this.heroTag,
  });

  @override
  State<HeroExerciseTwoValues> createState() => _HeroExerciseTwoValuesState();
}

class _HeroExerciseTwoValuesState extends State<HeroExerciseTwoValues> {

  final exerciseController = GetIt.I.get<ExerciseController>();

  @override
  Widget build(BuildContext context) {

    bool isAdditional = widget.heroTag == heroAdditionalPopUp;

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
                        NumberPicker(
                            minValue: 0,
                            maxValue: 5,
                            value: int.parse(isAdditional ?
                              exerciseController.additionalMinutes :
                              exerciseController.minutes
                            ),
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
                              if(isAdditional){
                                exerciseController.setAdditionalMinute(minuteValue);
                              } else {
                                exerciseController.setMinute(minuteValue);
                              }
                              setState(() {});
                            }
                        ),
                        NumberPicker(
                            minValue: 0,
                            maxValue: 59,
                            value: int.parse(isAdditional ?
                              exerciseController.additionalSeconds :
                              exerciseController.seconds
                            ),
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
                              if(isAdditional){
                                exerciseController.setAdditionalSeconds(secondsValue);
                              } else {
                                exerciseController.setSeconds(secondsValue);
                              }
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
