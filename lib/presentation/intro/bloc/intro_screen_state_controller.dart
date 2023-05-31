

import 'package:counting_your_fit_v2/presentation/intro/bloc/intro_screen_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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