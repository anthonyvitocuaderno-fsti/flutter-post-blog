import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/exceptions/api_exception.dart';
import '../../../core/services/firestore_service.dart';
import '../../../service/firebase_auth_service.dart';
import '../../entity/remote/post_entity_remote.dart';
import 'post_remote_datasource.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  static const _collection = 'posts';

  final FirebaseAuthService authService;

  PostRemoteDataSourceImpl({required this.authService});

  CollectionReference<Map<String, dynamic>> get _postsRef =>
      FirestoreService.instance.collection(_collection);

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      FirestoreService.instance.collection('users');

  String _currentUserId() {
    final uid = authService.currentUser?.uid;
    if (uid == null) {
      throw ApiException('User not authenticated.');
    }
    return uid;
  }

  Future<String> _currentUserName() async {
    final uid = _currentUserId();
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return '';
    return (doc.data()?['name'] as String?) ?? '';
  }

  @override
  Future<List<PostEntityRemote>> fetchPosts({
    Timestamp? startAfter,
    int limit = 20,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _postsRef.orderBy('updatedAt', descending: true);

      if (startAfter != null) {
        query = query.startAfter([startAfter]);
      }

      final snapshot = await query.limit(limit).get();

      return snapshot.docs
          .map((doc) => PostEntityRemote.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<PostEntityRemote?> fetchPostById(String id) async {
    try {
      final doc = await _postsRef.doc(id).get();
      if (!doc.exists) return null;
      return PostEntityRemote.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<String> createPost({required String title, required String content}) async {
    final uid = _currentUserId();
    final authorName = await _currentUserName();

    try {
      final docRef = await _postsRef.add({
        'title': title,
        'content': content,
        'authorId': uid,
        'authorName': authorName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'imageUrl': null,
      });
      return docRef.id;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> _verifyOwnership(String id) async {
    final uid = _currentUserId();
    final doc = await _postsRef.doc(id).get();
    if (!doc.exists) {
      throw ApiException('Post not found');
    }

    final authorId = doc.data()?['authorId'] as String?;
    if (authorId != uid) {
      throw ApiException('You do not have permission to modify this post.');
    }
  }

  @override
  Future<void> updatePost({
    required String id,
    required String title,
    required String content,
  }) async {
    await _verifyOwnership(id);

    try {
      await _postsRef.doc(id).update({
        'title': title,
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<void> deletePost(String id) async {
    await _verifyOwnership(id);

    try {
      await _postsRef.doc(id).delete();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
