import 'package:get_it/get_it.dart';

import '../data/datasource/local/auth_local_datasource.dart';
import '../data/datasource/remote/auth_remote_datasource.dart';
import '../data/datasource/remote/post_remote_datasource.dart';
import '../data/repository/auth_repository_impl.dart';
import '../data/repository/post_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/post_repository.dart';

void setupRepositories() {
  final getIt = GetIt.instance;

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      remoteDataSource: getIt<PostRemoteDataSource>(),
    ),
  );
}