part of domain;

abstract class EditSelectedSetUseCase{
  Future<void> call(int selectedSet);
}

class EditSelectedSetUseCaseImpl implements EditSelectedSetUseCase {

  @override
  Future<void> call(int selectedSet) {
    throw UnimplementedError();
  }

}