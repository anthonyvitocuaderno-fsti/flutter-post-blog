
import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class DeleteImageUseCase extends BaseUseCase<void, DeleteImageParams> {
  final PostRepository repository;

  DeleteImageUseCase(this.repository);

  @override
  Future<void> call(DeleteImageParams params) {

    return repository.deleteImage(params.imageUrl);
  }
}

class DeleteImageParams {
  final String imageUrl;

  DeleteImageParams({required this.imageUrl});
}
