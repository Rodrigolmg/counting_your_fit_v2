import 'package:counting_your_fit_v2/color_app.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/custom_rect_tween.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/hero_router.dart';
import 'package:counting_your_fit_v2/presentation/components/hero/variants/hero_variant.dart';
import 'package:flutter/material.dart';

class HeroButton extends StatefulWidget {

  final String? buttonLabel;
  final String? heroTag;
  final bool hasError;
  final HeroVariant variant;

  const HeroButton({
    super.key,
    required this.buttonLabel,
    required this.heroTag,
    required this.variant,
    this.hasError = false,
  });


  @override
  State<HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<HeroButton> {


  String getHeroStepTag(){

    List<String> heroTagSplitted = widget.heroTag!.split('-');

    bool isHeroStepTag = heroTagSplitted.length == 4;

    if(!isHeroStepTag){
      return widget.heroTag!;
    }

    heroTagSplitted.removeAt(3);

    return '${heroTagSplitted[0]}-${heroTagSplitted[1]}-${heroTagSplitted[2]}';

  }

  @override
  Widget build(BuildContext context) {

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
                  return widget.variant(widget.heroTag!);
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
