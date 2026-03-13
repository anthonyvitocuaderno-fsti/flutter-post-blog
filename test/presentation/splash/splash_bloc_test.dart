import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/use_case/auth/get_current_user_use_case.dart';
import 'package:flutter_post_blog/presentation/splash/splash_bloc.dart';
import 'package:flutter_post_blog/presentation/splash/splash_event.dart';
import 'package:flutter_post_blog/presentation/splash/splash_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'splash_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentUserUseCase])
void main() {
  late SplashBloc splashBloc;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    splashBloc = SplashBloc(getCurrentUserUseCase: mockGetCurrentUserUseCase);
  });

  tearDown(() {
    splashBloc.close();
  });

  group('SplashBloc', () {
    final testUser = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
    );

    group('Initial state', () {
      test('should have initial state', () {
        expect(splashBloc.state, const SplashState.initial());
      });
    });

    group('SplashStarted', () {
      blocTest<SplashBloc, SplashState>(
        'should emit loading then authenticated with navigation when user is found',
        build: () => splashBloc,
        setUp: () {
          when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => testUser);
        },
        act: (bloc) => bloc.add(const SplashStarted()),
        expect: () => [
          const SplashState.loading(),
          predicate<SplashState>((state) =>
              state.status == SplashStatus.authenticated &&
              state.user == testUser &&
              state.navigationParams != null),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase(any)).called(1);
        },
      );

      blocTest<SplashBloc, SplashState>(
        'should emit loading then unauthenticated with navigation when no user is found',
        build: () => splashBloc,
        setUp: () {
          when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => null);
        },
        act: (bloc) => bloc.add(const SplashStarted()),
        expect: () => [
          const SplashState.loading(),
          predicate<SplashState>((state) =>
              state.status == SplashStatus.unauthenticated &&
              state.user == null &&
              state.navigationParams != null),
        ],
      );

      blocTest<SplashBloc, SplashState>(
        'should emit loading then failure when getCurrentUser fails',
        build: () => splashBloc,
        setUp: () {
          when(mockGetCurrentUserUseCase(any)).thenThrow(Exception('Get user failed'));
        },
        act: (bloc) => bloc.add(const SplashStarted()),
        expect: () => [
          const SplashState.loading(),
          SplashState.failure('Exception: Get user failed'),
        ],
      );
    });

    group('State reset scenarios', () {
      test('should maintain final state after successful authentication', () async {
        // Start with initial state
        expect(splashBloc.state, const SplashState.initial());

        // Mock successful user fetch
        when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => testUser);

        // Add started event
        splashBloc.add(const SplashStarted());

        // Wait for state changes
        await expectLater(
          splashBloc.stream,
          emitsInOrder([
            const SplashState.loading(),
            predicate<SplashState>((state) =>
                state.status == SplashStatus.authenticated &&
                state.user == testUser &&
                state.navigationParams != null),
          ]),
        );

        // Bloc should maintain the authenticated state with navigation params
        expect(splashBloc.state.status, SplashStatus.authenticated);
        expect(splashBloc.state.user, testUser);
        expect(splashBloc.state.navigationParams, isNotNull);
      });

      test('should maintain final state after unauthenticated flow', () async {
        // Start with initial state
        expect(splashBloc.state, const SplashState.initial());

        // Mock no user found
        when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => null);

        // Add started event
        splashBloc.add(const SplashStarted());

        // Wait for state changes
        await expectLater(
          splashBloc.stream,
          emitsInOrder([
            const SplashState.loading(),
            predicate<SplashState>((state) =>
                state.status == SplashStatus.unauthenticated &&
                state.user == null &&
                state.navigationParams != null),
          ]),
        );

        // Bloc should maintain the unauthenticated state with navigation params
        expect(splashBloc.state.status, SplashStatus.unauthenticated);
        expect(splashBloc.state.user, null);
        expect(splashBloc.state.navigationParams, isNotNull);
      });

      test('should not have side effects between operations', () async {
        // First operation: failed getCurrentUser
        when(mockGetCurrentUserUseCase(any)).thenThrow(Exception('User error'));
        splashBloc.add(const SplashStarted());

        await expectLater(
          splashBloc.stream,
          emitsInOrder([
            const SplashState.loading(),
            SplashState.failure('Exception: User error'),
          ]),
        );

        // Create a new bloc instance for the second operation to ensure no side effects
        final newBloc = SplashBloc(getCurrentUserUseCase: mockGetCurrentUserUseCase);

        // Second operation: successful authentication
        when(mockGetCurrentUserUseCase(any)).thenAnswer((_) async => testUser);
        newBloc.add(const SplashStarted());

        await expectLater(
          newBloc.stream,
          emitsInOrder([
            const SplashState.loading(),
            predicate<SplashState>((state) =>
                state.status == SplashStatus.authenticated &&
                state.user == testUser &&
                state.navigationParams != null),
          ]),
        );

        newBloc.close();
      });
    });
  });
}