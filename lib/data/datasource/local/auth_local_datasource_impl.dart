import 'auth_local_datasource.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> cacheToken(String token) async {
    // TODO: Persist token locally (e.g., secure storage).
  }

  @override
  Future<String?> getCachedToken() async {
    // TODO: Retrieve token from local storage.
    return null;
  }
}
