abstract class ApiClient {
  Future<Map<String, dynamic>> fetchMatchData(
    int matchType,
    int matchNumber,
    int robotNumber,
  );

  Future<void> pushMatchData(
    Map<String, dynamic> values, bool force
  );

  Future<Set<Map<String, dynamic>>> fetchAllMatchData();
}
