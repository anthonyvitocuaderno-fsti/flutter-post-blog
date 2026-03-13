import 'package:equatable/equatable.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';

abstract class PostListEvent extends Equatable {
  const PostListEvent();

  @override
  List<Object?> get props => [];
}

class PostListStarted extends PostListEvent {
  const PostListStarted();
}

class PostListUpdated extends PostListEvent {
  final List<PostModel> posts;

  const PostListUpdated(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostListLoadMoreRequested extends PostListEvent {
  const PostListLoadMoreRequested();
}

class PostSelected extends PostListEvent {
  final PostModel post;

  const PostSelected(this.post);

  @override
  List<Object?> get props => [post];
}
