import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/util/hero/hero_tag.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';

class SetTimerValuesPopUp extends StatefulWidget {

  final bool? isTime;

  const SetTimerValuesPopUp({
    super.key,
    this.isTime = true
  });

  @override
  State<SetTimerValuesPopUp> createState() => _SetTimerValuesPopUpState();
}

class _SetTimerValuesPopUpState extends State<SetTimerValuesPopUp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Hero(
          tag: heroPopUp,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: ColorApp.mainColor
              )
            ),
            color: ColorApp.backgroundColor,
            elevation: 2,
            child: Stack(
              children: [
                widget.isTime! ? Padding(
                  padding: const EdgeInsets.all(65.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Colors.black26,
                                  width: .3,
                                ),
                                right: BorderSide(
                                  color: Colors.black26,
                                  width: .3,
                                ),
                              )
                          ),
                          child: NumberPicker(
                              minValue: 0,
                              maxValue: 5,
                              value: 0,
                              infiniteLoop: true,
                              itemHeight: 35,
                              onChanged: (value){

                              }
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.black26,
                                  width: .3,
                                ),
                              )
                          ),
                          child: NumberPicker(
                              minValue: 0,
                              maxValue: 59,
                              value: 0,
                              infiniteLoop: true,
                              itemHeight: 35,
                              onChanged: (value){

                              }
                          ),
                        ),

                      ],
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.all(75.0),
                  child: NumberPicker(
                      minValue: 1,
                      maxValue: 5,
                      value: 1,
                      infiniteLoop: true,
                      itemHeight: 35,
                      onChanged: (value){

                      }
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
                      color: ColorApp.mainColor,
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
