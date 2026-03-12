import 'package:equatable/equatable.dart';

import '../../shared/navigation/navigation_params.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? errorMessage;
  final NavigationParams? navigationParams;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.navigationParams,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    NavigationParams? navigationParams,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationParams: navigationParams,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, navigationParams];
}
