import 'package:bout/data/repositories/user/user_repository.dart';
import 'package:bout/domain/models/user/user.dart';

class UserRepositoryDev extends UserRepository {
  @override
  Future<User> getUser() async {
    return User(name: "Test User");
  }
}
