import 'package:flutter_post_blog/core/base/base_repository.dart';
import 'package:flutter_post_blog/domain/model/post_model.dart';

abstract class PostRepository extends BaseRepository {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPostById(String id);
  Future<void> updatePost(PostModel post);
  Future<void> deletePost(String id);
}
