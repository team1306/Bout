import 'package:appwrite/appwrite.dart';
import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:bout/utils/null_exception.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:logging/logging.dart';

class ScoutViewModel {
  
  static const defaultValues = {
    "auto.leave": 0,
    "auto.l1" : 0,
    "auto.l2" : 0,
    "auto.l3" : 0,
    "auto.l4" : 0,
    "auto.process" : 0,
    "end.climb" : 0,
    "end.role" : 0,
    "end.driver" : 1,
    "info.match" : 0,
    "info.robot" : 0,
    "teleop.l1" : 0,
    "teleop.l2" : 0,
    "teleop.l3" : 0,
    "teleop.l4" : 0,
    "teleop.process" : 0,
    "teleop.net" : 0
  };
  
  ScoutViewModel(MatchRepository scoutRepository, CacheRepository cacheRepository)
    : _matchRepository = scoutRepository, _cacheRepository = cacheRepository {
    notesUpdate = Command.createAsync(_updateNotes, initialValue: "");
    submitMatchData = Command.createAsyncNoParam(_submitMatchData, initialValue: false);

    _matchRepository.putCustomData(defaultValues);
    _matchRepository.setNotes("");
  }

  ScoutViewModel.loadMatch(MatchRepository matchRepository, CacheRepository cacheRepository, String? robot, String? match, String? type)
    : _matchRepository = matchRepository, _cacheRepository = cacheRepository {
    notesUpdate = Command.createAsync(_updateNotes, initialValue: "");
    submitMatchData = Command.createAsyncNoParam(_submitMatchData, initialValue: false);

    if (robot == null || match == null || type == null) throw NullException(message: "Scout page tried load from incomplete match identifiers");
    matchRepository.pullMatchData(int.parse(robot), int.parse(match), int.parse(type));
    _log.fine("Loaded scout page from existing match");
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
