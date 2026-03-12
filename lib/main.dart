import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'core/services/firestore_service.dart';
import 'data/datasource/local/auth_local_datasource_impl.dart';
import 'data/datasource/remote/auth_remote_datasource_impl.dart';
import 'data/repository/auth_repository_impl.dart';
import 'data/repository/post_repository_impl.dart';
import 'service/firebase_auth_service.dart';
import 'domain/use_case/auth/get_current_user_use_case.dart';
import 'domain/use_case/auth/login_use_case.dart';
import 'domain/use_case/auth/logout_use_case.dart';
import 'domain/use_case/auth/observe_auth_state_use_case.dart';
import 'domain/use_case/auth/register_use_case.dart';
import 'domain/use_case/post/fetch_posts_use_case.dart';
import 'presentation/auth/login/login_bloc.dart';
import 'presentation/auth/register/register_bloc.dart';
import 'presentation/dashboard/dashboard_bloc.dart';
import 'presentation/dashboard/dashboard_event.dart';
import 'presentation/post/list/post_list_bloc.dart';
import 'presentation/splash/splash_bloc.dart';
import 'presentation/shared/navigation/app_router.dart';
import 'presentation/shared/navigation/navigation_service.dart';
import 'presentation/shared/navigation/route_paths.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirestoreService.instance;
  final firebaseAuthService = FirebaseAuthService();

  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    firestore: firestore,
    authService: firebaseAuthService,
  );
  final authLocalDataSource = AuthLocalDataSourceImpl();
  final authRepository = AuthRepositoryImpl(
    localDataSource: authLocalDataSource,
    remoteDataSource: authRemoteDataSource,
  );

  final postRepository = PostRepositoryImpl();

  runApp(MainApp(
    authRepository: authRepository,
    postRepository: postRepository,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.authRepository, required this.postRepository});

  final AuthRepositoryImpl authRepository;
  final PostRepositoryImpl postRepository;

  @override
  Widget build(BuildContext context) {
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository: authRepository);
    final observeAuthStateUseCase = ObserveAuthStateUseCase(authRepository: authRepository);
    final fetchPostsUseCase = FetchPostsUseCase(postRepository);

    return MaterialApp(
      title: 'Flutter Post Blog',
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: RoutePaths.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        // Provide blocs that are used across multiple routes here.
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => SplashBloc(
                getCurrentUserUseCase: getCurrentUserUseCase
              ),
            ),
            BlocProvider(
              create: (_) => LoginBloc(loginUseCase: loginUseCase),
            ),
            BlocProvider(
              create: (_) => RegisterBloc(registerUseCase: registerUseCase),
            ),
            BlocProvider(
              create: (_) => DashboardBloc(
                getCurrentUserUseCase: getCurrentUserUseCase,
                logoutUseCase: logoutUseCase,
              )..add(const DashboardStarted()),
            ),
            BlocProvider(
              create: (_) => PostListBloc(fetchPostsUseCase: fetchPostsUseCase),
            ),
          ],
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
