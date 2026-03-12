import '../../core/base/base_repository.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../datasource/remote/auth_remote_datasource.dart';
import '../../domain/model/user_model.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final uid = await remoteDataSource.signIn(email, password);
    await localDataSource.cacheToken(uid);

    final remoteUser = await remoteDataSource.getCurrentUser();
    if (remoteUser == null) {
      // Fallback: use email as name when user doc doesn't contain a name.
      final name = email.contains('@') ? email.split('@').first : email;
      return UserModel(id: uid, name: name, email: email);
    }

    return UserModel(
      id: remoteUser.id,
      name: remoteUser.name,
      email: remoteUser.email,
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final uid = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );

    await localDataSource.cacheToken(uid);
    return UserModel(id: uid, name: name, email: email);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final remoteUser = await remoteDataSource.getCurrentUser();
    if (remoteUser == null) return null;

    return UserModel(
      id: remoteUser.id,
      name: remoteUser.name,
      email: remoteUser.email,
    );
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return remoteDataSource.authStateChanges().map((remoteUser) {
      if (remoteUser == null) return null;
      return UserModel(
        id: remoteUser.id,
        name: remoteUser.name,
        email: remoteUser.email,
      );
    });
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.signOut();
    await localDataSource.cacheToken('');
  }
}
