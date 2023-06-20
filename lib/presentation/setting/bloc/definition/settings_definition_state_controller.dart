import 'package:bloc/bloc.dart';
import 'package:counting_your_fit_v2/presentation/setting/bloc/definition/settings_definition_states.dart';


class SettingsDefinitionStateController extends Cubit<SettingsDefinitionStates> {

  SettingsDefinitionStateController(
      [SettingsDefinitionStates state = const InitialState()]
  ) : super(state);

  void changePageOnClick(int index){
    emit(index == 0 ? const FirstPageClicked() : const SecondPageClicked());
  }

  void changePageOnScroll(int index){
    emit(index == 0 ? const FirstPageScrolled() : const SecondPageScrolled());
  }

  void callHelp(){
    emit(const HelpCalled(pageSize: 1));
  }

  void closeHelp(){
    emit(const HelpClosed(pageSize: 0));
  }
}