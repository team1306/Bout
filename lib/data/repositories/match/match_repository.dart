///Data source for all things scouting
abstract class MatchRepository {
  ///Get cached score
  Future<int?> getValue(String identifier);

  ///Set cached score
  Future<void> setValue(String identifier, int value);

  ///Pulls match data and updates the repository to match
  Future<void> pullMatchData(int robot, int match, int matchType);

  ///Puts match data to storage
  Future<void> pushMatchData(bool force);
  
  Future<void> putCustomData(Map<String, int> data);
  
  ///Get cached notes
  Future<String> getNotes();

  void clearAllValues();
  
  ///Set cached notes
  Future<void> setNotes(String notes);
  
  Future<Map<String, dynamic>> getMatch();

  Future<void> updateMatchData(int originalRobot, int originalMatch, int originalType);
}
