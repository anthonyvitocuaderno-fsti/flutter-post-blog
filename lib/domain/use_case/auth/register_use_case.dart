import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/repository/auth_repository.dart';
import 'package:flutter_post_blog/domain/value_objects/email.dart';
import 'package:flutter_post_blog/domain/value_objects/password.dart';

class RegisterUseCase extends BaseUseCase<UserModel, RegisterUseCaseParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<UserModel> call(RegisterUseCaseParams params) {
    return repository.register(
      name: params.name,
      email: params.email.value,
      password: params.password.value,
    );
  }
}

class RegisterUseCaseParams {
  final String name;
  final Email email;
  final Password password;

  RegisterUseCaseParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
