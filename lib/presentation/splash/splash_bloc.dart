import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/use_case/auth/get_current_user_use_case.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_params.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  SplashBloc({
    required this.getCurrentUserUseCase,
  }) : super(const SplashState.initial()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(SplashStarted event, Emitter<SplashState> emit) async {
    emit(const SplashState.loading());

    try {
      final user = await getCurrentUserUseCase(const NoParams());
      if (user != null) {
        // Emit state with a one-shot navigation request.
        // UI reads this and navigates once, then navigationParams is cleared.
        final newState = SplashState.authenticated(user).copyWith(
          navigationParams: NavigationParams.removeUntil(
            RoutePaths.dashboard,
            (_) => false,
          ),
        );
        emit(newState);
      } else {
        final newState = const SplashState.unauthenticated().copyWith(
          navigationParams: const NavigationParams.replace(RoutePaths.login),
        );
        emit(newState);
      }
    } catch (e) {
      emit(SplashState.failure(e.toString()));
    }
  }
}
