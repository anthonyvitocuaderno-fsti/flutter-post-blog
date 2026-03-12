import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class DeletePostUseCase extends BaseUseCase<void, DeletePostUseCaseParams> {
  final PostRepository repository;

  DeletePostUseCase(this.repository);

  @override
  Future<void> call(DeletePostUseCaseParams params) {
    return repository.deletePost(params.id);
  }
}

class DeletePostUseCaseParams {
  final String id;

  DeletePostUseCaseParams(this.id);
}
