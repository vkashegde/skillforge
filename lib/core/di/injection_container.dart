import 'package:get_it/get_it.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  // TODO: Register dependencies here
  // Example:
  // sl.registerLazySingleton(() => SomeService());
}
