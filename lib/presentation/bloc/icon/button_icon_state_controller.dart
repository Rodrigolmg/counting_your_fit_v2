part of presentation;

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