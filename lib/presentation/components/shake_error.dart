import 'package:counting_your_fit_v2/presentation/util/animation_controller_state.dart';
import 'package:counting_your_fit_v2/presentation/util/sine_curve.dart';
import 'package:flutter/material.dart';

class ShakeError extends StatefulWidget {

  final Widget? child;
  final Duration duration;
  final int? shakeCount;
  final double? shakeOffset;

  const ShakeError({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ShakeError> createState() => ShakeErrorState(duration);
}

class ShakeErrorState extends AnimationControllerState<ShakeError> {

  ShakeErrorState(Duration duration) : super(duration);

  late final Animation<double> _sineAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: SineCurve(
        count: widget.shakeCount!.toDouble()
      )
    )
  );

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake(){
    animationController.forward();
  }

  @override
  void initState(){
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sineAnimation,
      child: widget.child,
      builder: (context, child){
        return Transform.translate(
          offset: Offset(_sineAnimation.value * widget.shakeOffset!, 0),
          child: child,
        );
      }
    );
  }
  
  @override
  void dispose(){
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }
}
