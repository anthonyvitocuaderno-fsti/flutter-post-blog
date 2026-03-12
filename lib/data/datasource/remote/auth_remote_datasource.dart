import '../../entity/remote/user_entity_remote.dart';

abstract class AuthRemoteDataSource {
  Future<String> signIn(String email, String password);

  /// Registers a new user in Firestore.
  ///
  /// Returns the newly created user ID.
  Future<String> register({
    required String name,
    required String email,
    required String password,
  });

  /// Signs the current user out.
  Future<void> signOut();

  /// Returns the currently signed-in user, or `null` if signed out.
  Future<UserEntityRemote?> getCurrentUser();

  /// Emits the authentication state changes as a stream.
  Stream<UserEntityRemote?> authStateChanges();

  Future<UserEntityRemote?> getUserByEmail(String email);
}
