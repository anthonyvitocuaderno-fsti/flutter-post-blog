import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/domain/use_case/post/fetch_posts_use_case.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/navigation_params.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_arguments.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';
import 'post_list_event.dart';
import 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final FetchPostsUseCase fetchPostsUseCase;
  static const _pageSize = 20;

  PostListBloc({required this.fetchPostsUseCase})
    : super(const PostListState.initial()) {
    on<PostListStarted>(_onStarted);
    on<PostListUpdated>(_onPostsUpdated);
    on<PostListLoadMoreRequested>(_onLoadMoreRequested);
    on<PostSelected>(_onPostSelected);
  }

  Future<void> _onPostSelected(
    PostSelected event,
    Emitter<PostListState> emit,
  ) async {
    final newState = state.copyWith(
      navigationParams: NavigationParams.push(
        RoutePaths.postDetail,
        arguments: PostDetailRouteArgs(event.post),
      ),
    );
    emit(newState);
    emit(newState.copyWith(navigationParams: null));
  }

  Future<void> _onStarted(
    PostListStarted event,
    Emitter<PostListState> emit,
  ) async {
    emit(const PostListState(status: PostListStatus.loading));

    try {
      final posts = await fetchPostsUseCase(const FetchPostsUseCaseParams());
      final lastUpdatedAt = posts.isNotEmpty ? posts.last.updatedAt : null;
      emit(
        PostListState(
          status: PostListStatus.success,
          posts: posts,
          hasMore: posts.length >= _pageSize,
          lastUpdatedAt: lastUpdatedAt,
        ),
      );
    } catch (e) {
      emit(
        PostListState(
          status: PostListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPostsUpdated(
    PostListUpdated event,
    Emitter<PostListState> emit,
  ) async {
    final posts = event.posts;
    final lastUpdatedAt = posts.isNotEmpty ? posts.last.updatedAt : null;
    emit(
      state.copyWith(
        status: PostListStatus.success,
        posts: posts,
        hasMore: state.hasMore,
        lastUpdatedAt: lastUpdatedAt,
      ),
    );
  }

  Future<void> _onLoadMoreRequested(
    PostListLoadMoreRequested event,
    Emitter<PostListState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;

    final currentCursor = state.lastUpdatedAt;
    if (currentCursor == null) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPosts = await fetchPostsUseCase(
        FetchPostsUseCaseParams(startAfter: currentCursor, limit: _pageSize),
      );

      final combined = [...state.posts, ...nextPosts];
      final lastUpdatedAt = combined.isNotEmpty
          ? combined.last.updatedAt
          : null;
      emit(
        state.copyWith(
          posts: combined,
          hasMore: nextPosts.length >= _pageSize,
          lastUpdatedAt: lastUpdatedAt,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, errorMessage: e.toString()));
    }
  }
}
