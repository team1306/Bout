///Data source for all things scouting
abstract class MatchRepository {
  ///Get cached score
  Future<int?> getValue(String identifier);

  ///Set cached score
  Future<void> setValue(String identifier, int value);

  ///Pulls match data and updates the repository to match
  Future<void> pullMatchData();

  ///Puts match data to storage
  Future<void> pushMatchData(bool force);
  
  ///Get cached notes
  Future<String> getNotes();
  
  ///Set cached notes
  Future<void> setNotes(String notes);
  
  Future<Map<String, dynamic>> getMatch();
}
