import 'package:bout/data/services/models/login_request/login_request.dart';
import 'package:bout/data/services/models/login_response/login_response.dart';
import 'package:bout/domain/models/user/user.dart';

abstract class AuthClient {
  Future<LoginResponse> login(LoginRequest request);

  Future<void> signUp(String name, LoginRequest request);

  Future<bool> isAuthenticated();
  
  Future<User> getCurrentUser();

  Future<String> getCurrentUserId();

  Future<void> logout();
}
