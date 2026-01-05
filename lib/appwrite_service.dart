import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static Client client = Client()
    ..setEndpoint('https://nyc.cloud.appwrite.io/v1')
    ..setProject('695a303b0015f30c973c');

  static Databases databases = Databases(client);
  static Account account = Account(client);

  static const String databaseId = '12345';
  static const String signupCollectionId = 'signup';
}
