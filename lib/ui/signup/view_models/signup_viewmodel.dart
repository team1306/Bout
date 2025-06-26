import 'package:bout/data/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class SignupViewModel extends ChangeNotifier {
  SignupViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    signup = Command.createAsyncNoResult(_signup);
  }

  final AuthRepository _authRepository;

  late Command<(String username, String email, String password), void> signup;

  Future<void> _signup(
    (String username, String email, String password) credentials,
  ) {
    return _authRepository.createAccount(
      username: credentials.$1,
      email: credentials.$2,
      password: credentials.$3,
    );
  }
}
