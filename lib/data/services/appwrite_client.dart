import 'package:appwrite/appwrite.dart';

class AppwriteClient {
  late Client _client;

  Client get client => _client;

  AppwriteClient() {
    _client =
        Client(selfSigned: true)
          ..setEndpoint("https://nyc.cloud.appwrite.io/v1")
          ..setProject("badgerbets2");
  }
}
