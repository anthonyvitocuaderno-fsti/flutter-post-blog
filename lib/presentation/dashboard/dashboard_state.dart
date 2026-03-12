import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_post_blog/domain/model/user_model.dart';

enum DashboardStatus { initial, loading, loaded, loggedOut, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final UserModel? user;
  final String? errorMessage;
  final String? navigationRoute;
  final Object? navigationArguments;
  final bool navigationReplace;
  final bool navigationRemoveUntil;
  final bool Function(Route<dynamic>)? navigationPredicate;

  const DashboardState({
    required this.status,
    this.user,
    this.errorMessage,
    this.navigationRoute,
    this.navigationArguments,
    this.navigationReplace = false,
    this.navigationRemoveUntil = false,
    this.navigationPredicate,
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
    String? navigationRoute,
    Object? navigationArguments,
    bool? navigationReplace,
    bool? navigationRemoveUntil,
    bool Function(Route<dynamic>)? navigationPredicate,
  }) {
    return DashboardState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationRoute: navigationRoute,
      navigationArguments: navigationArguments,
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
