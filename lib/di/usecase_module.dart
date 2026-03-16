import 'package:flutter_post_blog/domain/use_case/post/delete_image_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/post/upload_image_use_case.dart';
import 'package:get_it/get_it.dart';

import '../domain/repository/auth_repository.dart';
import '../domain/repository/post_repository.dart';
import '../domain/use_case/auth/get_current_user_use_case.dart';
import '../domain/use_case/auth/login_use_case.dart';
import '../domain/use_case/auth/logout_use_case.dart';
import '../domain/use_case/auth/register_use_case.dart';
import '../domain/use_case/post/create_post_use_case.dart';
import '../domain/use_case/post/delete_post_use_case.dart';
import '../domain/use_case/post/fetch_posts_use_case.dart';
import '../domain/use_case/post/update_post_use_case.dart';
import '../domain/use_case/post/watch_posts_use_case.dart';

void setupUseCases() {
  final getIt = GetIt.instance;

  // Auth Use Cases
  getIt.registerLazySingleton(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCurrentUserUseCase(authRepository: getIt<AuthRepository>()),
  );

  // Post Use Cases
  getIt.registerLazySingleton(
    () => FetchPostsUseCase(getIt<PostRepository>()),
  );
  getIt.registerLazySingleton(
    () => CreatePostUseCase(getIt<PostRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdatePostUseCase(getIt<PostRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeletePostUseCase(getIt<PostRepository>()),
  );
  getIt.registerLazySingleton(
    () => WatchPostsUseCase(getIt<PostRepository>()),
  );
  
  getIt.registerLazySingleton(
    () => UploadImageUseCase(getIt<PostRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteImageUseCase(getIt<PostRepository>()),
  );
}