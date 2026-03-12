import 'package:equatable/equatable.dart';

import '../../shared/navigation/navigation_params.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final NavigationParams? navigationParams;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.navigationParams,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    NavigationParams? navigationParams,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationParams: navigationParams,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, navigationParams];
}
