import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/use_case/post/fetch_posts_use_case.dart';
import 'package:flutter_post_blog/domain/use_case/post/watch_posts_use_case.dart';
import 'package:flutter_post_blog/presentation/post/list/post_list_bloc.dart';
import 'package:flutter_post_blog/presentation/post/list/post_list_event.dart';
import 'package:flutter_post_blog/presentation/post/list/post_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_list_bloc_test.mocks.dart';

@GenerateMocks([FetchPostsUseCase, WatchPostsUseCase])
void main() {
  late PostListBloc postListBloc;
  late MockFetchPostsUseCase mockFetchPostsUseCase;
  late MockWatchPostsUseCase mockWatchPostsUseCase;

  setUp(() {
    mockFetchPostsUseCase = MockFetchPostsUseCase();
    mockWatchPostsUseCase = MockWatchPostsUseCase();
    postListBloc = PostListBloc(
      fetchPostsUseCase: mockFetchPostsUseCase,
      watchPostsUseCase: mockWatchPostsUseCase,
    );
  });

  tearDown(() {
    postListBloc.close();
  });

  group('PostListBloc', () {
    final testPost1 = PostModel(
      id: '1',
      title: 'Test Post 1',
      content: 'Test content 1',
      authorId: 'user1',
      authorName: 'Test User 1',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    final testPost2 = PostModel(
      id: '2',
      title: 'Test Post 2',
      content: 'Test content 2',
      authorId: 'user2',
      authorName: 'Test User 2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final testPosts = [testPost1, testPost2];

    group('Initial state', () {
      test('should have initial state', () {
        expect(postListBloc.state, const PostListState.initial());
      });
    });

    group('PostListStarted', () {
      blocTest<PostListBloc, PostListState>(
        'should emit loading then success when posts are loaded',
        build: () => postListBloc,
        setUp: () {
          when(mockWatchPostsUseCase(any)).thenAnswer((_) => Stream.value(testPosts));
        },
        act: (bloc) => bloc.add(const PostListStarted()),
        expect: () => [
          const PostListState(status: PostListStatus.loading),
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: true,
            lastUpdatedAt: testPost2.updatedAt,
          ),
        ],
        verify: (_) {
          verify(mockWatchPostsUseCase(any)).called(1);
        },
      );

      blocTest<PostListBloc, PostListState>(
        'should emit loading then failure when subscription errors',
        build: () => postListBloc,
        setUp: () {
          when(mockWatchPostsUseCase(any)).thenAnswer((_) =>
              Stream.error(Exception('Subscription failed')));
        },
        act: (bloc) => bloc.add(const PostListStarted()),
        expect: () => [
          const PostListState(status: PostListStatus.loading),
          PostListState(
            status: PostListStatus.failure,
            errorMessage: 'Exception: Subscription failed',
          ),
        ],
      );
    });

    group('PostListUpdated', () {
      blocTest<PostListBloc, PostListState>(
        'should update posts when PostListUpdated is received',
        build: () => postListBloc,
        act: (bloc) => bloc.add(PostListUpdated(testPosts)),
        expect: () => [
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: true,
            lastUpdatedAt: testPost2.updatedAt,
          ),
        ],
      );
    });

    group('PostListLoadMoreRequested', () {
      blocTest<PostListBloc, PostListState>(
        'should set loading more state when load more is requested',
        build: () => postListBloc,
        setUp: () {
          when(mockFetchPostsUseCase(any)).thenAnswer((_) async => []);
          when(mockWatchPostsUseCase(any)).thenAnswer((_) => Stream.value(testPosts));
        },
        act: (bloc) {
          bloc.add(const PostListStarted());
          return Future.delayed(const Duration(milliseconds: 10)).then((_) {
            bloc.add(const PostListLoadMoreRequested());
          });
        },
        expect: () => [
          const PostListState(status: PostListStatus.loading),
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: true,
            lastUpdatedAt: testPost2.updatedAt,
          ),
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: true,
            lastUpdatedAt: testPost2.updatedAt,
            isLoadingMore: true,
          ),
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: false, // No more posts available
            lastUpdatedAt: testPost2.updatedAt,
            isLoadingMore: false,
          ),
        ],
      );

      blocTest<PostListBloc, PostListState>(
        'should not load more when already loading',
        build: () => postListBloc,
        setUp: () {
          when(mockFetchPostsUseCase(any)).thenAnswer((_) async => []);
          when(mockWatchPostsUseCase(any)).thenAnswer((_) => Stream.value(testPosts));
        },
        act: (bloc) {
          bloc.add(const PostListStarted());
          return Future.delayed(const Duration(milliseconds: 10)).then((_) {
            bloc.add(const PostListLoadMoreRequested());
            bloc.add(const PostListLoadMoreRequested()); // Second call should be ignored
          });
        },
        expect: () => [
          const PostListState(status: PostListStatus.loading),
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: true,
            lastUpdatedAt: testPost2.updatedAt,
          ),
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: true,
            lastUpdatedAt: testPost2.updatedAt,
            isLoadingMore: true,
          ),
          PostListState(
            status: PostListStatus.success,
            posts: testPosts,
            hasMore: false, // No more posts available
            lastUpdatedAt: testPost2.updatedAt,
            isLoadingMore: false,
          ),
        ],
      );
    });

    group('PostSelected', () {
      blocTest<PostListBloc, PostListState>(
        'should emit navigation params then reset when post is selected',
        build: () => postListBloc,
        act: (bloc) => bloc.add(PostSelected(testPost1)),
        expect: () => [
          predicate<PostListState>((state) =>
              state.navigationParams != null &&
              state.status == PostListStatus.initial),
          const PostListState.initial(),
        ],
      );
    });

    group('State reset scenarios', () {
      test('should reset navigation after navigation events', () async {
        // Start with initial state
        expect(postListBloc.state, const PostListState.initial());

        // Add navigation event
        postListBloc.add(PostSelected(testPost1));

        // Wait for state changes
        await expectLater(
          postListBloc.stream,
          emitsInOrder([
            predicate<PostListState>((state) =>
                state.navigationParams != null &&
                state.status == PostListStatus.initial),
            const PostListState.initial(),
          ]),
        );

        // Bloc should be back to initial state
        expect(postListBloc.state, const PostListState.initial());
      });

      test('should not have side effects between operations', () async {
        // First operation: start and load posts
        when(mockWatchPostsUseCase(any)).thenAnswer((_) => Stream.value(testPosts));
        postListBloc.add(const PostListStarted());

        await expectLater(
          postListBloc.stream,
          emitsInOrder([
            const PostListState(status: PostListStatus.loading),
            PostListState(
              status: PostListStatus.success,
              posts: testPosts,
              hasMore: true,
              lastUpdatedAt: testPost2.updatedAt,
            ),
          ]),
        );

        // Create a new bloc instance for the second operation to ensure no side effects
        final newBloc = PostListBloc(
          fetchPostsUseCase: mockFetchPostsUseCase,
          watchPostsUseCase: mockWatchPostsUseCase,
        );

        // Second operation: successful navigation (should work independently)
        newBloc.add(PostSelected(testPost1));

        await expectLater(
          newBloc.stream,
          emitsInOrder([
            predicate<PostListState>((state) =>
                state.navigationParams != null &&
                state.status == PostListStatus.initial),
            const PostListState.initial(),
          ]),
        );

        newBloc.close();
      });
    });
  });
}