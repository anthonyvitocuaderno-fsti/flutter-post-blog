import 'package:flutter_post_blog/domain/model/user_model.dart';
import 'package:flutter_post_blog/domain/repository/auth_repository.dart';
import 'package:flutter_post_blog/domain/use_case/auth/login_use_case.dart';
import 'package:flutter_post_blog/domain/value_objects/email.dart';
import 'package:flutter_post_blog/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testEmailVO = Email(testEmail);
    final testPasswordVO = Password(testPassword);
    final testUser = UserModel(
      id: '1',
      name: 'Test User',
      email: testEmail,
    );

    test('should login successfully with valid credentials', () async {
      // Arrange
      final params = LoginUseCaseParams(
        email: testEmailVO,
        password: testPasswordVO,
      );

      when(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => testUser);

      // Act
      final result = await loginUseCase(params);

      // Assert
      expect(result, testUser);
      verify(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw exception when login fails', () async {
      // Arrange
      final params = LoginUseCaseParams(
        email: testEmailVO,
        password: testPasswordVO,
      );
      final exception = Exception('Login failed');

      when(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenThrow(exception);

      // Act & Assert
      expect(
        () => loginUseCase(params),
        throwsA(exception),
      );

      verify(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}