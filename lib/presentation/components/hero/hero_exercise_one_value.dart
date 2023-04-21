import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/exercise_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';


class HeroExerciseOneValue extends StatefulWidget {

  final String? heroTag;

  const HeroExerciseOneValue({
    super.key,
    required this.heroTag,
  });

  @override
  State<HeroExerciseOneValue> createState() => _HeroExerciseOneValueState();
}

class _HeroExerciseOneValueState extends State<HeroExerciseOneValue> {

  final exerciseController = GetIt.I.get<ExerciseController>();

  @override
  Widget build(BuildContext context) {

    bool isSet = widget.heroTag! == heroSetsPopUp;

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
                  padding: const EdgeInsets.fromLTRB(100, 60, 100, 40),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NumberPicker(
                            minValue: 1,
                            maxValue: 10,
                            value: isSet ?
                              exerciseController.sets :
                              exerciseController.stepQuantity,
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
                            onChanged: (value){
                              if(isSet){
                                exerciseController.setSets(value);
                              } else {
                                exerciseController.setSteps(value);
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
