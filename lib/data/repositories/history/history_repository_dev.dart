import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/repositories/history/history_repository.dart';

class HistoryRepositoryDev extends HistoryRepository {

  final CacheRepository _cacheRepository;

  HistoryRepositoryDev(CacheRepository cacheRepository)
      : _cacheRepository = cacheRepository;

  @override
  Future<Set<Map<String, dynamic>>> fetchHistory() async {
    Set<Map<String, dynamic>> matches = await getCachedMatches();
    matches.addAll(await getServerMatches());

    return matches;
  }

  @override
  Future<Set<Map<String, dynamic>>> getCachedMatches() {
    return _cacheRepository.cache;
  }

  @override
  Future<Set<Map<String, dynamic>>> getServerMatches() {
    return Future.value({});
  }

}