import 'package:equatable/equatable.dart';

import 'package:flutter_post_blog/domain/model/post_model.dart';

import '../../shared/navigation/navigation_params.dart';

enum PostListStatus { initial, loading, success, failure }

class PostListState extends Equatable {
  final PostListStatus status;
  final List<PostModel> posts;
  final bool isLoadingMore;
  final bool hasMore;
  final DateTime? lastUpdatedAt;
  final String? errorMessage;
  final NavigationParams? navigationParams;

  const PostListState({
    required this.status,
    this.posts = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.lastUpdatedAt,
    this.errorMessage,
    this.navigationParams,
  });

  const PostListState.initial() : this(status: PostListStatus.initial);

  PostListState copyWith({
    PostListStatus? status,
    List<PostModel>? posts,
    bool? isLoadingMore,
    bool? hasMore,
    DateTime? lastUpdatedAt,
    String? errorMessage,
    NavigationParams? navigationParams,
  }) {
    return PostListState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationParams: navigationParams,
    );
  }

  @override
  List<Object?> get props => [
        status,
        posts,
        isLoadingMore,
        hasMore,
        lastUpdatedAt,
        errorMessage,
        navigationParams,
      ];
}
