import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_post_blog/domain/model/post_model.dart';

enum PostListStatus { initial, loading, success, failure }

class PostListState extends Equatable {
  final PostListStatus status;
  final List<PostModel> posts;
  final String? errorMessage;
  final String? navigationRoute;
  final Object? navigationArguments;
  final bool navigationReplace;
  final bool navigationRemoveUntil;
  final bool Function(Route<dynamic>)? navigationPredicate;

  const PostListState({
    required this.status,
    this.posts = const [],
    this.errorMessage,
    this.navigationRoute,
    this.navigationArguments,
    this.navigationReplace = false,
    this.navigationRemoveUntil = false,
    this.navigationPredicate,
  });

  const PostListState.initial() : this(status: PostListStatus.initial);

  PostListState copyWith({
    PostListStatus? status,
    List<PostModel>? posts,
    String? errorMessage,
    String? navigationRoute,
    Object? navigationArguments,
    bool? navigationReplace,
    bool? navigationRemoveUntil,
    bool Function(Route<dynamic>)? navigationPredicate,
  }) {
    return PostListState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
      navigationRoute: navigationRoute ?? this.navigationRoute,
      navigationArguments: navigationArguments ?? this.navigationArguments,
      navigationReplace: navigationReplace ?? this.navigationReplace,
      navigationRemoveUntil: navigationRemoveUntil ?? this.navigationRemoveUntil,
      navigationPredicate: navigationPredicate ?? this.navigationPredicate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        posts,
        errorMessage,
        navigationRoute,
        navigationArguments,
        navigationReplace,
        navigationRemoveUntil,
        navigationPredicate,
      ];
}
