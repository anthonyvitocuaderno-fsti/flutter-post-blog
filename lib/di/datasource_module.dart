import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../core/services/firestore_service.dart';
import '../data/datasource/local/auth_local_datasource.dart';
import '../data/datasource/local/auth_local_datasource_impl.dart';
import '../data/datasource/remote/auth_remote_datasource.dart';
import '../data/datasource/remote/auth_remote_datasource_impl.dart';
import '../data/datasource/remote/post_remote_datasource.dart';
import '../data/datasource/remote/post_remote_datasource_impl.dart';
import '../core/services/firebase_auth_service.dart';

void setupDataSources() {
  final getIt = GetIt.instance;

  // Services
  getIt.registerLazySingleton(() => FirestoreService.instance);
  getIt.registerLazySingleton(() => FirebaseAuthService());

  // DataSources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      authService: getIt<FirebaseAuthService>(),
    ),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  getIt.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(authService: getIt<FirebaseAuthService>()),
  );
}