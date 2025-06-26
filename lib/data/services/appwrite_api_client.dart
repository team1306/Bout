import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:bout/data/services/appwrite_client.dart';
import 'package:logging/logging.dart';

class AppwriteApiClient implements ApiClient {
  final AppwriteClient _client;
  late final Databases _databases;

  final String _databaseId = "6847862e001b99285359";
  final String _collectionId = "6847863f001d10258694";
  
  final _log = Logger('AppwriteApiClient');
  
  AppwriteApiClient(AppwriteClient client) : _client = client {
    _databases = Databases(_client.client);
  }

  @override
  Future<Map<String, dynamic>> fetchMatchData(
    int matchType,
    int matchNumber,
    int robotNumber,
  ) async {
    try {
      final list = await tryGetMatch(matchNumber, robotNumber, matchType);
      _log.fine("Got document list.");
      if(list.total != 1) return Future.error(ArgumentError("Valid document not found"));
      
      return list.documents[0].data as Map<String, int>;
    } on AppwriteException catch (e){
      return Future.error(e);
    }
  }

  @override
  Future<void> pushMatchData(Map<String, dynamic> values, bool force) async {
    try {
      if(!force){
        final list = await tryGetMatch(values["info.match"], values["info.robot"], values["info.type"]);
        if(list.total > 0) return Future.error(ArgumentError("Match with robot already exists"));
      }
      
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: ID.unique(),
        data: values,
      );
      _log.fine("Pushed match data");
    } on AppwriteException catch (e) {
      return Future.error(e);
    }
  }
  
  Future<DocumentList> tryGetMatch(int matchNumber, int robotNumber, int matchType) async{
    final list = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _collectionId,
      queries: [
        Query.equal("info.match", matchNumber),
        Query.equal("info.robot", robotNumber),
        Query.equal("info.type", matchType),
      ],
    );
    _log.fine("Got document list.");
    return list;
  }
}
