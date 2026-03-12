import 'package:flutter/material.dart';

import 'package:flutter_post_blog/presentation/auth/login/login_screen.dart';
import 'package:flutter_post_blog/presentation/auth/register/register_screen.dart';
import 'package:flutter_post_blog/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter_post_blog/presentation/post/detail/post_detail_screen.dart';
import 'package:flutter_post_blog/presentation/splash/splash_screen.dart';

import 'route_arguments.dart';
import 'route_paths.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePaths.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RoutePaths.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RoutePaths.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RoutePaths.postDetail:
        final args = settings.arguments as PostDetailRouteArgs?;
        final post = args?.post;
        if (post == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Post not found')), // TODO error 404 screen
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => PostDetailScreen(post: post));
      default:
        return null;
    }
  }
}
