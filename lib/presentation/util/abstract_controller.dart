
import 'package:counting_your_fit_v2/presentation/util/controller_strategy.dart';

abstract class BlocController<T> {
  static BlocController? call(ControllerEnum controllerEnum)
    => ControllerStrategy.controller[controllerEnum];

  T get controller;
}