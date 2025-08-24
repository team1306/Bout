import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bout/data/services/appwrite_client.dart';
import 'package:bout/data/services/auth/auth_client.dart';
import 'package:bout/data/services/models/login_request/login_request.dart';
import 'package:bout/data/services/models/login_response/login_response.dart';
import 'package:bout/domain/models/user/user.dart' as user_model;
import 'package:logging/logging.dart';

class AppwriteAuthClient extends AuthClient {
  final AppwriteClient appwriteClient;
  late Account _account;

  final _log = Logger("AppwriteClient");

  AppwriteAuthClient({client, required this.appwriteClient}) {
    _account = Account(appwriteClient.client);
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: request.email,
        password: request.password,
      );
      return LoginResponse(token: session.secret, userId: session.userId);
    } on AppwriteException catch (e) {
      _log.warning("Failed to Authenticate", e);
      return Future.error(e);
    }
  }

  @override
  Future<user_model.User> getCurrentUser() async {
    try {
      User user = await _account.get();
      
      return user_model.User(name: user.name);
    } on AppwriteException catch (e) {
      _log.warning("Failed to get current user", e);
      return Future.error(e);
    }
  }

  // Check if user is authenticated
  @override
  Future<bool> isAuthenticated() async {
    try {
      await _account.get();
      return true; // User is authenticated
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        return false; // User is not authenticated
      }
      rethrow; // Other error occurred
    }
  }

  @override
  Future<void> signUp(String name, LoginRequest request) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: request.email,
        password: request.password,
        name: name
      );
    } on AppwriteException catch (e) {
      _log.warning("Failed to sign user up", e);
      return Future.error(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: "current");
    } on AppwriteException catch (e) {
      _log.warning("Failed to logout", e);
      return Future.error(e);
    }
  }

  @override
  Future<String> getCurrentUserId() async {
    User user = await _account.get();
    final userId = user.$id;
    _log.fine("Got user id: $userId");
    return userId;
  }
}
