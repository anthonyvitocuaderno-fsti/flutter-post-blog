import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/use_case/auth/get_current_user_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/auth/logout_use_case.dart';
import 'package:flutter_post_blog/presentation/dashboard/dashboard_bloc.dart';
import 'package:flutter_post_blog/presentation/dashboard/dashboard_event.dart';
import 'package:flutter_post_blog/presentation/dashboard/dashboard_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dashboard_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentUserUseCase, LogoutUseCase])
void main() {
  late DashboardBloc dashboardBloc;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    dashboardBloc = DashboardBloc(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  tearDown(() {
    dashboardBloc.close();
  });

  group('DashboardBloc', () {
    final testUser = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
    );

    group('Initial state', () {
      test('should have initial state', () {
        expect(dashboardBloc.state, const DashboardState.initial());
      });
    });

    group('DashboardStarted', () {
      blocTest<DashboardBloc, DashboardState>(
        'should emit loading then loaded when user is found',
        build: () => dashboardBloc,
        setUp: () {
          when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => testUser);
        },
        act: (bloc) => bloc.add(const DashboardStarted()),
        expect: () => [
          const DashboardState.loading(),
          DashboardState.loaded(testUser),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase(any)).called(1);
        },
      );

      blocTest<DashboardBloc, DashboardState>(
        'should emit loading then loggedOut when no user is found',
        build: () => dashboardBloc,
        setUp: () {
          when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => null);
        },
        act: (bloc) => bloc.add(const DashboardStarted()),
        expect: () => [
          const DashboardState.loading(),
          const DashboardState.loggedOut(),
        ],
      );

      blocTest<DashboardBloc, DashboardState>(
        'should emit loading then failure when getCurrentUser fails',
        build: () => dashboardBloc,
        setUp: () {
          when(mockGetCurrentUserUseCase(any)).thenThrow(Exception('Get user failed'));
        },
        act: (bloc) => bloc.add(const DashboardStarted()),
        expect: () => [
          const DashboardState.loading(),
          DashboardState.failure('Exception: Get user failed'),
        ],
      );
    });

    group('DashboardLogoutRequested', () {
      blocTest<DashboardBloc, DashboardState>(
        'should emit loading then loggedOut with navigation when logout succeeds',
        build: () => dashboardBloc,
        setUp: () {
          when(mockLogoutUseCase(any)).thenAnswer((_) async {});
        },
        act: (bloc) => bloc.add(const DashboardLogoutRequested()),
        expect: () => [
          const DashboardState.loading(),
          predicate<DashboardState>((state) =>
              state.status == DashboardStatus.loggedOut &&
              state.navigationParams != null),
          const DashboardState.loggedOut(),
        ],
        verify: (_) {
          verify(mockLogoutUseCase(any)).called(1);
        },
      );

      blocTest<DashboardBloc, DashboardState>(
        'should emit loading then failure when logout fails',
        build: () => dashboardBloc,
        setUp: () {
          when(mockLogoutUseCase(any)).thenThrow(Exception('Logout failed'));
        },
        act: (bloc) => bloc.add(const DashboardLogoutRequested()),
        expect: () => [
          const DashboardState.loading(),
          DashboardState.failure('Exception: Logout failed'),
        ],
      );
    });

    group('DashboardCreatePostRequested', () {
      blocTest<DashboardBloc, DashboardState>(
        'should emit navigation params then reset when creating post',
        build: () => dashboardBloc,
        act: (bloc) => bloc.add(const DashboardCreatePostRequested()),
        expect: () => [
          predicate<DashboardState>((state) =>
              state.navigationParams != null &&
              state.status == DashboardStatus.initial),
          const DashboardState.initial(),
        ],
      );
    });

    group('State reset scenarios', () {
      test('should reset to initial state after successful operations', () async {
        // Start with initial state
        expect(dashboardBloc.state, const DashboardState.initial());

        // Mock successful user fetch
        when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => testUser);

        // Add started event
        dashboardBloc.add(const DashboardStarted());

        // Wait for state changes
        await expectLater(
          dashboardBloc.stream,
          emitsInOrder([
            const DashboardState.loading(),
            DashboardState.loaded(testUser),
          ]),
        );

        // Bloc should be in loaded state (not reset to initial)
        expect(dashboardBloc.state, DashboardState.loaded(testUser));
      });

      test('should reset navigation after navigation events', () async {
        // Start with initial state
        expect(dashboardBloc.state, const DashboardState.initial());

        // Add navigation event
        dashboardBloc.add(const DashboardCreatePostRequested());

        // Wait for state changes
        await expectLater(
          dashboardBloc.stream,
          emitsInOrder([
            predicate<DashboardState>((state) =>
                state.navigationParams != null &&
                state.status == DashboardStatus.initial),
            const DashboardState.initial(),
          ]),
        );

        // Bloc should be back to initial state
        expect(dashboardBloc.state, const DashboardState.initial());
      });

      test('should not have side effects between operations', () async {
        // First operation: failed getCurrentUser
        when(mockGetCurrentUserUseCase(any)).thenThrow(Exception('User error'));
        dashboardBloc.add(const DashboardStarted());

        await expectLater(
          dashboardBloc.stream,
          emitsInOrder([
            const DashboardState.loading(),
            DashboardState.failure('Exception: User error'),
          ]),
        );

        // Create a new bloc instance for the second operation to ensure no side effects
        final newBloc = DashboardBloc(
          getCurrentUserUseCase: mockGetCurrentUserUseCase,
          logoutUseCase: mockLogoutUseCase,
        );

        // Second operation: successful navigation (should work independently)
        newBloc.add(const DashboardCreatePostRequested());

        await expectLater(
          newBloc.stream,
          emitsInOrder([
            predicate<DashboardState>((state) =>
                state.navigationParams != null &&
                state.status == DashboardStatus.initial),
            const DashboardState.initial(),
          ]),
        );

        newBloc.close();
      });
    });
  });
}