import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/utils/app_bloc_observer.dart';
import 'di/di_setup.dart';
import 'firebase_options.dart';
import 'domain/use_case/auth/get_current_user_use_case.dart';
import 'domain/use_case/auth/login_use_case.dart';
import 'domain/use_case/auth/logout_use_case.dart';
import 'domain/use_case/auth/register_use_case.dart';
import 'domain/use_case/post/create_post_use_case.dart';
import 'domain/use_case/post/delete_post_use_case.dart';
import 'domain/use_case/post/fetch_posts_use_case.dart';
import 'domain/use_case/post/update_post_use_case.dart';
import 'domain/use_case/post/watch_posts_use_case.dart';
import 'presentation/auth/login/login_bloc.dart';
import 'presentation/auth/register/register_bloc.dart';
import 'presentation/dashboard/dashboard_bloc.dart';
import 'presentation/dashboard/dashboard_event.dart';
import 'presentation/post/form/post_form_bloc.dart';
import 'presentation/post/list/post_list_bloc.dart';
import 'presentation/splash/splash_bloc.dart';
import 'presentation/shared/navigation/app_router.dart';
import 'presentation/shared/navigation/navigation_service.dart';
import 'presentation/shared/navigation/route_paths.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup dependency injection
  setupDI();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
                getCurrentUserUseCase: GetIt.instance.get<GetCurrentUserUseCase>(),
              ),
            ),
            BlocProvider(
              create: (_) => LoginBloc(
                loginUseCase: GetIt.instance.get<LoginUseCase>(),
              ),
            ),
            BlocProvider(
              create: (_) => RegisterBloc(
                registerUseCase: GetIt.instance.get<RegisterUseCase>(),
              ),
            ),
            BlocProvider(
              create: (_) => DashboardBloc(
                getCurrentUserUseCase: GetIt.instance.get<GetCurrentUserUseCase>(),
                logoutUseCase: GetIt.instance.get<LogoutUseCase>(),
              )..add(const DashboardStarted()),
            ),
            BlocProvider(
              create: (_) => PostListBloc(
                fetchPostsUseCase: GetIt.instance.get<FetchPostsUseCase>(),
                watchPostsUseCase: GetIt.instance.get<WatchPostsUseCase>(),
              ),
            ),
            BlocProvider(
              create: (_) => PostFormBloc(
                createPostUseCase: GetIt.instance.get<CreatePostUseCase>(),
                updatePostUseCase: GetIt.instance.get<UpdatePostUseCase>(),
                deletePostUseCase: GetIt.instance.get<DeletePostUseCase>(),
              ),
            ),
          ],
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
