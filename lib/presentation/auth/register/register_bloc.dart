import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/domain/use_case/auth/register_use_case.dart';
import 'package:flutter_post_blog/domain/value_objects/email.dart';
import 'package:flutter_post_blog/domain/value_objects/password.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_params.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(const RegisterState()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<NavigateToLoginRequested>(_onNavigateToLoginRequested);
  }

  Future<void> _onNavigateToLoginRequested(
    NavigateToLoginRequested event,
    Emitter<RegisterState> emit,
  ) async {
    final newState = state.copyWith(
      navigationParams: const NavigationParams.replace(RoutePaths.login),
    );
    emit(newState);
    emit(newState.copyWith(navigationParams: null));
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(
      status: RegisterStatus.loading,
      navigationParams: null,
    ));

    try {
      await registerUseCase(
        RegisterUseCaseParams(
          name: event.name,
          email: Email(event.email),
          password: Password(event.password),
        ),
      );

      final newState = state.copyWith(
        status: RegisterStatus.success,
        navigationParams: const NavigationParams.replace(RoutePaths.login),
      );
      emit(newState);
      emit(newState.copyWith(status: RegisterStatus.initial, navigationParams: null));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }
}
