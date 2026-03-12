import '../entity/local/user_entity_local.dart';
import '../entity/remote/user_entity_remote.dart';

class UserMapper {
  UserMapper._();

  static UserEntityLocal toLocal(UserEntityRemote remote) {
    return UserEntityLocal(
      id: remote.id,
      name: remote.name,
      email: remote.email,
    );
  }

  static UserEntityRemote toRemote(UserEntityLocal local) {
    return UserEntityRemote(
      id: local.id,
      name: local.name,
      email: local.email,
    );
  }
}
