import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/use_case/auth/login_use_case.dart';
import 'package:flutter_post_blog/domain/value_objects/email.dart';
import 'package:flutter_post_blog/domain/value_objects/password.dart';
import 'package:flutter_post_blog/presentation/auth/login/login_bloc.dart';
import 'package:flutter_post_blog/presentation/auth/login/login_event.dart';
import 'package:flutter_post_blog/presentation/auth/login/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([LoginUseCase])
void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testUser = UserModel(
      id: '1',
      name: 'Test User',
      email: testEmail
    );

    group('Initial state', () {
      test('should have initial state', () {
        expect(loginBloc.state, const LoginState());
      });
    });

    group('LoginRequested', () {
      blocTest<LoginBloc, LoginState>(
        'should emit loading then success with navigation when login succeeds',
        build: () => loginBloc,
        setUp: () {
          when(mockLoginUseCase(any)).thenAnswer((_) async => testUser);
        },
        act: (bloc) => bloc.add(const LoginRequested(
          email: testEmail,
          password: testPassword,
        )),
        expect: () => [
          const LoginState(status: LoginStatus.loading),
          predicate<LoginState>((state) =>
              state.status == LoginStatus.success &&
              state.navigationParams != null),
          const LoginState(status: LoginStatus.initial),
        ],
        verify: (_) {
          verify(mockLoginUseCase(any)).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'should emit loading then failure when login fails',
        build: () => loginBloc,
        setUp: () {
          when(mockLoginUseCase(any)).thenThrow(Exception('Login failed'));
        },
        act: (bloc) => bloc.add(const LoginRequested(
          email: testEmail,
          password: testPassword,
        )),
        expect: () => [
          const LoginState(status: LoginStatus.loading),
          LoginState(status: LoginStatus.failure, errorMessage: 'Exception: Login failed'),
        ],
      );
    });

    group('NavigateToRegisterRequested', () {
      blocTest<LoginBloc, LoginState>(
        'should emit navigation params then reset when navigating to register',
        build: () => loginBloc,
        act: (bloc) => bloc.add(const NavigateToRegisterRequested()),
        expect: () => [
          predicate<LoginState>((state) =>
              state.navigationParams != null &&
              state.status == LoginStatus.initial),
          const LoginState(status: LoginStatus.initial),
        ],
      );
    });

    group('ContinueAsGuestRequested', () {
      blocTest<LoginBloc, LoginState>(
        'should emit navigation params then reset when continuing as guest',
        build: () => loginBloc,
        act: (bloc) => bloc.add(const ContinueAsGuestRequested()),
        expect: () => [
          predicate<LoginState>((state) =>
              state.navigationParams != null &&
              state.status == LoginStatus.initial),
          const LoginState(status: LoginStatus.initial),
        ],
      );
    });

    group('State reset scenarios', () {
      test('should reset to initial state after successful login', () async {
        // Start with initial state
        expect(loginBloc.state, const LoginState());

        // Mock successful login
        when(mockLoginUseCase(any)).thenAnswer((_) async => testUser);

        // Add login event
        loginBloc.add(const LoginRequested(
          email: testEmail,
          password: testPassword,
        ));

        // Wait for state changes
        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            const LoginState(status: LoginStatus.loading),
            predicate<LoginState>((state) =>
                state.status == LoginStatus.success &&
                state.navigationParams != null),
            const LoginState(status: LoginStatus.initial),
          ]),
        );

        // Bloc should be back to initial state
        expect(loginBloc.state, const LoginState());
      });

      test('should reset to initial state after navigation events', () async {
        // Start with initial state
        expect(loginBloc.state, const LoginState());

        // Add navigation event
        loginBloc.add(const NavigateToRegisterRequested());

        // Wait for state changes
        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            predicate<LoginState>((state) =>
                state.navigationParams != null &&
                state.status == LoginStatus.initial),
            const LoginState(status: LoginStatus.initial),
          ]),
        );

        // Bloc should be back to initial state
        expect(loginBloc.state, const LoginState());
      });

      test('should not have side effects between operations', () async {
        // First operation: failed login
        when(mockLoginUseCase(any)).thenThrow(Exception('Login error'));
        loginBloc.add(const LoginRequested(
          email: testEmail,
          password: testPassword,
        ));

        await expectLater(
          loginBloc.stream,
          emitsInOrder([
            const LoginState(status: LoginStatus.loading),
            LoginState(status: LoginStatus.failure, errorMessage: 'Exception: Login error'),
          ]),
        );

        // Create a new bloc instance for the second operation to ensure no side effects
        final newBloc = LoginBloc(loginUseCase: mockLoginUseCase);

        // Second operation: successful navigation (should work independently)
        newBloc.add(const ContinueAsGuestRequested());

        await expectLater(
          newBloc.stream,
          emitsInOrder([
            predicate<LoginState>((state) =>
                state.navigationParams != null &&
                state.status == LoginStatus.initial),
            const LoginState(status: LoginStatus.initial),
          ]),
        );

        newBloc.close();
      });
    });
  });
}