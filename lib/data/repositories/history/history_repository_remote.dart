import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:bout/data/services/auth/appwrite_auth_client.dart';

import 'history_repository.dart';

class HistoryRepositoryRemote extends HistoryRepository {

  final AppwriteAuthClient _authClient;
  final ApiClient _apiClient;
  final CacheRepository _cacheRepository;

  HistoryRepositoryRemote(AppwriteAuthClient authClient, ApiClient apiClient, CacheRepository cacheRepository)
      : _authClient = authClient, _apiClient = apiClient, _cacheRepository = cacheRepository;

  @override
  Future<Set<Map<String, dynamic>>> fetchHistory() async {
    Set<Map<String, dynamic>> matches = await getCachedMatches();
    matches.addAll(await getServerMatches());
    matches.retainWhere((match) => match["scouter"] == _authClient.getCurrentUser()); //filter to only matches this user scouted

    return matches;
  }

  @override
  Future<Set<Map<String, dynamic>>> getCachedMatches() {
    return _cacheRepository.cache;
  }

  @override
  Future<Set<Map<String, dynamic>>> getServerMatches() {
    return _apiClient.fetchAllMatchData();
  }

  @override
  Future<Set<Map<String, dynamic>>> retrieveMatchHistory() async {
    return fetchHistory();
  }

}