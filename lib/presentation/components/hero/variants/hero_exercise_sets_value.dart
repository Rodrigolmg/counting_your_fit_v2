import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state.dart';
import 'package:counting_your_fit_v2/presentation/bloc/sets/sets_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';


class HeroExerciseSetsValue extends StatefulWidget {

  final String? heroTag;

  const HeroExerciseSetsValue({
    super.key,
    required this.heroTag,
  });

  @override
  State<HeroExerciseSetsValue> createState() => _HeroExerciseSetsValueState();
}

class _HeroExerciseSetsValueState extends State<HeroExerciseSetsValue> {

  final setsStateController = GetIt.I.get<SetsStateController>();
  int sets = 1;

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
                  padding: const EdgeInsets.fromLTRB(100, 60, 100, 40),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<SetsStateController, SetsState>(
                          bloc: setsStateController,
                          buildWhen: (oldState, currentState) =>
                            currentState.isSetDefined,
                          builder: (context, state) {

                            if(state.isSetDefined){
                              sets = (state as SetDefined).sets;
                            } else if (state.isSetReset){
                              sets = 1;
                            }

                            return NumberPicker(
                                minValue: 1,
                                maxValue: 10,
                                value: sets,
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
                                  setsStateController.setSets(value);
                                  // setState(() {});
                                }
                            );
                          },
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
