import 'package:bout/data/repositories/cache/cache_repository.dart';

class CacheRepositoryDev extends CacheRepository{
  
  final Set<Map<String, dynamic>> _cache = <Map<String, dynamic>>{};
  
  @override
  Future<void> addCachedMatch(Map<String, dynamic> match) async{
    _cache.add(match);
  }

  @override
  Future<Set<Map<String, dynamic>>> get cache => Future.value(_cache);

  @override
  Future<void> clearCache() async{
    _cache.clear();
  }

  @override
  Future<void> pushMatches(bool force) async {
    
  }
}