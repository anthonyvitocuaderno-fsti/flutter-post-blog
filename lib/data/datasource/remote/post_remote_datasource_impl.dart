import 'post_remote_datasource.dart';
import 'api_client.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  PostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> fetchPostData() async {
    // TODO: Call API client to get post data.
    return {};
  }
}
