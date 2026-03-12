import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'navigation_params.dart';

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
    developer.log('NavigationService.navigateTo: $routeName args=$arguments');
    return _navigator?.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? navigateToReplacement(
    String routeName, {
    Object? arguments,
  }) {
    developer.log('NavigationService.navigateToReplacement: $routeName args=$arguments');
    return _navigator?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic>? navigateToAndRemoveUntil(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    developer.log('NavigationService.navigateToAndRemoveUntil: $routeName args=$arguments');
    return _navigator?.pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  static bool pop<T extends Object?>([T? result]) {
    developer.log('NavigationService.pop: result=$result');
    if (_navigator?.canPop() ?? false) {
      _navigator?.pop(result);
      return true;
    }
    return false;
  }

  /// Navigate based on [NavigationParams].
  ///
  /// This is intended to be used by UI layers that react to bloc states which
  /// carry navigation instructions.
  static Future<dynamic>? navigateWithParams(
    NavigationParams params, {
    String? source,
  }) {
    developer.log('NavigationService.navigateWithParams: source=$source type=${params.type} route=${params.route} args=${params.arguments}');

    switch (params.type) {
      case NavigationType.push:
        return navigateTo(params.route, arguments: params.arguments);
      case NavigationType.replace:
        return navigateToReplacement(params.route, arguments: params.arguments);
      case NavigationType.removeUntil:
        final predicate = params.predicate;
        if (predicate == null) {
          developer.log('NavigationService.navigateWithParams: missing predicate for removeUntil', level: 900);
          return null;
        }
        return navigateToAndRemoveUntil(params.route, predicate, arguments: params.arguments);
    }
  }

  /// Runs navigation if [params] is not null.
  static Future<dynamic>? navigateIfNeeded(
    NavigationParams? params, {
    String? source,
  }) {
    if (params == null) return null;
    return navigateWithParams(params, source: source);
  }
}
