import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/custom_rect_tween.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_exercise_one_value.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_router.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_exercise_two_values.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/setting/state/timer_settings_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HeroButton extends StatefulWidget {

  final String? buttonLabel;
  final String? heroTag;
  final bool hasError;

  const HeroButton({
    super.key,
    required this.buttonLabel,
    required this.heroTag,
    this.hasError = false
  });


  @override
  State<HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<HeroButton> {

  final timeScreenController = GetIt.I.get<TimerSettingsStateController>();


  @override
  Widget build(BuildContext context) {

    bool isOneValuePicker = widget.heroTag! == heroSetsPopUp
    || widget.heroTag! == heroStepQuantityPopUp;

    return SizedBox(
      height: 47,
      width: 150,
      child: Hero(
        tag: widget.heroTag!,
        createRectTween: (begin, end){
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: widget.hasError ? ColorApp.errorColor : ColorApp.mainColor,
            elevation: 2,
          ),
          onPressed: (){
            Navigator.of(context).push(
              HeroRoute(
                builder: (context) {
                  return isOneValuePicker ? HeroExerciseOneValue(
                    heroTag: widget.heroTag!,
                  ) : HeroExerciseTwoValues(
                    heroTag: widget.heroTag!,
                  );
                }
              )
            );
          },
          child: Text(
            widget.buttonLabel!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ColorApp.backgroundColor
            ),
          ),
        ),
      ),
    );
  }
}
