import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/base/base_repository.dart';
import '../../domain/model/post_model.dart';
import '../../domain/repository/post_repository.dart';
import '../datasource/remote/post_remote_datasource.dart';

class PostRepositoryImpl extends BaseRepository implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PostModel>> getPosts({DateTime? startAfter, int limit = 20}) async {
    final timestamp = startAfter != null ? Timestamp.fromDate(startAfter) : null;
    final remotePosts = await remoteDataSource.fetchPosts(
      startAfter: timestamp,
      limit: limit,
    );

    return remotePosts
        .map((remote) {
          final updatedAt = remote.updatedAt;
          final createdAt = remote.createdAt;

          return PostModel(
            id: remote.id,
            title: remote.title,
            content: remote.content,
            authorId: remote.authorId,
            authorName: remote.authorName,
            createdAt: (createdAt is DateTime)
                ? createdAt
                : (createdAt is Timestamp)
                    ? createdAt.toDate()
                    : DateTime.fromMillisecondsSinceEpoch(0),
            updatedAt: (updatedAt is DateTime)
                ? updatedAt
                : (updatedAt is Timestamp)
                    ? updatedAt.toDate()
                    : DateTime.fromMillisecondsSinceEpoch(0),
            imageUrl: remote.imageUrl,
          );
        })
        .toList();
  }

  @override
  Stream<List<PostModel>> watchPosts({int limit = 20}) {
    return remoteDataSource.watchPosts(limit: limit).map(
      (remotePosts) => remotePosts
          .map((remote) {
            final updatedAt = remote.updatedAt;
            final createdAt = remote.createdAt;

            return PostModel(
              id: remote.id,
              title: remote.title,
              content: remote.content,
              authorId: remote.authorId,
              authorName: remote.authorName,
              createdAt: (createdAt is DateTime)
                  ? createdAt
                  : (createdAt is Timestamp)
                      ? createdAt.toDate()
                      : DateTime.fromMillisecondsSinceEpoch(0),
              updatedAt: (updatedAt is DateTime)
                  ? updatedAt
                  : (updatedAt is Timestamp)
                      ? updatedAt.toDate()
                      : DateTime.fromMillisecondsSinceEpoch(0),
              imageUrl: remote.imageUrl,
            );
          })
          .toList(),
    );
  }

  @override
  Future<PostModel> getPostById(String id) async {
    final remote = await remoteDataSource.fetchPostById(id);
    if (remote == null) {
      throw Exception('Post not found');
    }

    final updatedAt = remote.updatedAt;
    final createdAt = remote.createdAt;

    return PostModel(
      id: remote.id,
      title: remote.title,
      content: remote.content,
      authorId: remote.authorId,
      authorName: remote.authorName,
      createdAt: (createdAt is DateTime)
          ? createdAt
          : (createdAt is Timestamp)
              ? createdAt.toDate()
              : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: (updatedAt is DateTime)
          ? updatedAt
          : (updatedAt is Timestamp)
              ? updatedAt.toDate()
              : DateTime.fromMillisecondsSinceEpoch(0),
      imageUrl: remote.imageUrl,
    );
  }

  @override
  Future<String> createPost({required String title, required String content}) async {
    return remoteDataSource.createPost(title: title, content: content);
  }

  @override
  Future<void> updatePost(PostModel post) async {
    await remoteDataSource.updatePost(
      id: post.id,
      title: post.title,
      content: post.content,
    );
  }

  @override
  Future<void> deletePost(String id) async {
    await remoteDataSource.deletePost(id);
  }
}
