import 'package:flutter_post_blog/core/base/base_usecase.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class FetchPostsUseCase extends BaseUseCase<List<PostModel>, NoParams> {
  final PostRepository repository;

  FetchPostsUseCase(this.repository);

  @override
  Future<List<PostModel>> call(NoParams params) {
    return repository.getPosts();
  }
}
