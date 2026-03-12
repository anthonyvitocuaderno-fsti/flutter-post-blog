import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Encapsulates a navigation request into a single object.
///
/// Use this when you want to represent a one-off navigation action inside a
/// bloc/state, so the UI can react and perform the actual navigation.
class NavigationParams extends Equatable {
  /// The route name to navigate to.
  final String route;

  /// Optional arguments to pass to the route.
  final Object? arguments;

  /// How to perform the navigation.
  final NavigationType type;

  /// If [type] is [NavigationType.removeUntil], this predicate is used to
  /// determine which routes to keep.
  final bool Function(Route<dynamic>)? predicate;

  const NavigationParams.push(
    this.route, {
    this.arguments,
  })  : type = NavigationType.push,
        predicate = null;

  const NavigationParams.replace(
    this.route, {
    this.arguments,
  })  : type = NavigationType.replace,
        predicate = null;

  const NavigationParams.removeUntil(
    this.route,
    this.predicate, {
    this.arguments,
  })  : type = NavigationType.removeUntil;

  @override
  List<Object?> get props => [route, arguments, type, predicate];
}

enum NavigationType {
  push,
  replace,
  removeUntil,
}
