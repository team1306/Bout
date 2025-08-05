import 'package:appwrite/appwrite.dart';
import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

class ScoutViewModel {
  ScoutViewModel(MatchRepository scoutRepository, CacheRepository cacheRepository)
    : _matchRepository = scoutRepository, _cacheRepository = cacheRepository {
    notesUpdate = Command.createAsync(_updateNotes, initialValue: "");
    submitMatchData = Command.createAsyncNoParam(_submitMatchData, initialValue: false);
  }

  final MatchRepository _matchRepository;
  final CacheRepository _cacheRepository;

  final _log = Logger('ScoutViewModel');

  late final Command<String?, String> notesUpdate;
  late final Command<void, bool> submitMatchData;
  
  Future<bool> _submitMatchData() async{
    _log.fine("Submitted match data");
    try {
      await _matchRepository.pushMatchData(false);
      _log.fine("Successfully sent request to repository");
      return true;
    } on AppwriteException{
      _cacheRepository.addCachedMatch(await _matchRepository.getMatch());
      _log.fine("Failed to push match data. Submitting to cache.");
      return false;
    }
  }

  Future<String> _updateNotes(String? notes) async {
    if (notes != null) await _matchRepository.setNotes(notes);
    return await _matchRepository.getNotes();
  }

  Future<int> _updateChangeValue(String identifier, int? amount) async {
    if (amount != null) await _changeValue(identifier, amount);
    return await _retrieveValue(identifier);
  }

  Future<void> _changeValue(String identifier, int amount) async {
    final value = await _retrieveValue(identifier);
    return await _setValue(identifier, value + amount);
  }

  Future<void> _setValue(String identifier, int value) {
    return _matchRepository.setValue(identifier, value)
      ..then((_) => _log.fine("Set $identifier value to $value"));
  }

  Future<int> _updateValue(String identifier, int? value) async {
    if (value != null) await _setValue(identifier, value);
    return await _retrieveValue(identifier);
  }

  ///Produces a side effect. If the key does not exist, it will create a new one with a value of 0
  Future<int> _retrieveValue(String identifier) async {
    final value = await _matchRepository.getValue(identifier);
    if (value == null) await _setValue(identifier, 0);
    _log.fine("Got $identifier value: $value");
    return value ?? 0;
  }

  Command<int?, int> createStateUpdate(String identifier) =>
      Command.createAsync(
        (value) => _updateValue(identifier, value),
        initialValue: 0,
      );

  Command<int?, int> createStateChange(String identifier) =>
      Command.createAsync(
        (value) => _updateChangeValue(identifier, value),
        initialValue: 0,
      );

  Command<int, void> createStateSet(String identifier) =>
      Command.createAsyncNoResult((value) => _setValue(identifier, value));

  Command<void, int> createStateRetrieve(String identifier) =>
      Command.createAsyncNoParam(
        () => _retrieveValue(identifier),
        initialValue: 0,
      );
}
