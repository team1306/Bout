///Stores data about past matches scouted
abstract class HistoryRepository {
  Future<Set<Map<String, dynamic>>> fetchHistory();
  Future<Set<Map<String, dynamic>>> getServerMatches();
  Future<Set<Map<String, dynamic>>> getCachedMatches();
}