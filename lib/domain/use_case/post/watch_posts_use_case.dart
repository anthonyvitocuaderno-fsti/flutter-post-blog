import 'package:flutter_post_blog/domain/model/post_model.dart';
import 'package:flutter_post_blog/domain/repository/post_repository.dart';

class WatchPostsUseCaseParams {
  final int limit;

  const WatchPostsUseCaseParams({this.limit = 20});
}

class WatchPostsUseCase {
  final PostRepository repository;

  WatchPostsUseCase(this.repository);

  Stream<List<PostModel>> call(WatchPostsUseCaseParams params) {
    return repository.watchPosts(limit: params.limit);
  }
}
