import 'package:flutter_post_blog/core/base/base_repository.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';

abstract class PostRepository extends BaseRepository {
  Future<List<PostModel>> getPosts({DateTime? startAfter, int limit = 20});
  Future<PostModel> getPostById(String id);
  Future<String> createPost({required String title, required String content});
  Future<void> updatePost(PostModel post);
  Future<void> deletePost(String id);
}
