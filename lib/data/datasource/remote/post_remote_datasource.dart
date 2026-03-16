import 'package:cloud_firestore/cloud_firestore.dart';

import '../../entity/remote/post_entity_remote.dart';

abstract class PostRemoteDataSource {
  /// Fetches a page of posts ordered by `updatedAt` descending.
  ///
  /// If [startAfter] is provided, the results will begin after that timestamp.
  Future<List<PostEntityRemote>> fetchPosts({
    Timestamp? startAfter,
    int limit = 20,
  });

  /// Watches a stream of posts ordered by `updatedAt` descending.
  Stream<List<PostEntityRemote>> watchPosts({
    int limit = 20,
  });

  /// Fetch a single post by its document ID.
  Future<PostEntityRemote?> fetchPostById(String id);

  /// Create a new post belonging to the current user.
  /// Returns the newly created document ID.
  Future<String> createPost({
    required String title,
    required String content,
    String? imageUrl,
  });

  /// Update a post owned by the current user.
  Future<void> updatePost({
    required String id,
    required String title,
    required String content,
    String? imageUrl,
  });

  /// Delete a post owned by the current user.
  Future<void> deletePost(String id);
}
