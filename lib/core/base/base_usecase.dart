abstract class BaseUseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// A helper class for use cases that do not require parameters.
class NoParams {
  const NoParams();
}
