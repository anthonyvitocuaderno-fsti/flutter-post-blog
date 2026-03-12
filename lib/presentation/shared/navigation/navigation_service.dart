import 'package:flutter/material.dart';

/// Simple navigation service that exposes navigation operations without needing
/// a `BuildContext`.
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get _navigator => navigatorKey.currentState;

  static Future<dynamic>? navigateTo(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator?.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? navigateToReplacement(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? navigateToAndRemoveUntil(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return _navigator?.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  static bool pop<T extends Object?>([T? result]) {
    if (_navigator?.canPop() ?? false) {
      _navigator?.pop(result);
      return true;
    }
    return false;
  }
}
