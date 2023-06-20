import 'package:counting_your_fit_v2/presentation/timer/individual/bloc/icon/button_icon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonIconStateController extends Cubit<ButtonIconState> {

  ButtonIconStateController([
    ButtonIconState initialState = const PlayIcon()
  ]) : super(initialState);

  void isPlayIcon() {
    emit(const PlayIcon());
  }

  void isRestingIcon() {
    emit(const RestingIcon());
  }

  void isExecutingIcon() {
    emit(const ExecutingIcon());
  }
}