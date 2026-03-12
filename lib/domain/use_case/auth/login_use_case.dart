import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/repository/auth_repository.dart';
import 'package:flutter_post_blog/domain/value_objects/email.dart';
import 'package:flutter_post_blog/domain/value_objects/password.dart';

class LoginUseCase extends BaseUseCase<UserModel, LoginUseCaseParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<UserModel> call(LoginUseCaseParams params) {
    return repository.login(
      email: params.email.value,
      password: params.password.value,
    );
  }
}

class LoginUseCaseParams {
  final Email email;
  final Password password;

  LoginUseCaseParams({required this.email, required this.password});
}
