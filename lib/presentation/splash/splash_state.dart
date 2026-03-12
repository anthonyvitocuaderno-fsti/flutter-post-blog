import 'package:equatable/equatable.dart';

import 'package:flutter_post_blog/domain/model/user_model.dart';

import '../shared/navigation/navigation_params.dart';

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
  /// When non-null, UI should navigate once and then clear it.
  final NavigationParams? navigationParams;

  const SplashState({
    required this.status,
    this.user,
    this.errorMessage,
    this.navigationParams,
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
    NavigationParams? navigationParams,
  }) {
    return SplashState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationParams: navigationParams,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, navigationParams];
}
