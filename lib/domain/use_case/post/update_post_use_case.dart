import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

import 'package:flutter_post_blog/domain/value_objects/post_content.dart';
import 'package:flutter_post_blog/domain/value_objects/post_title.dart';

class UpdatePostUseCase extends BaseUseCase<void, UpdatePostUseCaseParams> {
  final PostRepository repository;

  UpdatePostUseCase(this.repository);

  @override
  Future<void> call(UpdatePostUseCaseParams params) {
    final updatedPost = params.post.copyWith(
      title: params.title.value,
      content: params.content.value,
      imageUrl: params.imageUrl,
    );
    return repository.updatePost(updatedPost);
  }
}

class UpdatePostUseCaseParams {
  final PostModel post;
  final PostTitle title;
  final PostContent content;
  final String? imageUrl;

  UpdatePostUseCaseParams({required this.post, required this.title, required this.content, this.imageUrl});
}
