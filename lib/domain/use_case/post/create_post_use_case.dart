import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

import 'package:flutter_post_blog/domain/value_objects/post_content.dart';
import 'package:flutter_post_blog/domain/value_objects/post_title.dart';

class CreatePostUseCaseParams {
  final PostTitle title;
  final PostContent content;
  final String? imageUrl;

  const CreatePostUseCaseParams({required this.title, required this.content, this.imageUrl});
}

class CreatePostUseCase extends BaseUseCase<String, CreatePostUseCaseParams> {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  @override
  Future<String> call(CreatePostUseCaseParams params) {
    return repository.createPost(
      title: params.title.value,
      content: params.content.value,
      imageUrl: params.imageUrl,
    );
  }
}
