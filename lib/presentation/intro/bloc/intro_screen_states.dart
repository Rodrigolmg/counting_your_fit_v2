part of presentation;

abstract class IntroScreenStates{}

extension IntroScreenStatesX on IntroScreenStates{
  bool get isInitial => this is InitialState;
  bool get isLastPage => this is LastPage;
  bool get isNotificationPage => this is NotificationPage;
  bool get isNextPage => this is NextPage;
}

class InitialState implements IntroScreenStates{
  const InitialState();
}

class LastPage implements IntroScreenStates{

  const LastPage();
}

class NotificationPage implements IntroScreenStates{
  const NotificationPage();
}

class NextPage implements IntroScreenStates {
  final int? page;

  const NextPage({
    this.page,
  });
}