import 'package:bout/domain/models/user/user.dart';

/// Data source for a user
abstract class UserRepository {
  /// Get current user
  Future<User?> getUser();
}
