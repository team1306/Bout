class MatchType{
  static const int practice = 0;
  static const int qualifier = 1;

  static String getName(int matchType) {
    switch(matchType) {
      case practice: return "Practice";
      case qualifier: return "Qualifier";
      default: throw Exception("Match type $matchType not recognized");
    }
  }
}
