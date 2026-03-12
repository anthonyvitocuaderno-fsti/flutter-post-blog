import '../../core/base/base_repository.dart';
import '../../domain/model/post_model.dart';
import '../../domain/repository/post_repository.dart';

class PostRepositoryImpl extends BaseRepository implements PostRepository {
  final List<PostModel> _posts = [
    PostModel(
      id: '1',
      title: 'Welcome to Flutter Post Blog',
      content: 'This is a sample post. Modify this data to connect to a real backend.',
    ),
    PostModel(
      id: '2',
      title: 'A second post',
      content: 'You can expand this list or hook it up to your API.',
    ),
  ];

  @override
  Future<List<PostModel>> getPosts() async {
    return _posts;
  }

  @override
  Future<PostModel> getPostById(String id) async {
    return _posts.firstWhere((post) => post.id == id);
  }

  @override
  Future<void> updatePost(PostModel post) async {
    final index = _posts.indexWhere((element) => element.id == post.id);
    if (index >= 0) {
      _posts[index] = post;
    }
  }

  @override
  Future<void> deletePost(String id) async {
    _posts.removeWhere((post) => post.id == id);
  }
}
