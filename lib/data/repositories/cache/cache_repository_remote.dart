import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:logging/logging.dart';

class CacheRepositoryRemote extends CacheRepository {
  CacheRepositoryRemote(ApiClient client) : _client = client;

  final ApiClient _client;
  final _log = Logger('CacheRepositoryRemote');
  final Set<Map<String, dynamic>> _cache = <Map<String, dynamic>>{};

  @override
  Future<void> addCachedMatch(Map<String, dynamic> match) async {
    _cache.add(match);
    _log.fine("${match["info.type"]} Match ${match["info.match"]} with the robot ${match["info.robot"]} added to cache");
  }

  @override
  Future<void> clearCache() async {
    _cache.clear();
    _log.fine("Match cache cleared");
  }

  @override
  Future<void> pushMatches(bool force) async {
    for (final match in _cache) {
      await _client.pushMatchData(match, force);
      _log.fine("${match["info.type"]} Match ${match["info.match"]} with the robot ${match["info.robot"]} pushed");
    }
  }

  @override
  Future<Set<Map<String, dynamic>>> getCache() async {
    return _cache.map((value) => Map<String, dynamic>.from(value)).toSet();
  }
}
