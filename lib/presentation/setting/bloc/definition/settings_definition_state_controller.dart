part of presentation;

class SettingsDefinitionStateController extends Cubit<SettingsDefinitionStates> {

  SettingsDefinitionStateController(
      [SettingsDefinitionStates state = const SettingInitialState()]
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