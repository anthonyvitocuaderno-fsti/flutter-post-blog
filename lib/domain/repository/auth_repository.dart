import 'package:flutter_post_blog/core/base/base_repository.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';

abstract class AuthRepository extends BaseRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  /// Returns the currently authenticated user, or `null` if not signed in.
  Future<UserModel?> getCurrentUser();

  /// Emits auth state changes.
  Stream<UserModel?> authStateChanges();

  Future<void> logout();
}
