import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? errorMessage;
  final String? navigationRoute;
  final Object? navigationArguments;
  final bool navigationReplace;
  final bool navigationRemoveUntil;
  final bool Function(Route<dynamic>)? navigationPredicate;
  // TODO encapsulate all nav params
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.navigationRoute,
    this.navigationArguments,
    this.navigationReplace = false,
    this.navigationRemoveUntil = false,
    this.navigationPredicate,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    String? navigationRoute,
    Object? navigationArguments,
    bool? navigationReplace,
    bool? navigationRemoveUntil,
    bool Function(Route<dynamic>)? navigationPredicate,
  }) {
    return RegisterState(
      status: status ?? this.status,
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
        errorMessage,
        navigationRoute,
        navigationArguments,
        navigationReplace,
        navigationRemoveUntil,
        navigationPredicate,
      ];
}
