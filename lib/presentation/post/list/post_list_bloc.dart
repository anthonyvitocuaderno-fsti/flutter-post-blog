import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/use_case/post/fetch_posts_use_case.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_arguments.dart';
import 'package:flutter_post_blog/presentation/shared/navigation/route_paths.dart';
import 'post_list_event.dart';
import 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final FetchPostsUseCase fetchPostsUseCase;

  PostListBloc({required this.fetchPostsUseCase}) : super(const PostListState.initial()) {
    on<PostListStarted>(_onStarted);
    on<PostSelected>(_onPostSelected);
  }

  Future<void> _onPostSelected(
    PostSelected event,
    Emitter<PostListState> emit,
  ) async {
    final newState = state.copyWith(
      navigationRoute: RoutePaths.postDetail,
      navigationArguments: PostDetailRouteArgs(event.post),
    );
    emit(newState);
    emit(newState.copyWith(navigationRoute: null, navigationArguments: null));
  }

  Future<void> _onStarted(PostListStarted event, Emitter<PostListState> emit) async {
    emit(const PostListState(status: PostListStatus.loading));

    try {
      final posts = await fetchPostsUseCase(const NoParams());
      emit(PostListState(status: PostListStatus.success, posts: posts));
    } catch (e) {
      emit(PostListState(status: PostListStatus.failure, errorMessage: e.toString()));
    }
  }
}
