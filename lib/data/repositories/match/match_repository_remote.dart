import 'dart:collection';

import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:bout/data/repositories/match/match_type.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:bout/data/services/auth/auth_client.dart';
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
  void clearAllValues() {
    _valueCache.clear();
    _notes = "";
  }

  @override
  Future<void> pullMatchData(int robot, int match, int matchType) async {

    final result = await _apiClient.fetchMatchData(matchType, match, robot);
    _log.fine("Pulled match data for match ${MatchType.getName(matchType)} $match, robot $robot: $result");

    _notes = result.remove("notes");
    try {
      _valueCache.clear();
      _valueCache.addAll(Map<String, int>.fromEntries(result
          .entries.where((e) => e is int)
          .map((e) => MapEntry(e.key, e.value as int))));
    } catch (e) {
      _log.fine("Error loading match data");
      return Future.error(e);
    }
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

  @override
  Future<void> putCustomData(Map<String, int> data) async {
    _valueCache.clear();
    _valueCache.addAll(data);
  }
}
