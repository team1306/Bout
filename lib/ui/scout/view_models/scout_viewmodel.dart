import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:bout/ui/scout/widgets/incrementer.dart';
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
    "auto.net" : 0,
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

    _matchRepository.putCustomData(defaultValues);
    _matchRepository.setNotes("");
    _createCommonValues();

    isUpdateMode = false;
  }

  ScoutViewModel.loadMatch(MatchRepository matchRepository, CacheRepository cacheRepository, String? robot, String? match, String? type)
    : _matchRepository = matchRepository, _cacheRepository = cacheRepository {

    if (robot == null || match == null || type == null) throw NullException(message: "Scout page tried load from incomplete match identifiers");
    int robotNum = int.parse(robot), matchNum = int.parse(match), matchType = int.parse(type);
    matchRepository.pullMatchData(robotNum, matchNum, matchType).then((_) => _reinvokeGetCommands());
    _log.fine("Loaded scout page from existing match");

    _createCommonValues();

    isUpdateMode = true;
    _originalMatch = matchNum;
    _originalRobot = robotNum;
    _originalType = matchType;
  }
  
  void _reinvokeGetCommands(){
    for(var value in _getCommands.values){
      value.execute();
    }
  }
  
  late final Map<String, Command<void, int?>> _getCommands;
  late final Map<String, Command<int, void>> _setCommands;
  late final Map<String, Command<int, void>> _changeCommands;

  final MatchRepository _matchRepository;
  final CacheRepository _cacheRepository;

  final _log = Logger('ScoutViewModel');

  late final Command<void, String?> notesGet;
  late final Command<String, void> notesSet;

  late final Command<void, bool> submitMatchData;

  late final bool isUpdateMode;
  late final int? _originalRobot;
  late final int? _originalMatch;
  late final int? _originalType;
  
  void _createCommonValues() {
    submitMatchData = Command.createAsyncNoParam(_submitMatchData, initialValue: false);
    notesGet = Command.createAsyncNoParam(_getNotes, initialValue: "");
    notesSet = Command.createAsyncNoResult(_setNotes);

    _getCommands = createGetCommands();
    _changeCommands = createChangeCommands();
    _setCommands = createSetCommands();
  }
  
  Future<bool> _submitMatchData() async{
    _log.fine("Submitted match data");
    if (!isUpdateMode) {
      try {
        await _matchRepository.pushMatchData(false);
        _log.fine("Successfully sent submit request to repository");
        return true;
      } catch (e) {
        _cacheRepository.addCachedMatch(await _matchRepository.getMatch());
        _log.fine("Failed to push match data. Submitting to cache.");
        return false;
      }
    } else {
      try {
        await _matchRepository.updateMatchData(_originalRobot!, _originalMatch!, _originalType!);
        _log.fine("Successfully sent update request to repository");
        return true;
      } catch (e) {
        _log.fine("Failed to update match data. Try again later.");
        return false;
      }
    }
  }
  
  Future<String?> _getNotes(){
    return _matchRepository.getNotes();
  }
  
  Future<void> _setNotes(String notes){
    return _matchRepository.setNotes(notes);
  }

  Future<void> _changeValue(String identifier, int amount) async {
    final value = await _getValue(identifier);
    return await _setValue(identifier, value! + amount);
  }

  Future<void> _setValue(String identifier, int value) {
    return _matchRepository.setValue(identifier, value)
      ..then((_) => _log.fine("Set $identifier value to $value"));
  }

  Future<int?> _getValue(String identifier) async {
    final value = await _matchRepository.getValue(identifier);
    _log.fine("Got $identifier value: $value");
    return value;
  }
  
  Command<void, int?> getRetrievalCommand(String identifier){
    return _getCommands[identifier]!;
  }

  Command<int, void> getSetCommand(String identifier){
    return _setCommands[identifier]!;
  }

  Command<int, void> getChangeCommand(String identifier){
    return _changeCommands[identifier]!;
  }

  Map<String, Command<void, int?>> createGetCommands(){
    Map<String, Command<void, int?>> map = {};
    defaultValues.forEach((identifier, value) {
      map[identifier] = createGetCommand(identifier, value);
    });
    return map;
  }

  Map<String, Command<int, void>> createSetCommands(){
    Map<String, Command<int, void>>  map = {};
    defaultValues.forEach((identifier, value) {
      map[identifier] = createSetCommand(identifier);
    });
    return map;
  }

  Map<String, Command<int, void>> createChangeCommands(){
    Map<String, Command<int, void>>  map = {};
    defaultValues.forEach((identifier, value) {
      map[identifier] = createChangeCommand(identifier);
    });
    return map;
  }
  
  Command<int, void> createChangeCommand(String identifier) => Command.createAsyncNoResult((value) => _changeValue(identifier, value));
  Command<void, int?> createGetCommand(String identifier, int initialValue) => Command.createAsyncNoParam(() => _getValue(identifier), initialValue: initialValue);
  Command<int, void> createSetCommand(String identifier) => Command.createAsyncNoResult((value) => _setValue(identifier, value));
  
  Incrementer buildIncrementer(String title, String identifier){
    return Incrementer(title: title, changeState: getChangeCommand(identifier), getState: getRetrievalCommand(identifier));
  }
}
