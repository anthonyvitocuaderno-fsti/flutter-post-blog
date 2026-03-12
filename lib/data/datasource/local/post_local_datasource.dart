abstract class PostLocalDataSource {
  Future<void> cachePostData(Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getCachedPostData();
}
