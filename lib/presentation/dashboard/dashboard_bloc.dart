import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/use_case/auth/get_current_user_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/auth/logout_use_case.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_params.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  DashboardBloc({
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(const DashboardState.initial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardLogoutRequested>(_onLogoutRequested);
    on<DashboardCreatePostRequested>(_onCreatePostRequested);
  }

  Future<void> _onCreatePostRequested(
    DashboardCreatePostRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final newState = state.copyWith(
      navigationParams: const NavigationParams.push(RoutePaths.createPost),
    );
    emit(newState);
    emit(newState.copyWith(navigationParams: null));
  }

  Future<void> _onStarted(DashboardStarted event, Emitter<DashboardState> emit) async {
    emit(const DashboardState.loading());

    try {
      final user = await getCurrentUserUseCase(const NoParams());
      if (user != null) {
        emit(DashboardState.loaded(user));
      } else {
        emit(const DashboardState.loggedOut());
      }
    } catch (e) {
      emit(DashboardState.failure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    DashboardLogoutRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardState.loading());
    try {
      await logoutUseCase(const NoParams());
      final newState = const DashboardState.loggedOut().copyWith(
        navigationParams: NavigationParams.removeUntil(
          RoutePaths.login,
          (route) => false,
        ),
      );
      emit(newState);
      emit(newState.copyWith(navigationParams: null));
    } catch (e) {
      emit(DashboardState.failure(e.toString()));
    }
  }
}
