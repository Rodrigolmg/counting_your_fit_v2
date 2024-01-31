part of util;

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {

  final Duration animationDuration;

  AnimationControllerState(
    this.animationDuration,
  );

  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}