import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class UpdatePostUseCase extends BaseUseCase<void, UpdatePostUseCaseParams> {
  final PostRepository repository;

  UpdatePostUseCase(this.repository);

  @override
  Future<void> call(UpdatePostUseCaseParams params) {
    return repository.updatePost(params.post);
  }
}

class UpdatePostUseCaseParams {
  final PostModel post;

  UpdatePostUseCaseParams(this.post);
}
