import 'package:bout/data/repositories/user/user_repository.dart';
import 'package:bout/data/services/auth/auth_client.dart';
import 'package:bout/domain/models/user/user.dart';

class UserRepositoryRemote extends UserRepository {
  UserRepositoryRemote({required AuthClient authClient})
    : _authClient = authClient;

  final AuthClient _authClient;

  @override
  Future<User> getUser() {
    return _authClient.getCurrentUser();
  }
}
