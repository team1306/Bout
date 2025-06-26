import 'dart:collection';

import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:bout/utils/null_exception.dart';

class MatchRepositoryRemote extends MatchRepository {
  MatchRepositoryRemote(ApiClient apiClient)
    : _apiClient = apiClient,
      _valueCache = HashMap();

  final ApiClient _apiClient;
  final Map<String, int> _valueCache;

  String _notes = "";

  @override
  Future<int?> getValue(String identifier) async {
    return _valueCache[identifier];
  }

  @override
  Future<void> pullMatchData() async {
    //Assume safety since controlled operation
    final match = await getValue("info.match");
    final robot = await getValue("info.robot");
    final matchType = await getValue("info.type");

    if (match == null) {
      return Future.error(NullException(message: "Match cannot be null"));
    }
    if (robot == null) {
      return Future.error(NullException(message: "Robot cannot be null"));
    }
    if (matchType == null) {
      return Future.error(NullException(message: "Match type cannot be null"));
    }

    final result = await _apiClient.fetchMatchData(matchType, match, robot);

    _notes = result.remove("notes");

    _valueCache.clear();
    _valueCache.addAll(result as Map<String, int>);
  }

  @override
  Future<void> pushMatchData(bool force) async {
    return _apiClient.pushMatchData(await getMatch(), force);
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
  Future<Map<String, dynamic>> getMatch() async{
    final data = Map<String, dynamic>.from(_valueCache);
    data["notes"] = _notes;
    return data;
  }
}
