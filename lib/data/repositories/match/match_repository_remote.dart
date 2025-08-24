import 'dart:collection';

import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:bout/data/services/auth/auth_client.dart';
import 'package:bout/utils/null_exception.dart';
import 'package:logging/logging.dart';

class MatchRepositoryRemote extends MatchRepository {
  MatchRepositoryRemote(ApiClient apiClient, AuthClient authClient)
    : _apiClient = apiClient, _authClient = authClient,
      _valueCache = HashMap();

  final ApiClient _apiClient;
  final AuthClient _authClient;
  final Map<String, int> _valueCache;

  final _log = Logger("MatchRepositoryRemote");

  String _notes = "";

  @override
  Future<int?> getValue(String identifier) async {
    return _valueCache[identifier] ?? 0;
  }

  @override
  Future<void> pullMatchData(int match, int robot, int matchType) async {

    final result = await _apiClient.fetchMatchData(matchType, match, robot);

    _notes = result.remove("notes");

    _valueCache.clear();
    _valueCache.addAll(result as Map<String, int>);
  }

  @override
  Future<void> pushMatchData(bool force) async {
    try {
      final matchData = await getMatch();
      _log.fine("Submitting $matchData");
      _apiClient.pushMatchData(matchData, force);
      _log.fine("Successfully sent request to api client");
      return;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> setValue(String identifier, int value) async {
    _valueCache[identifier] = value;
  }

  @override
  Future<String> getNotes() async {
    return _notes;
  }

  @override
  Future<void> setNotes(String notes) async {
    _notes = notes;
  }

  @override
  Future<Map<String, dynamic>> getMatch() async {
    final data = Map<String, dynamic>.from(_valueCache);

    data["info.type"] = 0; //manually setting to qualifier
    data["notes"] = _notes;
    data["info.scouterId"] = await _authClient.getCurrentUserId();
    return data;
  }
}
