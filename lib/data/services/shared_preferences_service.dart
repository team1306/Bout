// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _tokenKey = 'TOKEN';
  static const _userIDKey = "USER_ID";
  static const _matchDataKey = "MATCH_DATA";
  final _log = Logger('SharedPreferencesService');

  Future<(String?, String?)> fetchSession() async {
    try {
      final sharedPreferences = SharedPreferencesAsync();
      _log.finer('Got token from SharedPreferences');
      final token = await sharedPreferences.getString(_tokenKey);
      final userId = await sharedPreferences.getString(_userIDKey);
      return (token, userId);
    } on TypeError catch (e) {
      _log.warning('Failed to get token', e);
      rethrow;
    }
  }

  Future<void> saveSession(String? token, String? userid) async {
    try {
      final sharedPreferences = SharedPreferencesAsync();
      if (token == null) {
        _log.finer('Removed token');
        await sharedPreferences.remove(_tokenKey);
      } else {
        _log.finer('Replaced token');
        await sharedPreferences.setString(_tokenKey, token);
      }
      if (userid == null) {
        _log.finer('Removed user id ');
        await sharedPreferences.remove(_userIDKey);
      } else {
        _log.finer('Replaced user id');
        await sharedPreferences.setString(_userIDKey, userid);
      }

      return;
    } on Exception catch (e) {
      _log.warning('Failed to set token or user id', e);
      rethrow;
    }
  }

  Future<String?> fetchMatchData() async {
    try {
      final sharedPreferences = SharedPreferencesAsync();
      _log.finer('Got match data from SharedPreferences');
      return await sharedPreferences.getString(_matchDataKey);
    } on Exception catch (e) {
      _log.warning('Failed to get match data', e);
      rethrow;
    }
  }

  Future<void> saveMatchData(String? matchData) async {
    try {
      final sharedPreferences = SharedPreferencesAsync();
      if (matchData == null) {
        _log.finer('Removed match data');
        await sharedPreferences.remove(_matchDataKey);
      } else {
        _log.finer('Replaced match data');
        await sharedPreferences.setString(_matchDataKey, matchData);
      }
      return;
    } on Exception catch (e) {
      _log.warning('Failed to set match data', e);
      rethrow;
    }
  }
}
