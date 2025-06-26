abstract class CacheRepository {
  ///Push any cached matches to appwrite
  ///Force pushing overwrites existing match data
  Future<void> pushMatches(bool force);

  ///Add a match to the cache for later pushing
  Future<void> addCachedMatch(Map<String, dynamic> match);

  ///Clears the cache
  Future<void> clearCache();

  ///Gets the cache
  Future<Set<Map<String, dynamic>>> get cache;
}
