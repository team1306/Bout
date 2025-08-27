import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:bout/data/services/auth/auth_client.dart';
import 'package:logging/logging.dart';

import 'history_repository.dart';

class HistoryRepositoryRemote extends HistoryRepository {

  final AuthClient _authClient;
  final ApiClient _apiClient;
  final CacheRepository _cacheRepository;

  final _log = Logger("HistoryRepositoryRemote");

  HistoryRepositoryRemote(AuthClient authClient, ApiClient apiClient, CacheRepository cacheRepository)
      : _authClient = authClient, _apiClient = apiClient, _cacheRepository = cacheRepository;

  @override
  Future<Set<Map<String, dynamic>>> fetchHistory() async {
    Set<Map<String, dynamic>> matches = await getCachedMatches();
    matches.addAll(await getServerMatches());

    _log.fine("Fetched History");
    return matches;
  }

  @override
  Future<Set<Map<String, dynamic>>> getCachedMatches() async {
    Set<Map<String, dynamic>> cache = await _cacheRepository.getCache();
    String userId = await _authClient.getCurrentUserId();
    cache.retainWhere((match) => match["info.scouterId"] == userId);
    _log.fine("Got cached matches: $cache");
    return Future.value(cache);
  }

  @override
  Future<Set<Map<String, dynamic>>> getServerMatches() async {
    Set<Map<String, dynamic>> matches = await _apiClient.fetchAllMatchDataFromScouter(await _authClient.getCurrentUserId());
    _log.fine("Got server matches: $matches");
    return Future.value(matches);
  }

}