part of util;

abstract class AbstractPunctuation {
  String getPunctuation();
}

class InterrogativePunctuation implements AbstractPunctuation {

  @override
  String getPunctuation() => '?';

}

class EsInterrogativePunctuation implements AbstractPunctuation {

  @override
  String getPunctuation() => '¿';

}

class EsExclamatoryPunctuation implements AbstractPunctuation {

  @override
  String getPunctuation() => '¡';

}

class ExclamatoryPunctuation implements AbstractPunctuation {

  @override
  String getPunctuation() => '!';

}

class FullStopPunctuation implements AbstractPunctuation {

  @override
  String getPunctuation() => '.';

}

class ColonPunctuation implements AbstractPunctuation {

  @override
  String getPunctuation() => ':';

}

class NoPunctuation implements AbstractPunctuation {

  @override
  String getPunctuation() => '';

}


