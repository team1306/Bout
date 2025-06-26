import 'package:bout/data/repositories/auth/auth_repository.dart';
import 'package:bout/data/repositories/auth/auth_repository_dev.dart';
import 'package:bout/data/repositories/auth/auth_repository_remote.dart';
import 'package:bout/data/repositories/cache/cache_repository.dart';
import 'package:bout/data/repositories/cache/cache_repository_dev.dart';
import 'package:bout/data/repositories/cache/cache_repository_remote.dart';
import 'package:bout/data/repositories/match/match_repository.dart';
import 'package:bout/data/repositories/match/match_repository_dev.dart';
import 'package:bout/data/repositories/match/match_repository_remote.dart';
import 'package:bout/data/repositories/user/user_repository.dart';
import 'package:bout/data/repositories/user/user_repository_dev.dart';
import 'package:bout/data/repositories/user/user_repository_remote.dart';
import 'package:bout/data/services/api_client.dart';
import 'package:bout/data/services/appwrite_api_client.dart';
import 'package:bout/data/services/appwrite_client.dart';
import 'package:bout/data/services/auth/appwrite_auth_client.dart';
import 'package:bout/data/services/auth/auth_client.dart';
import 'package:bout/data/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providersRemote {
  return [
    Provider(create: (context) => AppwriteClient()),
    Provider(create: (context) => AppwriteAuthClient(appwriteClient: context.read()) as AuthClient),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(create: (context) => AppwriteApiClient(context.read()) as ApiClient),

    ChangeNotifierProvider(
      create:
          (context) =>
              AuthRepositoryRemote(
                    authApiClient: context.read(),
                    sharedPreferencesService: context.read(),
                  )
                  as AuthRepository,
    ),
    Provider(
      create:
          (context) =>
              UserRepositoryRemote(authClient: context.read())
                  as UserRepository,
    ),
    Provider(
      create:
          (context) => MatchRepositoryRemote(context.read()) as MatchRepository,
    ),
    Provider(create: (context) => CacheRepositoryRemote(context.read()) as CacheRepository)
  ];
}

List<SingleChildWidget> get providersLocal {
  return [
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryDev() as AuthRepository,
    ),
    Provider(create: (context) => UserRepositoryDev() as UserRepository),
    Provider(create: (context) => MatchRepositoryDev() as MatchRepository),
    Provider(create: (context) => CacheRepositoryDev() as CacheRepository)
  ];
}
