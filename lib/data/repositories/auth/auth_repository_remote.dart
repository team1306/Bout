// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bout/data/services/auth/auth_client.dart';
import 'package:bout/data/services/models/login_request/login_request.dart';
import 'package:bout/data/services/models/login_response/login_response.dart';
import 'package:bout/data/services/shared_preferences_service.dart';
import 'package:logging/logging.dart';

import 'auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required AuthClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _authApiClient = authApiClient,
       _sharedPreferencesService = sharedPreferencesService;

  final AuthClient _authApiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  final _log = Logger('AuthRepositoryRemote');

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    _isAuthenticated = await _authApiClient.isAuthenticated();
    return _isAuthenticated ?? false;
  }

  @override
  Future<void> login({required String email, required String password}) async {
    LoginResponse result = await _authApiClient.login(
      LoginRequest(email: email, password: password),
    );
    _log.info('User logged in');
    _isAuthenticated = true;
    notifyListeners();
    return await _sharedPreferencesService.saveSession(
      result.token,
      result.userId,
    );
  }

  @override
  Future<void> logout() async {
    _log.info('User logged out');
    await _authApiClient.logout();
    // Clear authenticated status
    _isAuthenticated = false;
    notifyListeners();
  }

  @override
  Future<void> createAccount({
    required String username,
    required String email,
    required String password,
  }) {
    return _authApiClient.signUp(
      username,
      LoginRequest(email: email, password: password),
    );
  }
}
