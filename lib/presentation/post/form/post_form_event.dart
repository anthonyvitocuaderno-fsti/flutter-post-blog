import 'package:equatable/equatable.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/value_objects/post_content.dart';
import 'package:flutter_post_blog/domain/value_objects/post_title.dart';

abstract class PostFormEvent extends Equatable {
  const PostFormEvent();

  @override
  List<Object?> get props => [];
}

class CreatePostRequested extends PostFormEvent {
  final PostTitle title;
  final PostContent content;
  final String? imageUrl;

  const CreatePostRequested({required this.title, required this.content, this.imageUrl});

  @override
  List<Object?> get props => [title, content, imageUrl];
}

class UpdatePostRequested extends PostFormEvent {
  final PostModel post;
  final PostTitle title;
  final PostContent content;
  final String? imageUrl;

  const UpdatePostRequested({required this.post, required this.title, required this.content, this.imageUrl});

  @override
  List<Object?> get props => [post, title, content, imageUrl];
}

class DeletePostRequested extends PostFormEvent {
  final String id;

  const DeletePostRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class EditPostRequested extends PostFormEvent {
  final PostModel post;

  const EditPostRequested({required this.post});

  @override
  List<Object?> get props => [post];
}