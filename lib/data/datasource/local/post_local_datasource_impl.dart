import 'post_local_datasource.dart';

class PostLocalDataSourceImpl implements PostLocalDataSource {
  @override
  Future<void> cachePostData(Map<String, dynamic> data) async {
    // TODO: Store post data locally.
  }

  @override
  Future<Map<String, dynamic>?> getCachedPostData() async {
    // TODO: Retrieve cached post data.
    return null;
  }
}
