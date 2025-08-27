import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bout/data/repositories/match/match_type.dart';
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
      Document? document = await getMatchDocument(matchNumber, robotNumber, matchType);
      if (document == null) return Future.error("No document found.");
      _log.fine("Successfully fetched match data");
      return document.data;
    } catch (e){
      return Future.error(e);
    }
  }

  @override
  Future<Set<Map<String, dynamic>>> fetchAllMatchDataFromScouter(String scouterId) async {
    try {
      DocumentList documents = await getMatchesFromScouter(scouterId);

      return documents.documents.map((doc) => doc.data).toSet();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> pushMatchData(Map<String, dynamic> values, bool force) async {
    try {
      if(!force && await getMatchDocument(values["info.match"], values["info.robot"], values["info.type"]) != null){
          return Future.error(ArgumentError("Match with robot already exists"));
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
  
  Future<Document?> getMatchDocument(int matchNumber, int robotNumber, int matchType) async {
    _log.fine("Getting all documents from appwrite for ${MatchType.getName(matchType)} $matchNumber robot $robotNumber...");
    final list = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _collectionId,
      queries: [
        Query.equal("info.match", matchNumber),
        Query.equal("info.robot", robotNumber),
        Query.equal("info.type", matchType),
      ],
    );

    _log.fine("DEBUG: Document list size:  ${list.documents.length}");

    if (list.documents.length > 1) return Future.error("Too many documents for match");
    if (list.documents.isEmpty) return null;

    Document document = list.documents[0];
    return document;
  }

  Future<DocumentList> getMatchesFromScouter(String scouterId) async {
    DocumentList documents = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal("info.scouterId", scouterId)
        ],
    );
    _log.fine("Got documents.");
    return documents;
  }

  @override
  Future<void> updateMatchData(int originalRobot, int originalMatch, int originalType, Map<String, dynamic> values) async {
    try {
      _log.fine("Retrieving document...");
      Document? doc = await getMatchDocument(originalMatch, originalRobot, originalType);
      if (doc == null) return Future.error("Document not found");
      _log.fine("Successfully retrieved document.");

      try {
        _log.fine("Updating document...");
        await _databases.updateDocument(
            databaseId: _databaseId,
            collectionId: _collectionId,
            documentId: doc.$id,
            data: values
        );
        _log.fine("Successfully updated document.");
      } catch (e) {
        return Future.error(e);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
