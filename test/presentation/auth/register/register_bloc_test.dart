import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/use_case/auth/register_use_case.dart';
import 'package:flutter_post_blog/presentation/auth/register/register_bloc.dart';
import 'package:flutter_post_blog/presentation/auth/register/register_event.dart';
import 'package:flutter_post_blog/presentation/auth/register/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_bloc_test.mocks.dart';

@GenerateMocks([RegisterUseCase])
void main() {
  late RegisterBloc registerBloc;
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    registerBloc = RegisterBloc(registerUseCase: mockRegisterUseCase);
  });

  tearDown(() {
    registerBloc.close();
  });

  group('RegisterBloc', () {
    const testName = 'Test User';
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testUser = UserModel(
      id: '1',
      name: testName,
      email: testEmail,
    );

    group('Initial state', () {
      test('should have initial state', () {
        expect(registerBloc.state, const RegisterState());
      });
    });

    group('RegisterRequested', () {
      blocTest<RegisterBloc, RegisterState>(
        'should emit loading then success with navigation when register succeeds',
        build: () => registerBloc,
        setUp: () {
          when(mockRegisterUseCase(any)).thenAnswer((_) async => testUser);
        },
        act: (bloc) => bloc.add(const RegisterRequested(
          name: testName,
          email: testEmail,
          password: testPassword,
        )),
        expect: () => [
          const RegisterState(status: RegisterStatus.loading),
          predicate<RegisterState>((state) =>
              state.status == RegisterStatus.success &&
              state.navigationParams != null),
          const RegisterState(status: RegisterStatus.initial),
        ],
        verify: (_) {
          verify(mockRegisterUseCase(any)).called(1);
        },
      );

      blocTest<RegisterBloc, RegisterState>(
        'should emit loading then failure when register fails',
        build: () => registerBloc,
        setUp: () {
          when(mockRegisterUseCase(any)).thenThrow(Exception('Register failed'));
        },
        act: (bloc) => bloc.add(const RegisterRequested(
          name: testName,
          email: testEmail,
          password: testPassword,
        )),
        expect: () => [
          const RegisterState(status: RegisterStatus.loading),
          RegisterState(status: RegisterStatus.failure, errorMessage: 'Exception: Register failed'),
        ],
      );
    });

    group('NavigateToLoginRequested', () {
      blocTest<RegisterBloc, RegisterState>(
        'should emit navigation params then reset when navigating to login',
        build: () => registerBloc,
        act: (bloc) => bloc.add(const NavigateToLoginRequested()),
        expect: () => [
          predicate<RegisterState>((state) =>
              state.navigationParams != null &&
              state.status == RegisterStatus.initial),
          const RegisterState(status: RegisterStatus.initial),
        ],
      );
    });

    group('State reset scenarios', () {
      test('should reset to initial state after successful register', () async {
        // Start with initial state
        expect(registerBloc.state, const RegisterState());

        // Mock successful register
        when(mockRegisterUseCase(any)).thenAnswer((_) async => testUser);

        // Add register event
        registerBloc.add(const RegisterRequested(
          name: testName,
          email: testEmail,
          password: testPassword,
        ));

        // Wait for state changes
        await expectLater(
          registerBloc.stream,
          emitsInOrder([
            const RegisterState(status: RegisterStatus.loading),
            predicate<RegisterState>((state) =>
                state.status == RegisterStatus.success &&
                state.navigationParams != null),
            const RegisterState(status: RegisterStatus.initial),
          ]),
        );

        // Bloc should be back to initial state
        expect(registerBloc.state, const RegisterState());
      });

      test('should reset to initial state after navigation events', () async {
        // Start with initial state
        expect(registerBloc.state, const RegisterState());

        // Add navigation event
        registerBloc.add(const NavigateToLoginRequested());

        // Wait for state changes
        await expectLater(
          registerBloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) =>
                state.navigationParams != null &&
                state.status == RegisterStatus.initial),
            const RegisterState(status: RegisterStatus.initial),
          ]),
        );

        // Bloc should be back to initial state
        expect(registerBloc.state, const RegisterState());
      });

      test('should not have side effects between operations', () async {
        // First operation: failed register
        when(mockRegisterUseCase(any)).thenThrow(Exception('Register error'));
        registerBloc.add(const RegisterRequested(
          name: testName,
          email: testEmail,
          password: testPassword,
        ));

        await expectLater(
          registerBloc.stream,
          emitsInOrder([
            const RegisterState(status: RegisterStatus.loading),
            RegisterState(status: RegisterStatus.failure, errorMessage: 'Exception: Register error'),
          ]),
        );

        // Create a new bloc instance for the second operation to ensure no side effects
        final newBloc = RegisterBloc(registerUseCase: mockRegisterUseCase);

        // Second operation: successful navigation (should work independently)
        newBloc.add(const NavigateToLoginRequested());

        await expectLater(
          newBloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) =>
                state.navigationParams != null &&
                state.status == RegisterStatus.initial),
            const RegisterState(status: RegisterStatus.initial),
          ]),
        );

        newBloc.close();
      });
    });
  });
}