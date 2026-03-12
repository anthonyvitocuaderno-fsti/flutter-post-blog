import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/repository/auth_repository.dart';

class LogoutUseCase extends BaseUseCase<void, NoParams> {
  final AuthRepository authRepository;

  LogoutUseCase(this.authRepository);

  @override
  Future<void> call(NoParams params) {
    return authRepository.logout();
  }
}
