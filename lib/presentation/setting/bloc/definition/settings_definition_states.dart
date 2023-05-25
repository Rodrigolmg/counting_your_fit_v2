abstract class SettingsDefinitionStates{}

extension SettingsDefinitionStateX on SettingsDefinitionStates{
  bool get isFirstPageClicked => this is FirstPageClicked;
  bool get isSecondPageClicked => this is SecondPageClicked;
  bool get isFirstPageScrolled => this is FirstPageScrolled;
  bool get isSecondPageScrolled => this is SecondPageScrolled;
}

class InitialState implements SettingsDefinitionStates{
  const InitialState();
}

class FirstPageClicked implements SettingsDefinitionStates{
  const FirstPageClicked();
}
class SecondPageClicked implements SettingsDefinitionStates{
  const SecondPageClicked();
}

class FirstPageScrolled implements SettingsDefinitionStates{
  const FirstPageScrolled();
}
class SecondPageScrolled implements SettingsDefinitionStates{
  const SecondPageScrolled();
}
