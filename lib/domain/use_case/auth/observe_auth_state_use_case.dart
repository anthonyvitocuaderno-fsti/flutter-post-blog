import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/repository/auth_repository.dart';

/// Exposes auth state changes so the app can react to sign-in / sign-out updates.
class ObserveAuthStateUseCase {
  final AuthRepository authRepository;

  ObserveAuthStateUseCase({required this.authRepository});

  Stream<UserModel?> call() {
    return authRepository.authStateChanges();
  }
}
