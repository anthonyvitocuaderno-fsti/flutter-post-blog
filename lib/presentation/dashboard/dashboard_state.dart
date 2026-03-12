import 'package:equatable/equatable.dart';

import 'package:flutter_post_blog/domain/model/user_model.dart';

import '../shared/navigation/navigation_params.dart';

enum DashboardStatus { initial, loading, loaded, loggedOut, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final UserModel? user;
  final String? errorMessage;
  final NavigationParams? navigationParams;

  const DashboardState({
    required this.status,
    this.user,
    this.errorMessage,
    this.navigationParams,
  });

  const DashboardState.initial() : this(status: DashboardStatus.initial);
  const DashboardState.loading() : this(status: DashboardStatus.loading);
  const DashboardState.loaded(UserModel user)
      : this(status: DashboardStatus.loaded, user: user);
  const DashboardState.loggedOut() : this(status: DashboardStatus.loggedOut);
  const DashboardState.failure(String error)
      : this(status: DashboardStatus.failure, errorMessage: error);

  DashboardState copyWith({
    DashboardStatus? status,
    UserModel? user,
    String? errorMessage,
    NavigationParams? navigationParams,
  }) {
    return DashboardState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationParams: navigationParams,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, navigationParams];
}
