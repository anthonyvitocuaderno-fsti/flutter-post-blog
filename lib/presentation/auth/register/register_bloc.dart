import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/domain/use_case/auth/register_use_case.dart';
import 'package:flutter_post_blog/domain/value_objects/email.dart';
import 'package:flutter_post_blog/domain/value_objects/password.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({required this.registerUseCase}) : super(const RegisterState()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

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
        navigationRoute: RoutePaths.login,
        navigationReplace: true,
      );
      emit(newState);
      emit(newState.copyWith(navigationRoute: null, navigationReplace: false));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }
}
