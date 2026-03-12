import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/domain/use_case/auth/login_use_case.dart';
import 'package:flutter_post_blog/domain/value_objects/email.dart';
import 'package:flutter_post_blog/domain/value_objects/password.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginState()) {
    on<LoginRequested>(_onLoginRequested);
    on<NavigateToRegisterRequested>(_onNavigateToRegisterRequested);
  }

  Future<void> _onNavigateToRegisterRequested(
    NavigateToRegisterRequested event,
    Emitter<LoginState> emit,
  ) async {
    final newState = state.copyWith(
      navigationRoute: RoutePaths.register,        
      navigationReplace: true,
      navigationPredicate: (_) => false,
    );
    emit(newState);
    emit(newState.copyWith(
      navigationRoute: null,        
      navigationReplace: false,
      navigationRemoveUntil: false,
      navigationPredicate: null,
    ));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
      status: LoginStatus.loading,
      navigationRoute: null,
      navigationArguments: null,
      navigationReplace: null,
      navigationRemoveUntil: null,
      navigationPredicate: null,
      ));

    try {
      await loginUseCase(
        LoginUseCaseParams(
          email: Email(event.email),
          password: Password(event.password),
        ),
      );

      final newState = state.copyWith(
        status: LoginStatus.success,
        navigationRoute: RoutePaths.dashboard,
        navigationReplace: true,
        navigationPredicate: (_) => false,
      );
      emit(newState);
      emit(newState.copyWith(
        status: LoginStatus.initial,
        navigationRoute: null,        
        navigationReplace: false,
        navigationRemoveUntil: false,
        navigationPredicate: null,
      ));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }
}
