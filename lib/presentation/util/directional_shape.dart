
import 'package:flutter/cupertino.dart';

class DirectionalShape extends ShapeBorder {

  final bool? isToRightSide;

  const DirectionalShape({
    this.isToRightSide = true,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.only(bottom: 20);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    if(isToRightSide!){
      rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - const Offset(20, 0));
      return Path()
        ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
        ..moveTo(rect.centerRight.dx - 10, rect.bottomCenter.dy)
        ..relativeLineTo(10, 20)
        ..relativeLineTo(20, -20)
        ..close();
    }

    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(20, 00));
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
      ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
      ..relativeLineTo(10, 20)
      ..relativeLineTo(20, -20)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}