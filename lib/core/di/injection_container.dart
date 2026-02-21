import 'package:get_it/get_it.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/topics/data/repositories/topic_repository_impl.dart';
import '../../features/topics/domain/repositories/topic_repository.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(),
  );

  // Topics
  sl.registerLazySingleton<TopicRepository>(
    () => TopicRepositoryImpl(),
  );
}
