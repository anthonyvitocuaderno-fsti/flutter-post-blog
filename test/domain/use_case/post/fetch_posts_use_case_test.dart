import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';
import 'package:flutter_post_blog/domain/use_case/post/fetch_posts_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_posts_use_case_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late FetchPostsUseCase fetchPostsUseCase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    fetchPostsUseCase = FetchPostsUseCase(mockPostRepository);
  });

  group('FetchPostsUseCase', () {
    final testPosts = [
      PostModel(
        id: '1',
        title: 'Test Post 1',
        content: 'Content 1',
        authorId: 'user1',
        authorName: 'Author 1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PostModel(
        id: '2',
        title: 'Test Post 2',
        content: 'Content 2',
        authorId: 'user2',
        authorName: 'Author 2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    test('should fetch posts successfully with default params', () async {
      // Arrange
      const params = FetchPostsUseCaseParams();

      when(mockPostRepository.getPosts(
        startAfter: null,
        limit: 20,
      )).thenAnswer((_) async => testPosts);

      // Act
      final result = await fetchPostsUseCase(params);

      // Assert
      expect(result, testPosts);
      verify(mockPostRepository.getPosts(
        startAfter: null,
        limit: 20,
      )).called(1);
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should fetch posts with custom params', () async {
      // Arrange
      final startAfter = DateTime.now();
      const limit = 10;
      final params = FetchPostsUseCaseParams(
        startAfter: startAfter,
        limit: limit,
      );

      when(mockPostRepository.getPosts(
        startAfter: startAfter,
        limit: limit,
      )).thenAnswer((_) async => testPosts);

      // Act
      final result = await fetchPostsUseCase(params);

      // Assert
      expect(result, testPosts);
      verify(mockPostRepository.getPosts(
        startAfter: startAfter,
        limit: limit,
      )).called(1);
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should return empty list when no posts available', () async {
      // Arrange
      const params = FetchPostsUseCaseParams();
      final emptyPosts = <PostModel>[];

      when(mockPostRepository.getPosts(
        startAfter: null,
        limit: 20,
      )).thenAnswer((_) async => emptyPosts);

      // Act
      final result = await fetchPostsUseCase(params);

      // Assert
      expect(result, isEmpty);
      verify(mockPostRepository.getPosts(
        startAfter: null,
        limit: 20,
      )).called(1);
      verifyNoMoreInteractions(mockPostRepository);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      const params = FetchPostsUseCaseParams();
      final exception = Exception('Repository error');

      when(mockPostRepository.getPosts(
        startAfter: null,
        limit: 20,
      )).thenThrow(exception);

      // Act & Assert
      expect(
        () => fetchPostsUseCase(params),
        throwsA(exception),
      );

      verify(mockPostRepository.getPosts(
        startAfter: null,
        limit: 20,
      )).called(1);
      verifyNoMoreInteractions(mockPostRepository);
    });
  });
}