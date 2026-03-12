import '../entity/local/post_entity_local.dart';
import '../entity/remote/post_entity_remote.dart';

class PostMapper {
  PostMapper._();

  static PostEntityLocal toLocal(PostEntityRemote remote) {
    return PostEntityLocal(data: remote.data);
  }

  static PostEntityRemote toRemote(PostEntityLocal local) {
    return PostEntityRemote(data: local.data);
  }
}
