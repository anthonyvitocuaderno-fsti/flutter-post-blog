import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class GetPostDetailUseCase extends BaseUseCase<PostModel, GetPostDetailParams> {
  final PostRepository repository;

  GetPostDetailUseCase(this.repository);

  @override
  Future<PostModel> call(GetPostDetailParams params) {
    return repository.getPostById(params.id);
  }
}

class GetPostDetailParams {
  final String id;

  GetPostDetailParams(this.id);
}
