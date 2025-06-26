// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'auth_repository.dart';

class AuthRepositoryDev extends AuthRepository {
  /// User is always authenticated in dev scenarios
  @override
  Future<bool> get isAuthenticated => Future.value(true);

  /// Login is always successful in dev scenarios
  @override
  Future<void> login({required String email, required String password}) async {}

  /// Logout is always successful in dev scenarios
  @override
  Future<void> logout() async {
    return;
  }

  @override
  Future<void> createAccount({
    required String username,
    required String email,
    required String password,
  }) async {}
}
