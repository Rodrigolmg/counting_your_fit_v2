part of presentation;

abstract class SettingsDefinitionStates{}

extension SettingsDefinitionStateX on SettingsDefinitionStates{
  bool get isFirstPageClicked => this is FirstPageClicked;
  bool get isSecondPageClicked => this is SecondPageClicked;
  bool get isFirstPageScrolled => this is FirstPageScrolled;
  bool get isSecondPageScrolled => this is SecondPageScrolled;
  bool get isHelpCalled => this is HelpCalled;
  bool get isHelpClosed => this is HelpClosed;
  bool get isInitial => this is SettingInitialState;
}

class SettingInitialState implements SettingsDefinitionStates{
  const SettingInitialState();
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

class HelpCalled implements SettingsDefinitionStates{
  final double pageSize;

  const HelpCalled({
    required this.pageSize
  });
}

class HelpClosed implements SettingsDefinitionStates{
  final double pageSize;

  const HelpClosed({
    required this.pageSize
  });
}


