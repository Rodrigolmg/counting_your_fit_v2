import 'package:flutter/material.dart';

class HeroRoute<T> extends PageRoute<T> {

  final WidgetBuilder? _builder;

  HeroRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullScreenDialog = false,
  }) : _builder = builder,
    super(settings: settings, fullscreenDialog: fullScreenDialog);


  @override
  bool get opaque => false;


  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => '';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _builder!(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) => child;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);
}