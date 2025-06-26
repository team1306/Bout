// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bout/data/repositories/auth/auth_repository.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

class LoginViewModel {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command.createAsyncNoResult(_login);
  }

  final AuthRepository _authRepository;
  final _log = Logger('LoginViewModel');

  late Command<(String email, String password), void> login;

  Future<void> _login((String email, String password) params) async {
    final result = await _authRepository.login(
      email: params.$1,
      password: params.$2,
    );
    _log.fine("Logged in");
    return result;
  }
}
