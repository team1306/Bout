// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bout/data/repositories/auth/auth_repository.dart';
import 'package:bout/data/repositories/user/user_repository.dart';
import 'package:bout/domain/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository {
    load = Command.createAsyncNoParamNoResult(_load)..execute();
    logout = Command.createAsyncNoParamNoResult(_logout);
  }

  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  
  late final Command<void, void> load;
  late Command<void, void> logout;

  final _log = Logger('HomeViewModel');

  User? _user;

  User? get user => _user;

  Future<void> _logout() async {
    await _authRepository.logout();
    _log.fine("Logged out");
  }

  Future<void> _load() async {
    final userResult = await _userRepository.getUser();
    _user = userResult;
    _log.fine("Got user");
    notifyListeners();
    return;
  }
}
