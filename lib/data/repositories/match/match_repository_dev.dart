import 'dart:collection';

import 'package:bout/data/repositories/match/match_repository.dart';

class MatchRepositoryDev extends MatchRepository {
  MatchRepositoryDev() : _valueCache = HashMap();

  final Map<String, int> _valueCache;
  String _notes = "";

  @override
  Future<int?> getValue(String identifier) async {
    return _valueCache[identifier];
  }

  @override
  Future<void> pullMatchData() async {
    _valueCache.clear();
  }

  @override
  Future<void> pushMatchData(bool force) async {}

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
