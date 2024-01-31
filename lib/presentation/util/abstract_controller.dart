part of util;

abstract class BlocController<T> {
  static BlocController? call(ControllerEnum controllerEnum)
    => ControllerStrategy.controller[controllerEnum];

  T get controller;
}