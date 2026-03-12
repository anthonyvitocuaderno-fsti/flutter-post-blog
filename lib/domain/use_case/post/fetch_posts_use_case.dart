import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class FetchPostsUseCaseParams {
  final DateTime? startAfter;
  final int limit;

  const FetchPostsUseCaseParams({this.startAfter, this.limit = 20});
}

class FetchPostsUseCase extends BaseUseCase<List<PostModel>, FetchPostsUseCaseParams> {
  final PostRepository repository;

  FetchPostsUseCase(this.repository);

  @override
  Future<List<PostModel>> call(FetchPostsUseCaseParams params) {
    return repository.getPosts(
      startAfter: params.startAfter,
      limit: params.limit,
    );
  }
}
