import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_post_blog/domain/model/user_model.dart';

enum SplashStatus { initial, loading, authenticated, unauthenticated, failure }

class SplashState extends Equatable {
  /// Current progress/status of the splash screen flow.
  final SplashStatus status;

  /// Authenticated user (if any). `null` when unauthenticated.
  final UserModel? user;

  /// Error message to show when status == failure.
  final String? errorMessage;

  /// Optional one-shot navigation instruction.
  ///
  /// When non-null, UI should navigate to this route once and then clear it.
  final String? navigationRoute;

  /// Optional arguments to pass to the destination route.
  final Object? navigationArguments;

  /// When true, the UI should perform a pushReplacement instead of push.
  final bool navigationReplace;

  /// When true, the UI should perform a pushNamedAndRemoveUntil.
  final bool navigationRemoveUntil;

  /// Predicate used by pushNamedAndRemoveUntil.
  final bool Function(Route<dynamic>)? navigationPredicate;

  const SplashState({
    required this.status,
    this.user,
    this.errorMessage,
    this.navigationRoute,
    this.navigationArguments,
    this.navigationReplace = false,
    this.navigationRemoveUntil = false,
    this.navigationPredicate,
  });

  const SplashState.initial() : this(status: SplashStatus.initial);
  const SplashState.loading() : this(status: SplashStatus.loading);
  const SplashState.authenticated(UserModel user)
      : this(status: SplashStatus.authenticated, user: user);
  const SplashState.unauthenticated() : this(status: SplashStatus.unauthenticated);
  const SplashState.failure(String error)
      : this(status: SplashStatus.failure, errorMessage: error);

  SplashState copyWith({
    SplashStatus? status,
    UserModel? user,
    String? errorMessage,
    String? navigationRoute,
    Object? navigationArguments,
    bool? navigationReplace,
    bool? navigationRemoveUntil,
    bool Function(Route<dynamic>)? navigationPredicate,
  }) {
    return SplashState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationRoute: navigationRoute ?? this.navigationRoute,
      navigationArguments: navigationArguments ?? this.navigationArguments,
      navigationReplace: navigationReplace ?? this.navigationReplace,
      navigationRemoveUntil: navigationRemoveUntil ?? this.navigationRemoveUntil,
      navigationPredicate: navigationPredicate ?? this.navigationPredicate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        navigationRoute,
        navigationArguments,
        navigationReplace,
        navigationRemoveUntil,
        navigationPredicate,
      ];
}
