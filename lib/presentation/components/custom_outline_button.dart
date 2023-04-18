import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/util/hero/custom_rect_tween.dart';
import 'package:counting_your_fit_v2/presentation/util/hero/hero_router.dart';
import 'package:counting_your_fit_v2/presentation/util/hero/hero_tag.dart';
import 'package:counting_your_fit_v2/presentation/util/hero/set_timer_values_popup.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatefulWidget {

  final bool? isTime;

  const CustomOutlineButton({
    super.key,
    this.isTime = true
  });

  @override
  State<CustomOutlineButton> createState() => _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends State<CustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      width: 150,
      child: Hero(
        tag: heroPopUp,
        createRectTween: (begin, end){
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: OutlinedButton(
          onPressed: (){
            Navigator.of(context).push(
                HeroRoute(
                  builder: (context) {
                    return SetTimerValuesPopUp(
                      isTime: true,
                    );
                  }
                )
            );
          },
          child: Text(
            '00:00',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: ColorApp.mainColor
            ),
          ),
        ),
      ),
    );
  }
}
