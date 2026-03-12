import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/repository/auth_repository.dart';

class GetCurrentUserUseCase extends BaseUseCase<UserModel?, NoParams> {
  final AuthRepository authRepository;

  GetCurrentUserUseCase({required this.authRepository});

  @override
  Future<UserModel?> call(NoParams params) {
    return authRepository.getCurrentUser();
  }
}
