import 'package:counting_your_fit_v2/color_app.dart';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

class DirectionalButton extends StatefulWidget {

  final bool? isToRight;
  final IconData icon;
  final VoidCallback onTap;

  const DirectionalButton({
    super.key,
    this.isToRight = true,
    required this.icon,
    required this.onTap
  });

  @override
  State<DirectionalButton> createState() => _DirectionalButtonState();
}

class _DirectionalButtonState extends State<DirectionalButton> {

  late ShapeDecoration shapeDecoration;

  @override
  void initState() {
    super.initState();
    shapeDecoration = ShapeDecoration(
      shape: BubbleShapeBorder(
        side: widget.isToRight! ? ShapeSide.right : ShapeSide.left,
      ),
      color: ColorApp.mainColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: shapeDecoration,
        height: 55,
        width: 45,
        child: Padding(
          padding: widget.isToRight! ?
            const EdgeInsets.only(right: 9.0) :
          const EdgeInsets.only(left: 7.0),
          child: Icon(
            widget.icon,
            color: ColorApp.backgroundColor,
          ),
        ),
      ),
    );
  }


}
