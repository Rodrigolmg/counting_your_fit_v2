part of presentation;

class IntroScreenStateController extends Cubit<IntroScreenStates>{

  IntroScreenStateController([
    IntroScreenStates initialState = const InitialState()
  ]) : super(initialState);

  void nextPage(int page){
    if(page == 5){
      emit(const LastPage());
    } else if (page == 4){
      emit(const NotificationPage());
    } else {
      emit(NextPage(page: page));
    }
  }

}