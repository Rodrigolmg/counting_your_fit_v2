part of util;

class CustomIntroPageViewScrollPhysics extends ScrollPhysics {
  CustomIntroPageViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  bool _isGoingRight = false;

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomIntroPageViewScrollPhysics(parent: ancestor);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    _isGoingRight = offset.sign > 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
                'The proposed new position, $value, is exactly equal to the current position of the '
                'given ${position.runtimeType}, ${position.pixels}.\n'
                'The applyBoundaryConditions method should only be called when the value is '
                'going to actually change the pixels, otherwise it is redundant.\n'
                'The physics object in question was:\n'
                '  $this\n'
                'The position object in question was:\n'
                '  $position\n');
      }
      return true;
    }());

    if (value > position.pixels && position.pixels >= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent >= position.pixels && position.pixels > value) {
      // overscroll
      return value - position.pixels;
    }
    if (value > position.minScrollExtent &&
        position.minScrollExtent > position.pixels) {
      // hit top edge

      return value - position.minScrollExtent;
    }

    if (position.pixels > position.maxScrollExtent &&
        position.maxScrollExtent > value) {
      // hit bottom edge
      return value - position.maxScrollExtent;
    }

    if (!_isGoingRight) {
      return value + position.pixels;
    }
    return 0.0;
  }
}